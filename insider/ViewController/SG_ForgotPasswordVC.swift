//
//  SG_ForgotPasswordVC.swift
//  Student_GPA
//
//  Created by mac 2 on 12/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_ForgotPasswordVC: UIViewController {
    
    
    @IBOutlet weak var txtFieldEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
         //TextField Setup
        //txtFieldEmail.addBorderToBottomOfTextfield(borderColor: UIColor(hexString:"acacac")!)
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(hexString:"acacac")?.cgColor
        border.frame = CGRect(x: 0, y:txtFieldEmail.frame.size.height+0, width:240.0, height: 1.0)
        
        border.borderWidth = width
        txtFieldEmail.layer.addSublayer(border)
        txtFieldEmail.layer.masksToBounds = false
        txtFieldEmail.leftViewMode = .always
        txtFieldEmail.setLeftViewIcon(UIImage(named:"Email")!)
        txtFieldEmail.placeHolderCustomized("Enter Your Email*", strHexColor: "ffffff")
        
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
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIViewController Events
    
    @IBAction func resetbtnClicked(_ sender: Any) {
        if (txtFieldEmail.text?.characters.count)! < 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter email", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        if !txtFieldEmail.isValidEmail() {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter a valid email id", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        if (txtFieldEmail.text?.characters.count)! < 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter a password", iButtonTitle: "OK", iViewController: self)
            return
        }
        

        let dictLoginParameter = NSDictionary(dictionary: ["tag": "forget_password","email": self.txtFieldEmail.text!])
        let url = URL.init(string: Constant.WS_USER)
        var request = URLRequest.init(url: url!)
        request.httpMethod  = "POST"
        let session = URLSession.shared
        request.httpBody = try! JSONSerialization.data(withJSONObject: dictLoginParameter, options: [])
        request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
            let json = try JSONSerialization.jsonObject(with: data!, options: [])
            print(json)
            }catch{
                
            }
            
            
        }
        task.resume()
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_USER, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        
                        let Alert = UIAlertController(title: "", message: iData?.object(forKey: Constant.MESSAGE) as? String, preferredStyle: UIAlertControllerStyle.alert)
                        
                        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(Alert, animated: true, completion: nil)
                    }else {
                        let Alert = UIAlertController(title: "", message: iData?.object(forKey: Constant.MESSAGE) as? String, preferredStyle: UIAlertControllerStyle.alert)
                        
                        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        self.present(Alert, animated: true, completion: nil)
                    }
                }

                
            }
        }

        
    }
    
    @IBAction func backBarbtnClicked(_ sender: Any){
        _ = self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
