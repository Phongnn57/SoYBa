//
//  EditInjectionViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 9/5/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

protocol EditInjectionViewControllerDelegate {
    func didUpdateSuccessfull()
}

class EditInjectionViewController: BaseViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var sView: UIView!
    @IBOutlet weak var btnInjectDone: UIButton!
    
    var patientInjection: Patient_Injection!
    var delegate: EditInjectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeData()
        self.configDatePickerPopup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeData() {
        let sick = Sick.MR_findFirstWithPredicate(NSPredicate(format: "id = \(self.patientInjection.sickID)")) as! Sick
        self.name.text = sick.sickName
        self.count.text = "Mũi thứ: \(self.patientInjection.number)"
        self.time.text = self.patientInjection.inject_day.toString()
        self.note.text = self.patientInjection.note
        if self.patientInjection.isDone.integerValue == 1 {
            self.btnInjectDone.setImage(UIImage(named: "check"), forState: .Normal)
        } else {
            self.btnInjectDone.setImage(UIImage(named: "uncheck"), forState: .Normal)
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
    }
    
    func hideKeyboard() {
        self.time.resignFirstResponder()
        self.note.resignFirstResponder()
    }
    
    func configDatePickerPopup() {
        let datePicker = UIDatePicker()
        datePicker.frame = CGRectMake(0, 0, datePicker.frame.size.width, 200)
        datePicker.datePickerMode = UIDatePickerMode.Date
        datePicker.addTarget(self, action: "datePickerDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        self.time.inputView = datePicker
    }
    
    // MARK: BUTTON ACTION
    func datePickerDidChange(datePicker: UIDatePicker) {
        self.time.text = datePicker.date.toString()
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        
        if (self.time.text.toDate(format: "dd-MM-yyyy")!.isAfter(NSDate()) && self.patientInjection.isDone.integerValue == 1) {
            self.view.makeToast("Chưa đến ngày này mà", duration: 2, position: CSToastPositionTop)
            return
        }
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
        PatientAPI.updatePatientInjectionSchedule(self.patientInjection.patientID.integerValue, sickID: self.patientInjection.sickID.integerValue, number: self.patientInjection.number.integerValue, injectDay: self.patientInjection.inject_day.toString(), isDone: self.patientInjection.isDone.integerValue, vacName: self.patientInjection.vacName, note: self.note.text ?? "", lastUpdated: Int(NSDate().timeIntervalSince1970), completion: { () -> Void in
            MRProgressOverlayView.dismissAllOverlaysForView(self.view, animated: true)
            self.patientInjection.note = self.note.text
            NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
            self.view.makeToast("Cập nhật thành công", duration: 2, position: CSToastPositionTop)
            self.delegate?.didUpdateSuccessfull()
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error) -> Void in
            MRProgressOverlayView.dismissAllOverlaysForView(self.view, animated: true)
            self.view.makeToast("Có lỗi xảy ra! Vui lòng thử lại sau", duration: 2, position: CSToastPositionTop)
        }
    }
    
    @IBAction func didSelectToday(sender: AnyObject) {
        let today = NSDate()
        self.time.text = today.toString()
        self.patientInjection.inject_day = self.time.text.toDate(format: "dd-MM-yyyy")!
    }
    
    @IBAction func didSelectInjectDone(sender: AnyObject) {
        if self.patientInjection.isDone.integerValue == 0 {
            self.patientInjection.isDone = 1
        } else {
            self.patientInjection.isDone = 0
        }
        if self.patientInjection.isDone.integerValue == 1 {
            self.btnInjectDone.setImage(UIImage(named: "check"), forState: .Normal)
        } else {
            self.btnInjectDone.setImage(UIImage(named: "uncheck"), forState: .Normal)
        }
    }
    
    
}
