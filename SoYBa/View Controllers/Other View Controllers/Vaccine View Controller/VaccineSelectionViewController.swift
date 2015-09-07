//
//  VaccineSelectionViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 9/1/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

protocol VaccineSelectionViewControllerDelegate {
    func vaccineDidFinishSelect(vaccines: [Vaccine]!)
}

class Vaccine {
    var sick: Sick
    var isSelect: Bool
    
    init(sick: Sick, selected: Bool) {
        self.sick = sick
        self.isSelect = selected
    }
}

class VaccineSelectionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    private let CellIdentifier = "VaccineCell"
    var btnSave: UIBarButtonItem!
    var delegate: VaccineSelectionViewControllerDelegate?
    var sicks: [Sick]!
    var vaccines: [Vaccine]!
    var selectedVaccine: [Vaccine]!
    var selectedSickIDs: [Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configNavigationBarWithTitle("Chọn Vắc xin")
        self.configNavigation()
        self.btnSave = UIBarButtonItem(title: "Xong", style: UIBarButtonItemStyle.Plain, target: self, action: "backToParentView")
        self.navigationItem.rightBarButtonItem = self.btnSave
        self.intialize()
        self.tableview.registerNib(UINib(nibName: CellIdentifier, bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configNavigation() {
        let btn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        btn.setImage(UIImage(named: "back"), forState: .Normal)
        btn.frame = CGRectMake(0, 0, 14, 22)
        btn.addTarget(self, action: "cancelSelection", forControlEvents: UIControlEvents.TouchUpInside)
        let barBtn = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = barBtn
    }
    
    // MARK: INITIALIZE DATA
    
    func intialize() {
        self.sicks = Sick.MR_findAll() as! [Sick]
        self.vaccines = []
        self.selectedVaccine = []
        for sick in self.sicks {
            var mark: Bool = false
            if self.selectedSickIDs != nil && self.selectedSickIDs.count > 0 {
                for sickID in self.selectedSickIDs {
                    if sick.id.integerValue == sickID {
                        mark = true
                        break
                    }
                }
            }
            let vaccine = Vaccine(sick: sick, selected: mark)
            self.vaccines.append(vaccine)
        }
    }
    
    func getSelectedSickIDArray() -> [Vaccine]! {
        for vaccine in self.vaccines {
            if vaccine.isSelect {
                self.selectedVaccine.append(vaccine)
            }
        }
        return self.selectedVaccine
    }
    
    // MARK: BUTTON ACTION
    func cancelSelection() {
        let viewControllers = self.navigationController!.viewControllers
        let viewController = viewControllers[viewControllers.count - 2] as! UIViewController
        self.navigationController?.popToViewController(viewController, animated: true)
    }
    
    func backToParentView() {
        self.delegate?.vaccineDidFinishSelect(self.getSelectedSickIDArray())
        let viewControllers = self.navigationController!.viewControllers
        let viewController = viewControllers[viewControllers.count - 2] as! UIViewController
        self.navigationController?.popToViewController(viewController, animated: true)
    }
    
    @IBAction func selectAllVaccine(sender: AnyObject) {
        for vaccine in self.vaccines {
            if vaccine.sick.id != 3 {
                vaccine.isSelect = true
            } else {
                vaccine.isSelect = false
            }
        }
        self.tableview.reloadData()
    }

    
    // MARK: TABLEVIEW
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vaccines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! VaccineCell
        cell.configCellWithVaccine(self.vaccines[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! VaccineCell
        if self.vaccines[indexPath.row].sick.id == 3 {
            for vaccine in self.vaccines {
                if vaccine.sick.id == 4 {
                    vaccine.isSelect = false
                }
            }
            self.tableview.reloadData()
        } else if self.vaccines[indexPath.row].sick.id == 4 {
            for vaccine in self.vaccines {
                if vaccine.sick.id == 3 {
                    vaccine.isSelect = false
                }
            }
            self.tableview.reloadData()
        }
        self.vaccines[indexPath.row].isSelect = !self.vaccines[indexPath.row].isSelect
        if self.vaccines[indexPath.row].isSelect {
            cell.check.image = UIImage(named: "check")
        } else {
            cell.check.image = UIImage(named: "uncheck")
        }
    }

}
