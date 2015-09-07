//
//  AppInfoViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 9/1/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class AppInfoViewController: BaseViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet var contentview: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBarWithTitle("Thông tin ứng dụng")
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem()
        
        self.contentview.frame = CGRectMake(0, 0, SCREEN_SIZE.width, self.contentview.frame.height)
        self.scrollview.addSubview(self.contentview)
        self.scrollview.contentSize = self.contentview.size
        
        self.logo.layer.cornerRadius = (SCREEN_SIZE.width - 200)/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}