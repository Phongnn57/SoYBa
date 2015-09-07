//
//  AddPatientViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

protocol AddPatientViewControllerDelegate {
    func didFinishCreatePatient(patient: Patient)
}

class AddPatientViewController: BaseViewController, BSKeyboardControlsDelegate, UIPickerViewDataSource, UIPickerViewDelegate, VaccineSelectionViewControllerDelegate {

    var btnSave: UIBarButtonItem!
    var genderSwitch: SevenSwitch!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var vaccineSelection: UITextField!
    @IBOutlet weak var relationShip: UITextField!
    @IBOutlet weak var bloodType: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet var contentview: UIView!
    @IBOutlet weak var firstview: UIView!
    @IBOutlet weak var btnSelectVaccine: UIButton!
    @IBOutlet weak var editInfo: UILabel!
    
    var datePicker: UIDatePicker!
    var selectedSickIDs: [Int]!
    var keyboardControls:BSKeyboardControls!
    var keyboardHeight:CGFloat? = (SCREEN_SIZE.height / 2.0)
    var isUpdate: Bool = false
    var patient: Patient!
    var delegate:AddPatientViewControllerDelegate?
    var sicks: [Sick]!
    
    var createFirstPatient: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.sicks = Sick.MR_findAll() as! [Sick]
        self.navigationController?.navigationBarHidden = false
        self.isUpdate == true ? self.configNavigationBarWithTitle("Sửa thông tin thành viên") : self.configNavigationBarWithTitle("Thêm thành viên")
        self.selectedSickIDs = []
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: INITIALIZE
    func initialize() {
        self.contentview.frame = CGRectMake(0, 0, SCREEN_SIZE.width, self.contentview.frame.size.height)
        self.scrollview.addSubview(self.contentview)
        self.scrollview.contentSize = CGSizeMake(SCREEN_SIZE.width, self.contentview.frame.size.height)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))

        self.initializeSwitch()
        self.configNavigation()
        self.configDatePickerPopup()
        self.configPickerView()
        
        if self.isUpdate && self.patient != nil{
            self.keyboardControls = BSKeyboardControls(fields: [self.name, self.relationShip, self.bloodType, self.height,self.weight])
            self.editInfo.hidden = false
            self.genderSwitch.enabled = false
            self.dob.enabled = false
            self.vaccineSelection.userInteractionEnabled = false
            self.btnSelectVaccine.userInteractionEnabled = false
            self.name.text = self.patient.name
            self.dob.text = self.patient.dob.toString()
            self.relationShip.text = self.patient.relationshipWithUser
            self.bloodType.text = self.patient.bloodType
            self.genderSwitch.on = (self.patient.gender.integerValue == 0)
            
            var tmpPatientSick = Patient_Sick.MR_findAllWithPredicate(NSPredicate(format: "patientID = \(self.patient.id)")) as! [Patient_Sick]
            if tmpPatientSick.count > 0{
                for obj in tmpPatientSick {
                    self.selectedSickIDs.append(obj.sickID.integerValue)
                }
            }
            if self.selectedSickIDs.count > 0 {
                var str: String = " Đã chọn: "
                for obj in self.selectedSickIDs {
                    for _obj in self.sicks {
                        if obj == _obj.id {
                            if obj != self.selectedSickIDs.last {
                                str = str + _obj.sickName + ", "
                            } else {
                                str = str + _obj.sickName
                            }
                            break
                        }
                    }
                }
                self.vaccineSelection.text = str
            }
            
        } else {
            self.editInfo.hidden = true
            self.keyboardControls = BSKeyboardControls(fields: [self.name, self.dob, self.relationShip, self.bloodType, self.height, self.weight])
        }
        
        self.keyboardControls.delegate = self
        self.keyboardControls.doneTitle = "Lưu lại"
    }
    
    func hideKeyboard() {
        self.bloodType.resignFirstResponder()
        self.relationShip.resignFirstResponder()
        self.name.resignFirstResponder()
        self.height.resignFirstResponder()
        self.weight.resignFirstResponder()
        self.dob.resignFirstResponder()
    }
    
    func configDatePickerPopup() {
        let datePicker = UIDatePicker()
        datePicker.frame = CGRectMake(0, 0, datePicker.frame.size.width, 200)
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: "datePickerDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        self.dob.inputView = datePicker
    }
    
    func datePickerDidChange(datePicker: UIDatePicker) {
        self.dob.text = datePicker.date.toString()
    }
    
    func configPickerView() {
        var pickerView = UIPickerView()
        pickerView.frame = CGRectMake(0, 0, pickerView.frame.size.width, 200)
        pickerView.dataSource = self
        pickerView.delegate = self
        self.bloodType.inputView = pickerView
    }
    
    func configNavigation() {
        let btn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btn.setImage(UIImage(named: "back"), forState: .Normal)
        btn.frame = CGRectMake(0, 0, 14, 22)
        btn.addTarget(self, action: "backToParentView", forControlEvents: UIControlEvents.TouchUpInside)
        let barBtn = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = barBtn
        
        self.btnSave = UIBarButtonItem(title: "Lưu lại", style: UIBarButtonItemStyle.Plain, target: self, action: "savePatient")
        self.navigationItem.rightBarButtonItem = self.btnSave
    }
    
    func initializeSwitch() {
        self.genderSwitch = SevenSwitch()
        self.genderSwitch.frame = CGRectMake(SCREEN_SIZE.width - 80, 71, 70, 30)
        self.genderSwitch.onLabel.text = "Nam"
        self.genderSwitch.offLabel.text = "Nữ"
        self.genderSwitch.activeColor = UIColor(rgba: "#328efe")
        self.genderSwitch.onTintColor =  UIColor(red: 50/255, green: 142/255, blue: 254/255, alpha: 1)
        self.genderSwitch.inactiveColor = UIColor(red: 226/255, green: 226/255, blue: 226/255, alpha: 1)
        self.genderSwitch.offLabel.textColor = UIColor.blackColor()
        self.genderSwitch.onLabel.textColor = UIColor.blackColor()
        self.genderSwitch.addTarget(self, action: "switchChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.contentview.addSubview(self.genderSwitch)
    }
    
    // MARK: SWITCH
    func switchChanged(sender: SevenSwitch) {
        
    }
    
    // MARK: BUTTON ACTION
    @IBAction func moveToSelectVaccine(sender: AnyObject) {
        let vaccineselectionViewController = VaccineSelectionViewController()
        vaccineselectionViewController.delegate = self
        vaccineselectionViewController.selectedSickIDs = self.selectedSickIDs
        self.navigationController?.pushViewController(vaccineselectionViewController, animated: true)
    }
    
    func vaccineDidFinishSelect(vaccines: [Vaccine]!) {
        if vaccines.count == 0 {
            self.vaccineSelection.text = nil
            self.selectedSickIDs = []
            return
        }
        var str: String = "Đã chọn: "
        self.selectedSickIDs = []
        for vaccine in vaccines {
            self.selectedSickIDs.append(vaccine.sick.id.integerValue)
            if vaccine.sick.id != vaccines.last?.sick.id {
                str = str + vaccine.sick.sickName + ", "
            } else {
                str = str + vaccine.sick.sickName
            }
        }
        self.vaccineSelection.text = str
    }
    
    func backToParentView() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func savePatient() {
        self.hideKeyboard()
        
        if self.isAvailableToSave() {
            if !self.isUpdate {
                let newPatient = Patient.MR_createEntity() as! Patient
                newPatient.name = self.name.text
                newPatient.dob = self.dob.text.toDate(format: "dd-MM-yyyy")!
                newPatient.gender = self.genderSwitch.on == true ? 0: 1
                newPatient.bloodType = self.bloodType.text
                newPatient.relationshipWithUser = self.relationShip.text
                newPatient.userID = UserObject.sharedUser.userID
                newPatient.lastUpdated = NSDate()
                
                MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Đang tạo...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
                PatientAPI.createPatientUser(newPatient.name, dob: newPatient.dob.toString(), gender: newPatient.gender.integerValue, userID: UserObject.sharedUser.userID, relationShip: newPatient.relationshipWithUser, bloodType: newPatient.bloodType, completion: { (patientID) -> Void in
                    
                    SickAPI.createSickUser(patientID.integerValue, sick: self.selectedSickIDs, isUpdate: false,completion: { () -> Void in
                        
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                        
                        newPatient.id = patientID
                        NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
                        
                        for sickID in self.selectedSickIDs {
                            let newPatientSick = Patient_Sick.MR_createEntity() as! Patient_Sick
                            newPatientSick.patientID = patientID
                            newPatientSick.sickID = sickID
                            NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
                            
                            if let injectionSchedule: [Injection_Schedule] = Injection_Schedule.MR_findAllWithPredicate(NSPredicate(format: "sick = \(sickID)")) as? [Injection_Schedule] {
                                
                                for _injectionSchedule in injectionSchedule {
                                    
                                    let injecSche: Injection_Schedule = _injectionSchedule as Injection_Schedule
                                    
                                    let patientInjection = Patient_Injection.MR_createEntity() as! Patient_Injection
                                    patientInjection.isDone = 0
                                    patientInjection.patientID = newPatient.id
                                    patientInjection.sickID = sickID
                                    patientInjection.inject_day = newPatient.dob.addMonths(injecSche.month.integerValue)
                                    patientInjection.number = injecSche.number
                                    patientInjection.last_updated = NSDate()
                                    patientInjection.note = ""
                                    NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
                                }
                            }
                        }
                        
                        if self.createFirstPatient {
                            DELEGATE.startApp()
                        } else {
                            self.delegate?.didFinishCreatePatient(newPatient)
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        }

                        }, failure: { (error) -> Void in
                            self.view.makeToast("Có lỗi xảy ra! Vui lòng thử lại")
                            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    })
                    
                    }) { (error) -> Void in
                        self.view.makeToast(error)
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                }
            } else {
                MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Đang cập nhật...", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
                PatientAPI.updatePatientUser(self.patient.id.integerValue, name: self.name.text, relationShip: self.relationShip.text, bloodType: self.bloodType.text, lastUpdated: Int(NSDate().timeIntervalSince1970), completion: { () -> Void in
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    self.patient.name = self.name.text
                    self.patient.relationshipWithUser = self.relationShip.text
                    self.patient.bloodType = self.bloodType.text
                    self.patient.lastUpdated = NSDate()
                    NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
                    self.delegate?.didFinishCreatePatient(self.patient)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                    }, failure: { (error) -> Void in
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                        self.view.makeToast(error)
                })
            }
        }
    }
    
    func isAvailableToSave() ->Bool{
        if self.name.text.isEmpty {
            self.view.makeToast("Vui lòng điền họ tên", duration: 2, position: CSToastPositionTop)
            return false
        }
        if self.dob.text.isEmpty {
            self.view.makeToast("Vui lòng  chọn ngày tháng năm sinh", duration: 2, position: CSToastPositionTop)
            return false
        }
        if self.relationShip.text.isEmpty {
            self.view.makeToast("Vui lòng điền quan hệ của bệnh nhân với bạn", duration: 2, position: CSToastPositionTop)
            return false
        }
        if self.bloodType.text.isEmpty {
            self.view.makeToast("Vui lòng chọn nhóm máu", duration: 2, position: CSToastPositionTop)
            return false
        }
        if self.selectedSickIDs == nil || self.selectedSickIDs.count <= 0 {
            self.view.makeToast("Vui lòng chọn các loại vắc xin", duration: 2, position: CSToastPositionTop)
            return false
        }
        return true
    }
    
    // MARK: 
    func keyboardControls(keyboardControls: BSKeyboardControls!, selectedField field: UIView!, inDirection direction: BSKeyboardControlsDirection) {
        field.becomeFirstResponder()
    }
    
    func keyboardControlsDonePressed(keyboardControls: BSKeyboardControls!) {
        self.hideKeyboard()
        self.scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
        self.keyboardControls.activeField = nil
        
        self.savePatient()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.hideToastActivity()
        self.keyboardControls.activeField = textField
        self.scrollToTextField(textField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
        self.keyboardControls.activeField = nil
        return true
    }
    
    func scrollToTextField(textField: UITextField) {
        let textFieldPosY:CGFloat = textField.superview!.frame.origin.y + textField.frame.origin.y
        if(self.view.frame.size.height - (textFieldPosY + textField.frame.size.height) < self.keyboardHeight){
            self.scrollview.setContentOffset(CGPointMake(0, self.keyboardHeight! - (self.view.frame.size.height - (textFieldPosY + textField.frame.size.height))), animated: true)
        }else{
            self.scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    // MARK: TEXTFIELD AND KEYBOARD
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.keyboardHeight = keyboardSize.height
                self.scrollToTextField(keyboardControls.activeField as! UITextField)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.hideKeyboard()
        self.scrollview.setContentOffset(CGPointMake(0, 0), animated: true)
        self.keyboardControls.activeField = nil
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
        self.bloodType.text = BloodType[row]
    }

}
