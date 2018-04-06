//
//  SG_ChangePasswordVC.swift
//  Student_GPA
//
//  Created by mac 2 on 02/06/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_ChangePasswordVC: UIViewController {

    @IBOutlet weak var oldPassTextFild: UITextField!
    
    @IBOutlet weak var newPassTextFild: UITextField!
    
    @IBOutlet weak var comfirmPassTextFild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CHANGE PASSWORD"
        self.oldPassTextFild.placeHolderCustomized("Old Password*", strHexColor: "ffffff")
        //self.oldPassTextFild.delegate = self
        self.newPassTextFild.placeHolderCustomized("New Password*", strHexColor: "ffffff")
        //self.newPassTextFild.delegate = self
        self.comfirmPassTextFild.placeHolderCustomized("Confirm Password*", strHexColor: "ffffff")
        //self.comfirmPassTextFild.delegate = self
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(hexString:"acacac")?.cgColor
        border.frame = CGRect(x: 0, y:newPassTextFild.frame.size.height+0, width:240.0, height: 1.0)
        
        border.borderWidth = width
        newPassTextFild.layer.addSublayer(border)
        newPassTextFild.layer.masksToBounds = false
        
        let bordert = CALayer()
        let widtht = CGFloat(2.0)
        bordert.borderColor = UIColor(hexString:"acacac")?.cgColor
        bordert.frame = CGRect(x: 0, y:comfirmPassTextFild.frame.size.height+0, width:240.0, height: 1.0)
        
        bordert.borderWidth = widtht
        comfirmPassTextFild.layer.addSublayer(bordert)
        comfirmPassTextFild.layer.masksToBounds = false

        self.oldPassTextFild.isHidden = true
        self.oldPassTextFild.text = Constant.USER_DEFAULT.value(forKey: Constant.PASSWORD) as! String?
        self.navigationItem.setHidesBackButton(true, animated:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func resetBtnTaped(_ sender: Any) {
        //self.performSegue(withIdentifier:"Create_profile",sender:nil)
        /*if (oldPassTextFild.text?.characters.count)! < 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter old password", iButtonTitle: "OK", iViewController: self)
            return
        }*/
        
        if (newPassTextFild.text?.characters.count)! < 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter new password", iButtonTitle: "OK", iViewController: self)
            return
        }
        if comfirmPassTextFild.text == "" {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter confirm password", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        if newPassTextFild.text != comfirmPassTextFild.text {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Password is not matched", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"change_password","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","current_password":Constant.USER_DEFAULT.value(forKey: Constant.PASSWORD) as! String,"new_password":self.newPassTextFild.text!,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_USER, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        
                        let Alert = UIAlertController(title: "", message: iData?.object(forKey: Constant.MESSAGE) as? String, preferredStyle: UIAlertControllerStyle.alert)
                
                        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            self.title = ""
                            self.performSegue(withIdentifier:"Create_profile",sender:nil)
                        }))
                
                        self.present(Alert, animated: true, completion: nil)
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
                
                
            }
        }

    }
    
    @IBAction func skipBtnTaped(_ sender: Any) {
        self.title = ""
        self.performSegue(withIdentifier:"Create_profile",sender:nil)
    }

}
