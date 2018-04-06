//
//  SG_AddgroupstudyVC.swift
//  Student_GPA
//
//  Created by mac 2 on 24/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_AddgroupstudyVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var gstitleTxtfild: UITextField!
    
    @IBOutlet weak var selectDateLbl: UILabel!
    
    @IBOutlet weak var selectTimeLbl: UILabel!
    
    var inviteClicked:Bool = false
    @IBOutlet weak var locationTxtFld: UITextField!
    let dateFormatter = DateFormatter()
    var userList = [UserList]()
    var searchuserList = [UserList]()
    var userID = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GROUP STUDY"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        let contactNib = UINib(nibName: Constant.CONTACT_NIBNAME, bundle: nil)
        self.tableView.register(contactNib, forCellReuseIdentifier: Constant.CONTACT_CELLID)
        self.tableView.isHidden = true
        
        gstitleTxtfild.addBorderToBottomOfTextfield(borderColor: UIColor(hexString:"8c8c8c")!)
        //gstitleTxtfild.placeHolderCustomized("GS Title", strHexColor: "000000")
        locationTxtFld.addBorderToBottomOfTextfield(borderColor: UIColor(hexString:"8c8c8c")!)
        //
        selectDateLbl.addBorderToBottomOfTextfield(borderColor: UIColor(hexString:"acacac")!)
        selectTimeLbl.addBorderToBottomOfTextfield(borderColor: UIColor(hexString:"acacac")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(followTrip(_:)))
        selectDateLbl.addGestureRecognizer(tap)
        selectDateLbl.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(followTime(_:)))
        selectTimeLbl.addGestureRecognizer(tap2)
        selectTimeLbl.isUserInteractionEnabled = true
        //
        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.sharedInstance().setstatusbarColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
     //MARK:TABLEVIEW
     
     func numberOfSections(in tableView: UITableView) -> Int {
     return 1
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return userList.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = self.tableView.dequeueReusableCell(withIdentifier: "addPerson", for: indexPath) as!  SearchCell
     cell.addpersonNameLbl.text = userList[indexPath.row]["user_name"]!
     return cell
     }
     
 */
    //MARK : TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        if userList[indexPath.row].photo == ""{
//            cell.profileImageView.image = #imageLiteral(resourceName: "User_profile")
        }else {
  //          cell.profileImageView.imageURL = NSURL(string: userList[indexPath.row].photo) as! URL
        }
        cell.userLbl.text = "\(userList[indexPath.row].name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("s==",indexPath.row)
        userID.append(userList[indexPath.row].id!)
        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        cell.selectImgView.image = #imageLiteral(resourceName: "ContactSelected")
        cell.selectBtn.setBackgroundImage(#imageLiteral(resourceName: "ContactSelected"), for: UIControlState())
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //print("d==",indexPath.row)
        //print("id====",userID)
        if let index = userID.index(of:userList[indexPath.row].id!) {
            userID.remove(at: index)
        }
        let cell = tableView.cellForRow(at: indexPath) as! ContactCell
        cell.selectImgView.image = #imageLiteral(resourceName: "ContactNormal")
        cell.selectBtn.setBackgroundImage(#imageLiteral(resourceName: "ContactNormal"), for: UIControlState())
        
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
    
    
    
    //MARK : EVENTS
    
    @IBAction func createBtnTaped(_ sender: Any) {
        /*
         
         "tag":"create_group_study",
         "id":3,
         "title":"Biomedical Science",
         "date":"04-04-2017",
         "time":"6:00",
         "invitees":"3,4",
         "token":"2076095124"
         gstitleTxtfild
         selectDateLbl
         selectTimeLbl
         locationTxtFld
 */
        if (gstitleTxtfild.text?.characters.count)! <= 0  {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter #CRN ", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (selectDateLbl.text! == "Select Date")  {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please select date.  ", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (selectTimeLbl.text! == "Select Time")  {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please select time.  ", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (locationTxtFld.text?.characters.count)! <= 0  {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter location.  ", iButtonTitle: "OK", iViewController: self)
            return
        }
        if userID.count < 1 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please select your class mates.  ", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        var idString = ""
        for i in userID{
            idString = idString+"\(i),"
        }

        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"create_group_study",
                                                           "id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)",
                                                           "title":self.gstitleTxtfild.text!,
                                                           "location":self.locationTxtFld.text!,
                                                           "date":self.selectDateLbl.text!,
                                                           "time":self.selectTimeLbl.text!,
                                                           "invitees":idString])
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_GROUPSTUDY, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
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
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "createGroup"), object: nil, userInfo: ["group":"refresh"])
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }

    }
    
    func followTrip(_ sender:UITapGestureRecognizer) {
        
//        DatePickerDialog().showStart("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel",iViewController:self, datePickerMode: .date) {
//            (date) -> Void in
//
//            self.dateFormatter.dateFormat = "dd-MM-yyyy"
//            self.selectDateLbl.text = self.dateFormatter.string(from: date)
//        }
    }
    func followTime(_ sender:UITapGestureRecognizer) {
        
//        DatePickerDialog().show("Select Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel",iViewController:self, datePickerMode: .time) {
//            (date) -> Void in
//            let timeformater = DateFormatter()
//            timeformater.dateFormat = "HH:mm"
//            self.selectTimeLbl.text = timeformater.string(from: date)
//        }
    }

    @IBAction func inviteBtnClicked(_ sender: Any) {
        
        if !inviteClicked {
            self.inviteClicked = !inviteClicked
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
                                    let user = UserList(id: (i as! NSDictionary).value(forKey: "id") as! String,first_name:(i as! NSDictionary).value(forKey: "first_name") as! String,last_name:(i as! NSDictionary).value(forKey: "last_name") as! String,name:(i as! NSDictionary).value(forKey: "name") as! String,photo:(i as! NSDictionary).value(forKey: "photo") as! String)
                                    
                                    self.userList.append(user)
                                    
                                }

                            }
                            self.tableView.reloadData()
                            
                            
                        }else {
                            
                            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                        }
                        
                    }
                }
            }

            self.tableView.isHidden = false
        }
        
        
    }
    func backBtnClicked() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
