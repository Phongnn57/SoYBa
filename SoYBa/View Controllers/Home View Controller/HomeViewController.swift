//
//  HomeViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SummaryCellDelegate, EnbacAlertPopupDelegate, EditInjectionViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, SwitchPatientViewControllerDelegate {
    
    @IBOutlet var tableview1: UITableView!
    @IBOutlet var tableview2: UITableView!
    @IBOutlet var tableview3: UITableView!
    @IBOutlet weak var topscrollview: TopScrollView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var btnSumary: UIButton!
    @IBOutlet weak var btnDetail: UIButton!
    @IBOutlet weak var btnInjectionSchedule: UIButton!
    var btnSwitchPatient: UIBarButtonItem!
    
    private let SummaryCellIdentifier = "SummaryCell"
    private let DetailCellIdentifier = "DetailCell"
    private let InjectionScheduleCellIdentifier = "InjectionScheduleCell"
    
    var sicks: [Sick]!
    var injectionSchedule: [Injection_Schedule]!
    var patients: [Patient]!
    var currentPatient: Patient!
    var patientInjections: [Patient_Injection]!
    var selectedPatientInjection: Patient_Injection!
    var summaryData: Array<AnyObject> = Array<AnyObject>()
    var detailData: Array<AnyObject> = Array<AnyObject>()
    var injectionScheduleData: Array<AnyObject> = Array<AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configNavigationBarWithTitle("Sổ tiêm chủng")
        self.initializeData()
        self.initializeTableView()
        
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem()
        self.initializeSwitchBtn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.initializeScrollView()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func initializeSwitchBtn() {
        var btn = UIButton.buttonWithType(.Custom) as! UIButton
        btn.setImage(UIImage(named: "switch"), forState: .Normal)
        btn.frame = CGRectMake(0, 0, 28, 28)
        btn.addTarget(self, action: "switchPatient", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnSwitchPatient = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = self.btnSwitchPatient
    }
    
    // MARK: HANDLE DATA MODEL
    func initializeData() {
        self.sicks = Sick.MR_findAll() as! [Sick]
        self.injectionSchedule = Injection_Schedule.MR_findAll() as! [Injection_Schedule]
        self.patients = Patient.MR_findAll() as! [Patient]
        if self.currentPatient == nil {
            self.currentPatient = self.patients.first
        }

        self.loadData()
    }
    
    func loadData() {
        self.patientInjections = Patient_Injection.MR_findAllWithPredicate(NSPredicate(format: "patientID = \(self.currentPatient.id)")) as! [Patient_Injection]
        self.summaryData =  self.groupPatientInjectionBySick()
        self.detailData = self.groupPatientInjectionByInjectDay()
        self.injectionScheduleData = self.groupInjectionSchedule()
    }
    
    func groupPatientInjectionBySick() -> Array<AnyObject>{
        var tmpSickIDArr: [Int] = []
        for obj in self.patientInjections {
            var mark: Bool = true
            for eachID in tmpSickIDArr {
                if eachID == obj.sickID.integerValue {
                    mark = false
                    break
                }
            }
            if mark {
                tmpSickIDArr.append(obj.sickID.integerValue)
            }
        }
        
        var tmpGroupPatientInjection: Array<AnyObject> = Array<AnyObject>()
        for eachSichID in tmpSickIDArr {
            var tmpPatientInjectionArr: [Patient_Injection] = []
            for eachPatientInjection in self.patientInjections {
                if eachSichID == eachPatientInjection.sickID.integerValue {
                    tmpPatientInjectionArr.append(eachPatientInjection)
                }
            }

            for var i = 0 ; i < tmpPatientInjectionArr.count - 1; i++ {
                for var j = i+1 ; j < tmpPatientInjectionArr.count; j++ {
                    if tmpPatientInjectionArr[i].number.integerValue > tmpPatientInjectionArr[j].number.integerValue {
                        var tmpNumber = tmpPatientInjectionArr[i].number
                        tmpPatientInjectionArr[i].number = tmpPatientInjectionArr[j].number
                        tmpPatientInjectionArr[j].number = tmpNumber
                    }
                }
            }
            
            tmpGroupPatientInjection.append(tmpPatientInjectionArr)
        }
        return tmpGroupPatientInjection
    }
    
    func groupPatientInjectionByInjectDay() ->Array<AnyObject> {
        var tmpDic: Array<AnyObject> = Array<AnyObject>()
        var tmpInjection: Array<AnyObject> = []
        
        var tmpArrID: Array<Int> = []
        
        for obj in self.patientInjections {
            var mark: Bool = false
            for eachID in tmpArrID {
                if obj.inject_day.month + obj.inject_day.year == eachID {
                    mark = true
                    break
                }
            }
            if !mark {
                tmpArrID.append(obj.inject_day.month + obj.inject_day.year)
            }
        }
        
        for sickID in tmpArrID {
            var injec: Array<Patient_Injection> = []
            for obj in self.patientInjections {
                if obj.inject_day.month + obj.inject_day.year == sickID {
                    injec.append(obj)
                }
            }
            tmpInjection.append(injec)
        }
        
        return tmpInjection
    }
    
    func groupInjectionSchedule() -> Array<AnyObject> {
        let _tmpInjectionSchedule = Injection_Schedule.MR_findAllSortedBy("month", ascending: true) as! [Injection_Schedule]
        var tmpInjectionSchedule: Array<Injection_Schedule> = []
        for obj in _tmpInjectionSchedule {
            for _obj in self.patientInjections {
                if obj.sick == _obj.sickID {
                    tmpInjectionSchedule.append(obj)
                    break
                }
            }
        }
        
        var tmpDic: Array<AnyObject> = Array<AnyObject>()
        var tmpMonth: Array<NSNumber> = []
        
        for obj in tmpInjectionSchedule {
            var mark: Bool = false
            for eachMonth in tmpMonth {
                if obj.month == eachMonth {
                    mark = true
                    break
                }
            }
            if !mark {
                tmpMonth.append(obj.month)
            }
        }
        
        for eachMonth in tmpMonth {
            var schedule: Array<Injection_Schedule> = []
            for obj in tmpInjectionSchedule {
                if obj.month == eachMonth {
                    schedule.append(obj)
                }
            }
            tmpDic.append(schedule)
        }
        
        return tmpDic
    }
    
    func initializeTableView() {
        self.tableview1.registerNib(UINib(nibName: SummaryCellIdentifier, bundle: nil), forCellReuseIdentifier: SummaryCellIdentifier)
        self.tableview2.registerNib(UINib(nibName: DetailCellIdentifier, bundle: nil), forCellReuseIdentifier: DetailCellIdentifier)
        self.tableview3.registerNib(UINib(nibName: InjectionScheduleCellIdentifier, bundle: nil), forCellReuseIdentifier: InjectionScheduleCellIdentifier)
    }
    
    // MARK: UITABLEVIEW
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView.isEqual(self.tableview2) {
            return self.detailData.count
        } else if tableView.isEqual(self.tableview3) {
            return self.injectionScheduleData.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(self.tableview1) {
            return self.summaryData.count
        } else if tableView.isEqual(self.tableview2) {
            return (self.detailData[section] as! Array<Patient_Injection>).count
        } else if tableView.isEqual(self.tableview3) {
            return (self.injectionScheduleData[section] as! Array<Injection_Schedule>).count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.isEqual(self.tableview1) {
            let cell = tableView.dequeueReusableCellWithIdentifier(SummaryCellIdentifier) as! SummaryCell
            cell.configCellWithSick(self.summaryData[indexPath.row] as! Array<Patient_Injection>)
            cell.delegate = self
            return cell
        } else if tableView.isEqual(self.tableview2) {
            let cell = tableView.dequeueReusableCellWithIdentifier(DetailCellIdentifier) as! DetailCell
            cell.configCellWithPatientInjection((self.detailData[indexPath.section] as! Array<Patient_Injection>)[indexPath.row])
            return cell
        } else if tableView.isEqual(self.tableview3) {
            let cell = tableView.dequeueReusableCellWithIdentifier(InjectionScheduleCellIdentifier) as! InjectionScheduleCell
            let schedules: Array<Injection_Schedule> = self.injectionScheduleData[indexPath.section] as! Array<Injection_Schedule>
            let schedule = schedules[indexPath.row]
            cell.configCellWithInjection(schedule)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.isEqual(self.tableview3) {
            let schedules: Array<Injection_Schedule> = self.injectionScheduleData[indexPath.section] as! Array<Injection_Schedule>
            let schedule = schedules[indexPath.row]
            let sick = Sick.MR_findFirstWithPredicate(NSPredicate(format: "id = \(schedule.sick)")) as! Sick
            
            let infoSick = EnbacAlertPopup(title: sick.sickName, longText: sick.descrip, cancelButtonTitle: nil, doneButtonTitle: "Đóng")
            infoSick.openPopup()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.isEqual(self.tableview2) {
            let day = (self.detailData[section] as! Array<Patient_Injection>).first!.inject_day
            return "Tháng " + "\(day.month)" + "/" + "\(day.year)"
        } else if tableView.isEqual(self.tableview3) {
            let month = (self.injectionScheduleData[section] as! Array<Injection_Schedule>).first!.month
            if month.integerValue == 0 {
                return "Sơ sinh"
            } else if month.integerValue%12 == 0 {
                return "\(month.integerValue/12) tuổi"
            } else if month.integerValue < 12 {
                return "\(month)" + " tháng"
            } else {
                return "\(month.integerValue/12) tuổi, \(month.integerValue%12)" + " tháng"
            }
        }
        return ""
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.isEqual(self.tableview2) || tableView.isEqual(self.tableview3) {
            return 44
        }
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.isEqual(self.tableview2) {
            let injection = (self.detailData[indexPath.section] as! Array<Patient_Injection>)[indexPath.row]
            let sick = Sick.MR_findFirstWithPredicate(NSPredicate(format: "id = \(injection.sickID)")) as! Sick
            return DetailCell.calculateCellHeigh(sick.sickName)
        } else if tableView.isEqual(self.tableview3) {
            let schedules: Array<Injection_Schedule> = self.injectionScheduleData[indexPath.section] as! Array<Injection_Schedule>
            let schedule = schedules[indexPath.row]
            let sick = Sick.MR_findFirstWithPredicate(NSPredicate(format: "id = \(schedule.sick)")) as! Sick
            return InjectionScheduleCell.calculateCellHeigh(sick.sickName)
        } else if tableView.isEqual(self.tableview1) {
            return 60
        }
        return 60
    }
    
    // MARK: DELEGATE
    func didSelectButtonAtCellAndIndex(cell: SummaryCell, btnIndex: Int) {
        let indexPath: NSIndexPath = self.tableview1.indexPathForCell(cell)!
        let injections: Array<Patient_Injection> = self.summaryData[indexPath.row] as! Array<Patient_Injection>
        let patientInjection = injections[btnIndex]
        self.selectedPatientInjection = patientInjection

        let infoPopup = EnbacAlertPopup(title: "Thông tin mũi tiêm", injectionCount: patientInjection.number.integerValue, injectionName: cell.name.text, injectionDay: patientInjection.inject_day.toString(), injectionStatus: patientInjection.isDone.integerValue == 0 ?  "Chưa hoàn thành" : "Hoàn thành", note: patientInjection.note ?? "", cancelButtonTitle: "Xong", doneButtonTitle: "Chỉnh sửa")
        infoPopup.tag = 100
        infoPopup.delegate = self
        infoPopup.openPopup()
    }
    
    func didUpdateSuccessfull() {
        self.initializeData()
        self.tableview1.reloadData()
    }
    
    func didFinishSelectPatient(patient: Patient) {
        self.currentPatient = patient
        self.loadData()
        self.tableview1.reloadData()
        self.tableview2.reloadData()
        self.tableview3.reloadData()
    }
    
    // MARK: ALERT POPUP
    func alertPopupDidSelectCancelButton(alertView: UIView, extraTag: Int) {
        self.selectedPatientInjection = nil
    }
    
    func alertPopupDidSelectDoneButton(alertView: UIView, extraTag: Int) {
        if alertView.tag == 100 {
            let editInjectionViewController = EditInjectionViewController()
            editInjectionViewController.patientInjection = self.selectedPatientInjection
            editInjectionViewController.delegate = self
            self.presentViewController(editInjectionViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: BUTTON ACTION 
    
    func switchPatient() {
        let switchPatient = SwitchPatientViewController()
        switchPatient.delegate = self
        self.navigationController?.pushViewController(switchPatient, animated: true)
    }
    
    @IBAction func didSelectSummaryBtn(sender: AnyObject) {
    }

    @IBAction func didSelectDetailBtn(sender: AnyObject) {
    }
    
    @IBAction func didSelectInjectionScheduleBtn(sender: AnyObject) {
    }
    
    // MARK: PICKER VIEW
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BloodType.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return BloodType[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.bloodType.text = BloodType[row]
    }
    
    // MARK: UISCROLLVIEW 
    func initializeScrollView() {
        
        
        self.tableview1.frame = CGRectMake(0, 0, SCREEN_SIZE.width, self.scrollview.size.height)
        self.tableview2.frame = CGRectMake(SCREEN_SIZE.width, 0, SCREEN_SIZE.width, self.scrollview.size.height)
        self.tableview3.frame = CGRectMake(SCREEN_SIZE.width * 2, 0, SCREEN_SIZE.width, self.scrollview.size.height)
        self.scrollview.addSubview(self.tableview1)
        self.scrollview.addSubview(self.tableview2)
        self.scrollview.addSubview(self.tableview3)
        self.scrollview.contentSize = CGSizeMake(SCREEN_SIZE.width * 3, self.scrollview.size.height)
        self.scrollview.tag = 1
        
        self.topscrollview.onMenuChange = {(index) -> Void in
            self.scrollview.setContentOffset(CGPointMake(SCREEN_SIZE.width*CGFloat(index), 0), animated: false)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(scrollView.tag == 1 && scrollView.dragging) {
            let index = Int(round(scrollView.contentOffset.x / SCREEN_SIZE.width))
            let offsetX = scrollView.contentOffset.x - (CGFloat(index) * SCREEN_SIZE.width)
            self.topscrollview.moveUnderLine(offsetX, index: index)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView.tag == 1){
            let index = Int(round(scrollView.contentOffset.x / SCREEN_SIZE.width))
            if(index >= 0 && index < 3){
                self.topscrollview.selectItemAtIndex(index, animated: true)
            }
        }
    }
}
