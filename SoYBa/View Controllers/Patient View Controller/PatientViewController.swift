//
//  PatientViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class PatientViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, AddPatientViewControllerDelegate {
    
    var btnAddPatient: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    
    private let CellIdentifier = "PatientCell"
    var patients: [Patient]!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configNavigationBarWithTitle("Quản lí thành viên")
        self.btnAddPatient = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "moveToAddPatient")
        self.navigationItem.rightBarButtonItem = self.btnAddPatient
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem()
        self.patients = Patient.MR_findAll() as! [Patient]
        self.tableview.registerNib(UINib(nibName: CellIdentifier, bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    // MARK: BUTTON ACTION
    func moveToAddPatient() {
        let addPatientViewController = AddPatientViewController()
        addPatientViewController.delegate = self
        self.navigationController?.pushViewController(addPatientViewController, animated: true)
    }
    
    // MARK: TABLEVIEW METHODS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! PatientCell
        cell.configCellWithPatient(self.patients[indexPath.row])
        cell.rightUtilityButtons = self.rightButtons() as [AnyObject]
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    // MARK: TABLEVIEW CELL
    func rightButtons() -> NSMutableArray {
        let rightUtilityButtons = NSMutableArray()
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor(rgba: "#35a616"), icon: UIImage(named: "edit"))
        rightUtilityButtons.sw_addUtilityButtonWithColor(UIColor(rgba: "#ff0000"), icon: UIImage(named: "delete"))
        
        return rightUtilityButtons
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        let indexpath: NSIndexPath = self.tableview.indexPathForCell(cell)!
        cell.hideUtilityButtonsAnimated(true)
        if index == 0 {
            let addMember = AddPatientViewController()
            addMember.isUpdate = true
            addMember.delegate = self
            addMember.patient = self.patients[indexpath.row]
            self.navigationController?.pushViewController(addMember, animated: true)
        } else if index == 1 {
            PatientAPI.deleteAPatient(self.patients[indexpath.row].id.integerValue, completion: { () -> Void in
                self.patients[indexpath.row].MR_deleteEntity()
                self.patients.removeAtIndex(indexpath.row)
                NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
                self.tableview.deleteRowsAtIndexPaths([indexpath], withRowAnimation: .Fade)
                }, failure: { (error) -> Void in
                    self.view.makeToast(error)
            })
        }
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    // MARK: DELEGATE
    func didFinishCreatePatient(patient: Patient) {
        self.patients = Patient.MR_findAll() as! [Patient]
        self.tableview.reloadData()
        NSNotificationCenter.defaultCenter().postNotificationName("reloadpatient", object: nil)
    }
}
