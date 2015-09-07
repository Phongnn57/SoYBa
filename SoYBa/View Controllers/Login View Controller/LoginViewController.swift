//
//  LoginViewController.swift
//  SoYBa
//
//  Created by Nguyen Nam Phong on 8/30/15.
//  Copyright (c) 2015 SkyDance. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, GPPSignInDelegate {

    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    
    var email: String = ""
    var name: String = ""
    var gender: Int = 2
    var photoURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doLoginWithFacebook(sender: AnyObject) {
        if(FBSDKAccessToken.currentAccessToken() != nil){
            self.getUserProfile({ () -> Void in
                self.startConnectServer()
            })
        }else{
            let login = FBSDKLoginManager()
            login.logInWithReadPermissions(["email", "public_profile"]) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
                if (error == nil && !result.isCancelled && result.grantedPermissions.contains("email")) {
                    self.getUserProfile({ () -> Void in
                        self.startConnectServer()
                    })
                }
            }
        }
    }
    
    @IBAction func doLoginWithGoogle(sender: AnyObject) {
        if GPPSignIn.sharedInstance().authentication != nil {
            if(GPPSignIn.sharedInstance().authentication.accessToken != nil){
                println("Already have account")
                println(GPPSignIn.sharedInstance().userEmail)
                println(GPPSignIn.sharedInstance().userID)
//                self.loginViaSocial(SocialTypes.Google, userId: GPPSignIn.sharedInstance().userID ?? "", accessToken: GPPSignIn.sharedInstance().authentication.accessToken)
                return
            }
        }
        
        GPPSignIn.sharedInstance().clientID = kClientId
        GPPSignIn.sharedInstance().scopes = [kGTLAuthScopePlusLogin]
        GPPSignIn.sharedInstance().delegate = self
        GPPSignIn.sharedInstance().shouldFetchGoogleUserID = true
        GPPSignIn.sharedInstance().shouldFetchGoogleUserEmail = true
        GPPSignIn.sharedInstance().shouldFetchGooglePlusUser = true
        
        GPPSignIn.sharedInstance().signOut()
        GPPSignIn.sharedInstance().authenticate()
    }
    
    func startConnectServer() {
        MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Đang đăng nhập", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
        UserAPI.getUserWithLoginType(AppConstant.LoginType.Login_Facebook, loginID: FBSDKAccessToken.currentAccessToken().userID, completion: { (existUser) -> Void in
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            if existUser {
                
                Patient.MR_truncateAll()
                Patient_Sick.MR_truncateAll()
                Patient_Injection.MR_truncateAll()
                MRProgressOverlayView.showOverlayAddedTo(self.view, title: "Đang khởi tạo dữ liệu", mode: MRProgressOverlayViewMode.IndeterminateSmall, animated: true)
                UserAPI.callSuperAPI(UserObject.sharedUser.userID, completion: { () -> Void in
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    DELEGATE.startApp()
                    }, failure: { (error) -> Void in
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                })
                
            } else {
                
                UserAPI.createUser(AppConstant.LoginType.Login_Facebook, loginID: FBSDKAccessToken.currentAccessToken().userID, gender: self.gender, accessToken: FBSDKAccessToken.currentAccessToken().tokenString, photoURL: self.photoURL, name: self.name, email: self.email, completion: { () -> Void in
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                    
                    let addPatientViewController = AddPatientViewController()
                    addPatientViewController.createFirstPatient = true
                    self.navigationController?.pushViewController(addPatientViewController, animated: true)
                    
                    }, failure: { (error) -> Void in
                        self.view.makeToast(error)
                        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                })
            }
            
            }) { (error) -> Void in
                MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        }
    }
    
    func getUserProfile(completion:()->Void) {
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error == nil){
                if let _email = result["email"] as? String {
                    self.email = _email
                }
                if let _gender = result["gender"] as? String {
                    if _gender == "male" {
                        self.gender = 0
                    } else if _gender == "female" {
                        self.gender = 1
                    }
                }
                if let _name = result["name"] as? String {
                    self.name = _name
                }
                
                if let _picture = result["picture"] as? Dictionary<String, AnyObject> {
                    if let _data = _picture["data"] as? Dictionary<String, AnyObject> {
                        if let _photoURL = _data["url"] as? String {
                            self.photoURL = _photoURL
                        }
                    }
                }
                completion()
            }
        })
    }
    
    // MARK: GOOGLE
    func finishedWithAuth(auth: GTMOAuth2Authentication!, error: NSError!) {
        if(error == nil){
            if(auth != nil && auth.accessToken != nil){
//                self.loginViaSocial(SocialTypes.Google, userId: GPPSignIn.sharedInstance().userID ?? "", accessToken: auth.accessToken)
//                GPPSignIn.sharedInstance().userEmail
                println("LOgin")
                
                var expirationDate: NSDate?
                let components: NSDateComponents = NSDateComponents()
                components.month = 1
                expirationDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: NSDate(), options: .WrapComponents)
                if let _expirationDate = expirationDate {
                    GPPSignIn.sharedInstance().authentication.expirationDate = _expirationDate
                }
            }
        }
    }
    
    func getUserProfileWithGoogle() {
        let plusService = GTLServicePlus()
        plusService.retryEnabled = true
        plusService.authorizer = 
    }
}
