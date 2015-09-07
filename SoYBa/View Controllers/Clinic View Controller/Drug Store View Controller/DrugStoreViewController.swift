//
//  DrugStoreViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/31/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class DrugStoreViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    private let cellIdentifier = "ClinicCell"
    
    var offset = 0
    var number: Int = 40
    var clinics: [Clinic]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configNavigationBarWithTitle("Danh sách nhà thuốc")
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem()
        self.clinics = []
        self.tableview.registerNib(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Đang tải", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
        ClinicAPI.getClinic(self.number, offset: self.offset, completion: { (clinics) -> Void in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            
            self.clinics = clinics
            self.tableview.reloadData()
            
            self.offset = self.number
            self.number += 40
            
            }) { (error) -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }
    }
    
    // MARK: DATA
    func loadMoreData() {
        self.activityIndicator.startAnimating()
        ClinicAPI.getClinic(self.number, offset: self.offset, completion: { (clinics) -> Void in
            self.activityIndicator.stopAnimating()
            
            if clinics != nil {
                for clinic in clinics {
                    self.clinics.append(clinic)
                }
            }
            
            self.tableview.reloadData()
            
            self.offset = self.number
            self.number += 40
            self.view.userInteractionEnabled = true
            }) { (error) -> Void in
                self.view.userInteractionEnabled = true
                self.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: tableview methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ClinicCell
        cell.configCellWithClinic(self.clinics[indexPath.row])
        if indexPath.row == self.clinics.count - 1 {
            self.view.userInteractionEnabled = false
            self.loadMoreData()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clinics.count
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ClinicCell.calculateCellHeigh(self.clinics[indexPath.row].name)
    }
}
