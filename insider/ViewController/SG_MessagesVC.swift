//
//  SG_MessagesVC.swift
//  Student_GPA
//
//  Created by mac 2 on 18/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_MessagesVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var messageList = [[String:Any]]()
    var chatUserId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MESSAGES"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        let messageNib = UINib(nibName: "MessageCell", bundle: nil)
        self.tableView.register(messageNib, forCellReuseIdentifier: "MessageCell")
//
        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
        
        self.messageListServiceCall()
        //Utility.sharedInstance().setstatusbarColor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.messageListServiceCall()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        self.navigationController?.view.backgroundColor = UIColor.red
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(_:)), name: NSNotification.Name(rawValue: "Message"), object: nil)
        Utility.sharedInstance().setstatusbarColor()
    }
    
    // handle notification
    @objc func showNotification(_ notification: NSNotification) {
        
        if let str = notification.userInfo?["Message"] as? String {
            print(str)
            self.messageListServiceCall()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:SEARCHBAR
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

    
    //MARK : TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewmessageCell", for: indexPath)
            return cell
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
            //let cell = self.tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            if (self.messageList[indexPath.row-1]["photo"] as! String) == "" {
                
            }else {
                //cell.userProfileImage.imageURL = NSURL(string: (self.messageList[indexPath.row-1]["photo"] as! String)) as URL!
            }
            cell.userNameLbl.text = "\(messageList[indexPath.row-1]["user_name"]!)"
            cell.detailMessageLbl.textColor = UIColor.init(hexString: "808080")
            if "\(messageList[indexPath.row-1]["type"]!)" == "photo" {
                cell.detailMessageLbl.text = "Photo"
            }else {
                cell.detailMessageLbl.text = "\(messageList[indexPath.row-1]["message_text"]!)"
            }
            if "\(messageList[indexPath.row-1]["status"]!)" == "Read" {
                cell.detailMessageLbl.textColor = UIColor.init(hexString: "808080")
                cell.detailMessageLbl.font = UIFont(name: "Trebuchet MS", size: 16.0)
                cell.lblTime.textColor = UIColor.init(hexString: "808080")
            }else{
                if "\(messageList[indexPath.row-1]["createdby"]  as! String)" == "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" {
                    cell.detailMessageLbl.textColor = UIColor.init(hexString: "808080")
                    cell.detailMessageLbl.font = UIFont(name: "Trebuchet MS", size: 16.0)
                    cell.lblTime.textColor = UIColor.init(hexString: "808080")
                }else {
                    cell.detailMessageLbl.textColor = UIColor.init(hexString: "00A14B")
                    cell.detailMessageLbl.font = UIFont.boldSystemFont(ofSize: 18.0)
                    cell.lblTime.textColor = UIColor.init(hexString: "00A14B")
                }
                
            }
            cell.lblTime.text = "\(messageList[indexPath.row-1]["createddate"]!)"
            return cell
        }

       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
        self.chatUserId = indexPath.row-1
        self.performSegue(withIdentifier: "showChat", sender: nil)
        }
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row == 0 {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        
        if indexPath.row == 0 {
            return 60
        }else {
            return 100
        }

        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 60
        }else {
            return 100
        }

        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if indexPath.row == 0 {
            return false
        }else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let Alert = UIAlertController(title: "", message: "Are you sure to delete this message?", preferredStyle: UIAlertControllerStyle.alert)
            
            Alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
                if "\(self.messageList[indexPath.row-1]["user_id"]  as! String)" == "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" {
                    self.deletePostApiCAll(messageId:"\(self.messageList[indexPath.row-1]["createdby"]!)",index:indexPath)
                    
                }else {
                    self.deletePostApiCAll(messageId:"\(self.messageList[indexPath.row-1]["user_id"]!)",index:indexPath)
                }
                
            }))
            Alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                
                
            }))
            present(Alert, animated: true, completion: nil)
        }
    }

   
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    //MARK:WEBSERVICESCALL
    func messageListServiceCall(){
        
        let dictParameter = NSDictionary(dictionary: ["tag":"student_message_list",
                                                      "id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        print(dictParameter)
        var dict = [String:Any]()
        dict["tag"] = "student_message_list"
        dict["id"] = Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!
        dict["token"] = Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_MESSAGE, WSParams: dict as NSDictionary, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictData = iData as! NSDictionary
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        print(iDictData)
                        self.messageList.removeAll()
                        if let msgDetail = iDictData.object(forKey: "message_list") as? [NSDictionary] {
                            for i in msgDetail {
                                self.messageList.append(i as! [String : Any])
                            }
                        }
                        self.tableView.reloadData()
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
            }
            
        }
    }

    func deletePostApiCAll(messageId:String, index:IndexPath){
        /*
         id:21
         user_id:31
         token:HQmTKexnQz4oU0FBqjbf5FxWw58lYfIS
         tag:delete_conversation
 */
        let dictParameter = NSDictionary(dictionary: ["tag":"delete_conversation","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","user_id":messageId,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        
        print(dictParameter)
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_MESSAGE, WSParams: dictParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                print(iData ?? "nhi")
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        
                        self.messageList.remove(at: index.row-1)
                        
                        //self.tableView.deleteRows(at: [index], with: .fade)
                        self.tableView.reloadData()
                        //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
            }
        }
    }

    
    //MARK : EVENTS
    
    @IBAction func newMessageBtnTaped(_ sender: Any) {
        /*let vcc = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "SendmessageVC") as! SG_SendmessageVC
        let dest = SG_SendmessageVC()
        dest.ttle = "Raj"
        self.navigationController?.pushViewController(vcc, animated: true)*/
        self.performSegue(withIdentifier: "Sendnewmessage", sender: nil)
    }
    
    @objc func backBtnClicked() {
        _ = navigationController?.popViewController(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       /* if segue.identifier == "showChat" {
            let nextVC = segue.destination as! CC_UserChatVC
            nextVC.strChatUserName = "\(messageList[chatUserId]["user_name"] as! String)"
            if "\(messageList[chatUserId]["createdby"]  as! String)" == "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" {
                nextVC.intChatUserID = "\(messageList[chatUserId]["user_id"]  as! String)"
            }else {
                nextVC.intChatUserID = "\(messageList[chatUserId]["createdby"]  as! String)"
            }
            nextVC.strUserPhotoURL = "\(messageList[chatUserId]["photo"]  as! String)"
            nextVC.strSchoolId = "\(messageList[chatUserId]["school_id"]  as! String)"
            nextVC.strinsightId = "\(messageList[chatUserId]["insight_user"]  as! String)"
        }*/
        
        
    }

}
