//
//  ClinicViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit
import MapKit

class ClinicViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    var clinics: [Clinic]!
    var btnMap: UIBarButtonItem!
    
    private let CellIdentifier = "ClinicCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configNavigationBarWithTitle("Danh sách nhà thuốc")
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem()
        self.clinics = Clinic.MR_findAll() as! [Clinic]
        self.tableview.registerNib(UINib(nibName: CellIdentifier, bundle: nil), forCellReuseIdentifier: CellIdentifier)
        self.btnMap = UIBarButtonItem(title: "Bản đồ", style: UIBarButtonItemStyle.Plain, target: self, action: "moveToMap")
        self.navigationItem.rightBarButtonItem = self.btnMap
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    // MARK: TABLEVIEW METHODS
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.clinics.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ClinicCell
        cell.configCellWithClinic(self.clinics[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let mapController = MapViewController()
        mapController.initialLocation = CLLocation(latitude: self.clinics[indexPath.row].longitude.doubleValue, longitude: self.clinics[indexPath.row].latitude.doubleValue)
        mapController.showOnePlace = true
        self.navigationController?.pushViewController(mapController, animated: true)
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
    
    // MARK: BUTTON ACTION
    func moveToMap() {
        let mapController = MapViewController()
        self.navigationController?.pushViewController(mapController, animated: true)
    }
}
