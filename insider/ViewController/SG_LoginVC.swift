//
//  SG_LoginVC.swift
//  Student_GPA
//
//  Created by iOS Developer on 08/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_LoginVC: UIViewController {

    
    @IBOutlet weak var txtFldUsername:UITextField!
    @IBOutlet weak var txtFldPassword:UITextField!
    
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnSignUp:UIButton!
    @IBOutlet weak var btnForgotPassword:UIButton!
    
    
    // MARK: - UIViewController LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //SetUp TextField
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(hexString:"acacac")?.cgColor
        border.frame = CGRect(x: 0, y:txtFldUsername.frame.size.height+0, width:txtFldUsername.frame.width, height: 1.0)
        
        border.borderWidth = width
        txtFldUsername.layer.addSublayer(border)
        txtFldUsername.layer.masksToBounds = false
        
        let bordert = CALayer()
        let widtht = CGFloat(2.0)
        bordert.borderColor = UIColor(hexString:"acacac")?.cgColor
        bordert.frame = CGRect(x: 0, y:txtFldPassword.frame.size.height+0, width:txtFldPassword.frame.width, height: 1.0)
        
        bordert.borderWidth = widtht
        txtFldPassword.layer.addSublayer(bordert)
        txtFldPassword.layer.masksToBounds = false
        
        //txtFldUsername.addBorderToBottomOfTextfield(borderColor: UIColor(hexString:"acacac")!)
        //txtFldPassword.addBorderToBottomOfTextfield(borderColor: UIColor(hexString:"acacac")!)
        
        txtFldUsername.leftViewMode = .always
        txtFldPassword.leftViewMode = .always
        
        txtFldUsername.setLeftViewIcon(UIImage(named:"User_login")!)
        txtFldPassword.setLeftViewIcon(UIImage(named:"Password")!)
        
        txtFldUsername.placeHolderCustomized("Email*", strHexColor: "ffffff")
        txtFldPassword.placeHolderCustomized("Password*", strHexColor: "ffffff")
        
        // Transperent NavigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
     func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.isNavigationBarHidden = true
        Utility.sharedInstance().setstatusbarColorClear()
    }
    
    
    // MARK: - UIViewController Action & Events
    @IBAction func btnLoginEventPressed(_ sender:UIButton)  {
        if txtFldUsername.text == "" {
            //txtFldUsername.text = "mark@prakashcbseschool.com"
            //txtFldPassword.text = "abc@123$"
        }
        
        if (txtFldUsername.text?.characters.count)! <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter email", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        if !txtFldUsername.isValidEmail() {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter a valid email", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        if (txtFldPassword.text?.characters.count)! <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter a password", iButtonTitle: "OK", iViewController: self)
            return
        }
        //User Device ID
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        //print(deviceID)
        UserDefaults.standard.setValue(deviceID, forKey: Constant.DEVICE_TOKEN )
        UserDefaults.standard.synchronize()

        let dictLoginParameter = NSDictionary(dictionary: ["tag":Constant.USER_LOGIN,"email":txtFldUsername.text ?? "","password":txtFldPassword.text ?? "","device_token":"\(Constant.USER_DEFAULT.value(forKey: Constant.DEVICE_TOKEN)!)","device_type":"Iphone"])
        
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_USER, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        
                        let userDetailModel = SG_USER_DETAIL(fromDictionary: (iDictUserData.object(forKey: "user_details") as! [String : Any]))
                        Constant.USER_DEFAULT.set(userDetailModel.id, forKey: Constant.USER_ID)
                        Constant.USER_DEFAULT.set(userDetailModel.loginFlag, forKey: Constant.IS_LOGGED_IN)
                        Constant.USER_DEFAULT.set(userDetailModel.firstName, forKey: "firstName")
                        Constant.USER_DEFAULT.set(userDetailModel.lastName, forKey: "lastName")
                        Constant.USER_DEFAULT.set(userDetailModel.email, forKey: "email")
                        Constant.USER_DEFAULT.set(userDetailModel.accessToken, forKey: Constant.ACCESS_TOKEN)
                        Constant.USER_DEFAULT.set(userDetailModel.schoolId, forKey: Constant.SCHOOL_ID)
                        Constant.USER_DEFAULT.set(userDetailModel.userRole, forKey: Constant.USER_ROLE)
                        Constant.USER_DEFAULT.set(userDetailModel.photo,forKey:Constant.USER_PHOTO)
                        Constant.USER_DEFAULT.set(userDetailModel.password,forKey:Constant.PASSWORD)
                        Constant.USER_DEFAULT.set(userDetailModel.majorId,forKey:"majorID")
                        Constant.USER_DEFAULT.set(userDetailModel.major,forKey:"major")
                        Constant.USER_DEFAULT.set(userDetailModel.year,forKey:"year")
                        Constant.USER_DEFAULT.set(userDetailModel.locationId,forKey:"locationId")
                        Constant.USER_DEFAULT.set(userDetailModel.campus,forKey:"campus")
                       // Constant.USER_DEFAULT.set(userDetailModel, forKey: "test")
                        Constant.USER_DEFAULT.synchronize()
                        var iDictUserProfile = userDetailModel.toDictionary()
                        let iDictProfile = (iDictUserProfile as Dictionary).nullKeyRemoval()
                        iDictUserProfile = (iDictProfile as NSDictionary) 
                        
                        iDictUserProfile.write(toFile: Constant.PLIST_USER_PROFILE_PATH, atomically: true)
                        if userDetailModel.loginFlag == "1" {
                            Constant.appDelegate.createMenubar()
                       }else {
                            self.performSegue(withIdentifier: "ChangePasswordVC", sender: nil)
                            
                        }
                        
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
            }
        }
    
    }
    
    @IBAction func signupbtnClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "Sign_up", sender: nil)
    }
    
    @IBAction func forgotbtnClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "Forgot_password", sender: nil)
    }
    
    // MARK: - UIViewController Others
    
    
    

}

