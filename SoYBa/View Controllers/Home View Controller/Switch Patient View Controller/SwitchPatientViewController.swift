//
//  SwitchPatientViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 9/6/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

protocol SwitchPatientViewControllerDelegate {
    func didFinishSelectPatient(patient: Patient)
}

class SwitchPatientViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    private let CellIdentifier = "PatientCell"
    var patients: [Patient]!
    var delegate: SwitchPatientViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configNavigationBarWithTitle("Chọn bệnh nhân")
        self.configNavigation()
        self.patients = Patient.MR_findAll() as! [Patient]
        self.tableview.registerNib(UINib(nibName: CellIdentifier, bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configNavigation() {
        let btn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btn.setImage(UIImage(named: "back"), forState: .Normal)
        btn.frame = CGRectMake(0, 0, 14, 22)
        btn.addTarget(self, action: "backToParentView", forControlEvents: UIControlEvents.TouchUpInside)
        let barBtn = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = barBtn
    }
    
    func backToParentView() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // MARK: TABLEVIEW DELEGATE
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! PatientCell
        cell.configCellWithPatient(self.patients[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let patient = self.patients[indexPath.row]
        self.delegate?.didFinishSelectPatient(patient)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patients.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    
    

}
