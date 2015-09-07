//
//  MenuViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    private let CellIdentifier = "MenuCell"
    private let titles = [["Sổ y bạ các loại"], ["Trạm y tế", "Nhà thuốc"], ["Quản lí thành viên"], ["Thông tin ứng dụng", "Cài đặt hệ thống", "Thoát"]]
    private let imageView = [["menu_home"], ["menu_drugStore", "menu_drugStore"], ["menu_patient"], ["menu_info", "menu_setting", "menu_logout"]]
    private let sectionTitle = ["Các loại sổ y bạ", "Tìm kiếm...", "Quản lí", "Hệ thống"]
    var presentedIndexpath: NSIndexPath = NSIndexPath()
    var sections: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avatar.sd_setImageWithURL(NSURL(string: UserObject.sharedUser.photoURL), placeholderImage: UIImage(named: "default_avatar"))
        self.tableview.registerNib(UINib(nibName: CellIdentifier, bundle: nil), forCellReuseIdentifier: CellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.avatar.sd_setImageWithURL(NSURL(string: UserObject.sharedUser.photoURL), placeholderImage: UIImage(named: "default_avatar"))
        self.name.text = UserObject.sharedUser.name
        super.viewDidAppear(animated)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return self.sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return (self.sections.objectAtIndex(section) as! [AnyObject]).count + 1
        }
        return (self.sections.objectAtIndex(section) as! [AnyObject]).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! MenuCell
        
        cell.titleLB.text = self.titles[indexPath.section][indexPath.row]
        cell.imageview.image = UIImage(named: self.imageView[indexPath.section][indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitle[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! MenuCell
        cell.selected = false
        
        if indexPath.section == 3 && indexPath.row == 2 {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
                }) { (finished: Bool) -> Void in
                    let loginViewController = LoginViewController()
                    DELEGATE.changeRootViewController(loginViewController)
            }
            return
        }
        
        if indexPath == self.presentedIndexpath {
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            return
        }
        
        var viewController: UIViewController!
        viewController = (self.sections[indexPath.section] as! [AnyObject])[indexPath.row] as! UIViewController
        
        if viewController != nil {
            self.revealViewController().pushFrontViewController(viewController, animated: true)
            self.presentedIndexpath = indexPath
        }
    }
    
    // MARK: EXIT BUTTON
    
    @IBAction func doLogoutAction(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            }) { (finished: Bool) -> Void in
                Patient.MR_truncateAll()
                Patient_Sick.MR_truncateAll()
                Patient_Injection.MR_truncateAll()
                
                let loginViewController = LoginViewController()
                DELEGATE.changeRootViewController(loginViewController)
        }
    }
    
    // MARK: BLUR IMAGE
    func imageWithBlurredImageWithImage(image: UIImage, andBlurInsetFromBottom bottom: CGFloat, withBlurRadius blurRadius: CGFloat) ->UIImage {
        UIGraphicsBeginImageContext(image.size)
        var context = UIGraphicsGetCurrentContext()
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -image.size.height)
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage)
        CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), self.blurImage(image, withBottomInset: bottom, blurRadius: blurRadius).CGImage)
        var img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func blurImage(image: UIImage, withBottomInset inset: CGFloat,  blurRadius radius: CGFloat) -> UIImage {
        var img = UIImage(CGImage: CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, image.size.height - inset, image.size.width, inset)), scale: 1, orientation: UIImageOrientation.Up)
        var ciImage = CIImage(CGImage: image.CGImage)
        var filter = CIFilter(name: "CIGaussianBlur")
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(radius, forKey: kCIInputRadiusKey)
        
        var outputCIImage = filter.outputImage
        var context = CIContext(options: nil)
        return UIImage(CGImage: context.createCGImage(outputCIImage, fromRect: ciImage.extent()))!
    }
}
