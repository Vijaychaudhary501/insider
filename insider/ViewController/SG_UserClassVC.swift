//
//  SG_UserClassVC.swift
//  Student_GPA
//
//  Created by mac 2 on 04/07/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_UserClassVC: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentArray = [ClassList]()
    var priviousArray = [PriviousClassList]()
    var mycurrentArray = [ClassList]()
    var mypriviousArray = [PriviousClassList]()
    var irow:Int = 0
    var isection:Int = 0
    var dindexPath = IndexPath()
    var user_ID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CLASSES"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
        self.getClassServiceCall()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        Utility.sharedInstance().setstatusbarColorClear()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.sharedInstance().setstatusbarColor()
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(_:)), name: NSNotification.Name(rawValue: "updateClass"), object: nil)
    }
    // handle notification
    func showNotification(_ notification: NSNotification) {
        
        if let str = notification.userInfo?["myclass"] as? String {
            if str == "refresh" {
                
                self.navigationController?.view.backgroundColor = UIColor.red
                self.getClassServiceCall()
            }
        }
        
    }
    
    //MARK:TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return   currentArray.count
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "userClassName", for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = currentArray[indexPath.row].course_name
            cell.textLabel?.backgroundColor = UIColor.clear
            if mycurrentArray.count > 0 {
                for (key,_) in mycurrentArray.enumerated() {
                    if currentArray[indexPath.row].crn_no == mycurrentArray[key].crn_no {
                        cell.backgroundColor = UIColor(hexString:"cbcbcb")
                        cell.textLabel?.textColor = UIColor(hexString: "00A14B")
                        break
                    }else{
                        cell.backgroundColor = UIColor.clear
                        cell.textLabel?.textColor = UIColor.black
                    }
                }
            }
            

            return cell
        }else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "userClassName", for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = priviousArray[indexPath.row].course_name
            cell.textLabel?.backgroundColor = UIColor.clear
            if mypriviousArray.count > 0 {
                for (key,_) in mypriviousArray.enumerated() {
                    if priviousArray[indexPath.row].crn_no == priviousArray[key].crn_no {
                        cell.backgroundColor = UIColor(hexString:"cbcbcb")
                        cell.textLabel?.textColor = UIColor(hexString: "00A14B")
                        
                        break
                    }else{
                        cell.backgroundColor = UIColor.clear
                        cell.textLabel?.textColor = UIColor.black
                    }
                }
            }
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Current"
        }else {
            return "Previous"
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let Alert = UIAlertController(title: "", message: "Are you sure to delete this class?", preferredStyle: UIAlertControllerStyle.alert)
            
            Alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
                if indexPath.section == 0 {
                    self.deletePostApiCAll(postId:self.currentArray[indexPath.row].id,index:indexPath)
                }else {
                    self.deletePostApiCAll(postId:self.priviousArray[indexPath.row].id,index:indexPath)
                }
            }))
            Alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                
                
            }))
            present(Alert, animated: true, completion: nil)
        }
    }
    
    /* func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     let  headerCell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
     headerCell.titleLbl.text = "\(teacherDetails[section]["rate_username"]!)"
     return headerCell
     }*/
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        //view.tintColor = UIColor(hexString: "ff8400")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(hexString: "ff8400")
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dindexPath = indexPath
        self.performSegue(withIdentifier: "class_studentVC", sender: nil)
    }
    
    //MARK:WEBSERVICESCALL
    func deletePostApiCAll(postId:String, index:IndexPath){
        let dictParameter = NSDictionary(dictionary: ["tag":"delete_class","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","class_id":postId,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        
        print(dictParameter)
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                print(iData ?? "nhi")
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        if index.section == 0 {
                            self.currentArray.remove(at: index.row)
                        }else {
                            self.priviousArray.remove(at: index.row)
                        }
                        //self.tableView.deleteRows(at: [index], with: .fade)
                        self.tableView.reloadData()
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
            }
        }
    }
    
    func getClassServiceCall(){
        let dictLoginParameter = NSDictionary(dictionary: ["tag": "class_list","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","user_id":user_ID,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)"])
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        if let classData = iDictUserData.object(forKey: "class_list") as? NSDictionary {
                            if let currentdata = classData["Current"] as? [NSDictionary] {
                                self.currentArray.removeAll()
                                for i in currentdata {
                                    let current = ClassList(id: i["id"] as! String, user_id: i["user_id"] as! String, school_id: i["school_id"] as! String, crn_id: i["crn_id"] as! String, course_id: i["course_id"] as! String, teacher_id: i["teacher_id"] as! String, class_type: i["class_type"] as! String, title: i["title"] as! String, books: i["books"] as! String, notes: i["notes"] as! String, createddate: i["createddate"] as! String, createdby: i["createdby"] as! String, modifydatetime: i["modifydatetime"] as! String, modifiedby: i["modifiedby"] as! String, crn_no: i["crn_no"] as! String, school_name: i["school_name"] as! String, course_name: i["course_name"] as! String, teacher_name: i["teacher_name"] as! String)
                                    
                                    self.currentArray.append(current)
                                }
                            }
                            
                            if let previousdata = classData["Previous"] as? [NSDictionary] {
                                self.priviousArray.removeAll()
                                for i in previousdata {
                                    let previous = PriviousClassList(id: i["id"] as! String, user_id: i["user_id"] as! String, school_id: i["school_id"] as! String, crn_id: i["crn_id"] as! String, course_id: i["course_id"] as! String, teacher_id: i["teacher_id"] as! String, class_type: i["class_type"] as! String, title: i["title"] as! String, books: i["books"] as! String, notes: i["notes"] as! String, createddate: i["createddate"] as! String, createdby: i["createdby"] as! String, modifydatetime: i["modifydatetime"] as! String, modifiedby: i["modifiedby"] as! String, crn_no: i["crn_no"] as! String, school_name: i["school_name"] as! String, course_name: i["course_name"] as! String, teacher_name: i["teacher_name"] as! String)
                                    
                                    self.priviousArray.append(previous)
                                }
                            }
                            
                            self.getMyClassServiceCall()
                            //self.tableView.reloadData()
                        }
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }
        
    }
    
    //MARK:EVENTS
    func backBtnClicked() {
        _ = self.navigationController?.popViewController(animated: true)
        //Constant.appDelegate.createMenubar()
    }
    
    func toggleRigh() {
        self.performSegue(withIdentifier: "addClassVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "class_studentVC"{
            
            let nextVC = segue.destination as! SG_ClassStudentVC
            if dindexPath.section == 0 {
                nextVC.courseName = currentArray[dindexPath.row].course_name
                
            }else {
                nextVC.courseName = currentArray[dindexPath.row].course_name
            }
        }
    }
    
    
    
    
    func getMyClassServiceCall(){
        let dictLoginParameter = NSDictionary(dictionary: ["tag": "class_list","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)"])
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        if let classData = iDictUserData.object(forKey: "class_list") as? NSDictionary {
                            if let currentdata = classData["Current"] as? [NSDictionary] {
                                self.mycurrentArray.removeAll()
                                for i in currentdata {
                                    let current = ClassList(id: i["id"] as! String, user_id: i["user_id"] as! String, school_id: i["school_id"] as! String, crn_id: i["crn_id"] as! String, course_id: i["course_id"] as! String, teacher_id: i["teacher_id"] as! String, class_type: i["class_type"] as! String, title: i["title"] as! String, books: i["books"] as! String, notes: i["notes"] as! String, createddate: i["createddate"] as! String, createdby: i["createdby"] as! String, modifydatetime: i["modifydatetime"] as! String, modifiedby: i["modifiedby"] as! String, crn_no: i["crn_no"] as! String, school_name: i["school_name"] as! String, course_name: i["course_name"] as! String, teacher_name: i["teacher_name"] as! String)
                                    
                                    self.mycurrentArray.append(current)
                                }
                            }
                            
                            if let previousdata = classData["Previous"] as? [NSDictionary] {
                                self.mypriviousArray.removeAll()
                                for i in previousdata {
                                    let previous = PriviousClassList(id: i["id"] as! String, user_id: i["user_id"] as! String, school_id: i["school_id"] as! String, crn_id: i["crn_id"] as! String, course_id: i["course_id"] as! String, teacher_id: i["teacher_id"] as! String, class_type: i["class_type"] as! String, title: i["title"] as! String, books: i["books"] as! String, notes: i["notes"] as! String, createddate: i["createddate"] as! String, createdby: i["createdby"] as! String, modifydatetime: i["modifydatetime"] as! String, modifiedby: i["modifiedby"] as! String, crn_no: i["crn_no"] as! String, school_name: i["school_name"] as! String, course_name: i["course_name"] as! String, teacher_name: i["teacher_name"] as! String)
                                    
                                    self.mypriviousArray.append(previous)
                                }
                            }
                            
                            self.tableView.reloadData()
                        }
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }
    }


}
