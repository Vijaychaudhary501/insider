//
//  SG_SendmessageVC.swift
//  Student_GPA
//
//  Created by mac 2 on 21/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SG_SendmessageVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate ,UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var msgTextView: UITextView!
    
    var ttle = ""
    var userList = [UserList]()
    var searchuserList = [UserList]()
    
    var userID = [String]()
    var tap:Bool = false
    
    @IBOutlet weak var searchTxtFld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MESSAGE"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        let contactNib = UINib(nibName: Constant.CONTACT_NIBNAME, bundle: nil)
        self.tableView.register(contactNib, forCellReuseIdentifier: Constant.CONTACT_CELLID)
        //self.tableView.allowsMultipleSelection = true
        self.tableView.allowsSelection = false
        searchTxtFld.addBorderToBottomOfTextfield(borderColor: UIColor(hexString:"8c8c8c")!)
        searchTxtFld.setLeftViewIcon(UIImage(named:"SearchIconBlack")!)
        searchTxtFld.placeHolderCustomized("Search", strHexColor: "000000")
        searchTxtFld.delegate = self
        searchTxtFld.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)

        self.msgTextView.delegate = self
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
        
        self.userListServiceCall()
        
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Send"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        tap = true
        view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Done"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:UITEXTFIELD DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let str = "\(textField.text!)"
        print(str)
        
        let searchedArray = userList.filter { (UserList) -> Bool in
            return UserList.name.range(of: str, options: .caseInsensitive) != nil
        }
        print(searchedArray)
        self.searchuserList = searchedArray
        
        if str == "" {
            self.searchuserList = self.userList
        }else if searchuserList.isEmpty{
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "No contact found", iButtonTitle: "ok", iViewController: self)
        }
        self.tableView.reloadData()
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type your message" {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Type your message"
        }
    }
    //MARK:TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchuserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        if searchuserList[indexPath.row].photo == ""{
            //cell.profileImageView.image = #imageLiteral(resourceName: "User_profile")
        }else {
            //cell.profileImageView.imageURL = NSURL(string: searchuserList[indexPath.row].photo) as! URL
        }
        cell.userLbl.text = "\(searchuserList[indexPath.row].name)"
        cell.selectBtn.tag = indexPath.row
        cell.selectBtn.addTarget(self, action: #selector(selectBtnTaped(_:)), for: .touchUpInside)
        for i in userID {
            if i == searchuserList[indexPath.row].id {
                //cell.setSelected(true, animated: true)
                //cell.selectImgView.image = #imageLiteral(resourceName: "ContactSelected")
                cell.selectBtn.setBackgroundImage(#imageLiteral(resourceName: "ContactSelected"), for: UIControlState())
                break
            }else {
                //cell.setSelected(false, animated: true)
                //cell.selectImgView.image = #imageLiteral(resourceName: "ContactNormal")
                cell.selectBtn.setBackgroundImage(#imageLiteral(resourceName: "ContactNormal"), for: UIControlState())
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("s==",indexPath.row)
        //userID.append(searchuserList[indexPath.row].id!)
        //let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        //cell.selectImgView.image = #imageLiteral(resourceName: "ContactSelected")
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //print("d==",indexPath.row)
        //print("id====",userID)
        //if let index = userID.index(of:searchuserList[indexPath.row].id!) {
          //  userID.remove(at: index)
        //}
        //let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        //cell.selectImgView.image = #imageLiteral(resourceName: "ContactNormal")
        
        //print("userID",userID)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        //cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    @objc func selectBtnTaped(_ sender:UIButton){
        if sender.backgroundImage(for: UIControlState()) == #imageLiteral(resourceName: "ContactSelected") {
            
                if let index = userID.index(of:searchuserList[sender.tag].id!) {
                    userID.remove(at: index)
                }
                sender.setBackgroundImage(#imageLiteral(resourceName: "ContactNormal"), for: UIControlState())
        }else {
            userID.append(searchuserList[sender.tag].id!)
            sender.setBackgroundImage(#imageLiteral(resourceName: "ContactSelected"), for: UIControlState())
        }
        
    }
    //MARK:WEBSERVICES
    
    func sendMessageServiceCall(){
        /*
         "tag":"student_message_send",
         "id":3,
         "user_id":"2",
         "message":"Test",
         "token":"2076095124"

 */
        if self.msgTextView.text == "" || self.msgTextView.text == "Type your message" {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter Message", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        
        var idString = ""
        for (key,i) in userID.enumerated(){
            if key == userID.count-1{
                idString = idString+"\(i)"
            }else{
                idString = idString+"\(i),"
            }
        }
        
        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"student_message_send",
                                                           "id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","user_id":idString,
                                                           "message":self.msgTextView.text!,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_MESSAGE, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        let Alert = UIAlertController(title: "", message: iData?.object(forKey: Constant.MESSAGE) as! String, preferredStyle: UIAlertControllerStyle.alert)
                        
                        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(Alert, animated: true, completion: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Message"), object: nil, userInfo: ["Message":"refresh"])
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }

        
        
        
    }
    
    func userListServiceCall(){
    
        let dictPostParameter = NSDictionary(dictionary: ["tag":"search_user","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
    
        print(dictPostParameter)
        WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_USER, WSParams: dictPostParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber{
                    if iIntSuccess == 1 {
                        if let users = iData?.object(forKey:"user_list") as? NSArray{
                            self.userList.removeAll()
                            for i in users{
                                print(i)
                                let user = UserList(id: (i as! NSDictionary).value(forKey: "id") as! String,first_name:(i as! NSDictionary).value(forKey: "first_name") as! String,last_name:(i as! NSDictionary).value(forKey: "last_name") as! String,name:(i as! NSDictionary).value(forKey: "name") as! String,photo:(i as! NSDictionary).value(forKey: "photo") as! String)
                                
                                self.userList.append(user)
                                
                            }
                        }
                        self.searchuserList = self.userList
                        self.tableView.reloadData()
    
                    }else {
    
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                
                }
            }
        }
    }
    //MARK:EVENTS
    @IBAction func sendBtnTaped(_ sender: Any) {
        self.sendMessageServiceCall()
    }
    
    @objc  func backBtnClicked() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    @objc func keyboardWillHide(_ notification:Notification)
    {
        if !tap {
            if self.msgTextView.text == "" || self.msgTextView.text == "Type your message" {
            
            }else {
                self.sendMessageServiceCall()
            }
        }else {
            tap = false
        }
    }
    
}
