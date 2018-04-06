//
//  SG_ClassesVC.swift
//  Student_GPA
//
//  Created by mac 2 on 14/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_ClassesVC:  UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet var tblView: UITableView!
    
    @IBOutlet weak var crnTbleView: UITableView!
    
    @IBOutlet weak var saveBarBtn: UIBarButtonItem!
    
    
    var crnName = [String]()
    var searchCrn = [String]()
    var courceList = [String:String]()
    var crnId = String()
    lazy var courceId = String()
    var teacherList = [String:String]()
    lazy var teacherId = String()
    var bookBool = "no"
    var noteBool = "no"
    var crnValue = "CRN#*"
    var courseValue = "Course Name*"
    var titleValue = "Title*"
    var teacherValue = ""
    var defaultTableViewInset:UIEdgeInsets?
    var index:Int?
    var indexpath:IndexPath?
    var crnIndexpath:IndexPath?
    var CurrentSeg = "Current"
    var edit:Bool = false
    var tag = "create_class"
    var class_id = String()
    var boo:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CREATE CLASS"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "ClassesBG")!)
        self.view.contentMode = UIViewContentMode.scaleAspectFill //doesnt seem to do anything!
        self.view.clipsToBounds = true // is this needed?
        self.view.center = view.center // is this needed?
        self.tblView.backgroundColor = .clear
        //let backgroundImage = UIImage(named: "ClassesBG")
        //let imageView = UIImageView(image: backgroundImage)
        //self.tblView.backgroundView = imageView
        self.tblView.tableFooterView = UIView(frame: CGRect.zero)
        tblView.delegate = self
        tblView.dataSource = self
        self.crnTbleView.delegate = self
        self.crnTbleView.dataSource = self
        crnTbleView.isHidden = true
        crnTbleView.backgroundColor = .white
        
        // Transperent NavigationBar
        //self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        //Servicecall
        self.crnServiceCAll()
        self.courceServiceCall()
        //self.teacherServiceCall()
        
        if edit {
            self.saveBarBtn.title = "Edit"
            self.tblView.isUserInteractionEnabled = false
        }
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        //Looks for single or multiple taps.
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
     func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        crnTbleView.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.defaultTableViewInset = self.tblView.contentInset
        Utility.sharedInstance().setstatusbarColorClear()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Utility.sharedInstance().setstatusbarColor()
        self.navigationController?.view.backgroundColor = UIColor.red
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateClass"), object: nil, userInfo: ["myclass":"refresh"])
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : TABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return 8
        }else {
            print("cc",crnName.count)
            return searchCrn.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
        switch indexPath.row {
        case 0:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "crnCell", for: indexPath) as! ClassesCell
            cell.crnTextFld.delegate = self
            if crnValue == "CRN#*"{
                cell.crnTextFld.text = ""
                cell.crnTextFld.placeHolderCustomized("CRN#*", strHexColor: "ffffff")
            }else {
                cell.crnTextFld.text = crnValue
            }
            cell.crnTextFld.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)
            crnIndexpath = indexPath
            cell.crnTextFld.tag = 0
            return cell
        case 1:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "currentCell", for: indexPath) as! ClassesCell
            cell.currentSegment.layer.cornerRadius = 5.0
            cell.currentSegment.layer.masksToBounds = true
            if self.CurrentSeg == "Current"{
                cell.currentSegment.selectedSegmentIndex = 0
            }else {
                cell.currentSegment.selectedSegmentIndex = 1
            }
            
            
            return cell

        case 2:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! ClassesCell
            cell.lblCourse.text = ""
            if self.courseValue == "Course Name*" {
                cell.txtCourse.text = ""
                cell.txtCourse.placeHolderCustomized("Course Name*", strHexColor: "ffffff")
            }else {
                cell.txtCourse.text = courseValue
            }
            cell.txtCourse.delegate = self
            cell.txtCourse.tag = 21
            cell.txtCourse.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)
            return cell
        case 3:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! ClassesCell
            if titleValue == "Title*"{
                cell.titleTxtFld.text = ""
                cell.titleTxtFld.placeHolderCustomized("Title*", strHexColor: "ffffff")
            }else {
                cell.titleTxtFld.text = titleValue
            }
            cell.titleTxtFld.delegate = self
            cell.titleTxtFld.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)
            cell.titleTxtFld.tag = 3
            return cell
        case 4:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "teacherCell", for: indexPath) as! ClassesCell
            cell.lblTeacher.text = teacherValue
            cell.lblTeacher.isHidden = true
            cell.txtfldTeacher.tag = 11
            cell.txtfldTeacher.delegate = self
            if teacherValue == "Teacher*" || teacherValue == ""{
                cell.txtfldTeacher.text = ""
                cell.txtfldTeacher.placeHolderCustomized("Teacher*", strHexColor: "ffffff")
            }else {
                cell.txtfldTeacher.text = teacherValue
            }
            cell.txtfldTeacher.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)
            return cell
        case 5:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! ClassesCell
            cell.bookSeg.layer.cornerRadius = 5.0
            cell.bookSeg.layer.masksToBounds = true
            if bookBool == "no" {
                cell.bookSeg.selectedSegmentIndex = 1
            }else {
                cell.bookSeg.selectedSegmentIndex = 0
            }
            
            //indexpath = indexPath
           
            return cell
        case 6:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! ClassesCell
            cell.noteSeg.layer.cornerRadius = 5.0
            cell.noteSeg.layer.masksToBounds = true
            
            if self.noteBool == "no" {
                cell.noteSeg.selectedSegmentIndex = 1
            }else {
                cell.noteSeg.selectedSegmentIndex = 0
            }
            //indexpath = indexPath
            
            return cell
        default:
            let cell = self.tblView.dequeueReusableCell(withIdentifier: "saveBtnCell", for: indexPath) as! ClassesCell
            if tag == "create_class" {
                cell.saveAndMoreBtn.isHidden = false
            }else {
                cell.saveAndMoreBtn.isHidden = true
            }
            
            return cell
        }
        }  else {
            let cell = self.crnTbleView.dequeueReusableCell(withIdentifier: "crnDetailCell", for: indexPath)
            cell.textLabel?.text = searchCrn[indexPath.row]
            cell.textLabel?.textColor = .black
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            cell.backgroundColor = .clear

            if indexPath.row == 7 || indexPath.row == 6 {
                cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            if indexPath.row == 0 {
                return 120
            }else if indexPath.row == 1 || indexPath.row == 3 {
                return 0
            }else {
                return 80
            }
        }else {
                return 50
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if tableView.tag == 0 {
             self.crnTbleView.isHidden = true
        if indexPath.row == 2 {
            let values = Array(courceList.keys) as [String]
            if values.count <= 0 {
                Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Record not found.", iButtonTitle: "OK", iViewController: self)
                return
            }else {
                PickerView().show(title: "Courses", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: values, selected:nil,iViewController:self) { (value) -> Void in
                    let cell = tableView.cellForRow(at: indexPath) as! ClassesCell
                    cell.txtCourse.text = value
                    //self.courceId = self.courceList[value]!
                    self.courseValue = value
                    //print(self.courceId)
                }
            }
 
        }
        
        else if indexPath.row == 4 {
            //let values = Array(teacherList.keys) as [String]
            //if values.count <= 0 {
                //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please Select Course First", iButtonTitle: "OK", iViewController: self)
               // return
            //}else {
            //self.teacherServiceCall()
                /*PickerView().show(title: "Teachers", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: values, selected:nil,iViewController:self) { (value) -> Void in
                    let cell = tableView.cellForRow(at: indexPath) as! ClassesCell
                    cell.lblTeacher.text = value
                    self.teacherId = self.teacherList[value]!
                    print(self.teacherId)*/
                //}
            //}
            
        }
        }else {
            let cell = tblView.cellForRow(at: crnIndexpath!) as! ClassesCell
            self.crnValue = searchCrn[indexPath.row]
            cell.crnTextFld.text = crnValue
            self.getCrndetailServiceCall()
        }

    }
    //MARK:UITEXTFIELD DELEGATE
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
        /*self.crnTbleView.isHidden = false
        self.crnTbleView.reloadData()
       self.crnTbleView.frame = CGRect(x:30, y:self.tblView.bounds.origin.y+120, width: textField.bounds.width, height: self.crnTbleView.contentSize.height)*/
        }else {
            self.crnTbleView.isHidden = true
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.crnTbleView.isHidden = false

            let str = "\(textField.text!)"
                print(str)
            let searchedArray = crnName.filter { (string) -> Bool in
                return string.range(of: str, options: .caseInsensitive) != nil
            }
            print(searchedArray)
            if searchedArray == [] {
                self.searchCrn = self.crnName
                self.crnTbleView.isHidden = true
            }else {
                self.searchCrn = searchedArray
            
            }
            self.crnTbleView.reloadData()
            self.crnTbleView.frame = CGRect(x:30, y:120, width: textField.bounds.width, height: self.crnTbleView.contentSize.height)
            self.crnValue = "\(textField.text!)"
        }else if textField.tag == 3 {
            self.titleValue = textField.text!
        }
        
        if textField.tag == 11 {
            self.teacherValue = textField.text!
        }
        
        if textField.tag == 21 {
            self.courseValue = textField.text!
        }
    }
    
    
    //MARK:UIViewController Events
    
    @IBAction func saveandmoreBtnClicked(_ sender: Any) {
    
        if crnValue == "CRN#*"   {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter CRN#", iButtonTitle: "OK", iViewController: self)
            return
        }
        if courseValue == "Course Name*" {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please select Course Name", iButtonTitle: "OK", iViewController: self)
            return
        }
//        if titleValue == "Title*" || titleValue == "" {
//            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter title", iButtonTitle: "OK", iViewController: self)
//            return
//        }
        if (teacherValue) == "Teacher*" || (teacherValue) == "" {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please select teacher", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        let dictLoginParameter = NSDictionary(dictionary:["tag":"create_class","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","class_type":self.CurrentSeg,"title":"","course_name":"\(self.courseValue)","teacher_name":"\(teacherValue)","crn_id":self.crnValue,"books":self.bookBool,"notes":self.noteBool,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                
                let iDictUserData = iData as! NSDictionary
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber{
                    if iIntSuccess == 1 {
                        self.crnValue = "CRN#*"
                        self.courseValue = "Course Name*"
                        self.teacherValue = "Teacher*"
                        self.titleValue = "Title*"
                        self.bookBool = "no"
                        self.noteBool = "no"
                        self.CurrentSeg = "Current"
                        self.tblView.reloadData()
                        let Alert = UIAlertController(title: "", message: "\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)", preferredStyle: UIAlertControllerStyle.alert)
                        
                        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            
                            Constant.USER_DEFAULT.set("1", forKey: Constant.CREATE_CLASS)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateClass"), object: nil, userInfo: ["myclass":"refresh"])
                           
                        }))
                        
                        self.present(Alert, animated: true, completion: nil)
                        
                        self.crnServiceCAll()
                        self.courceServiceCall()
                    }
                }else {
                    Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                }
                
            }
        }
        
    }
    
    
    @IBAction func backBarBtnClicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        /*
         "tag":"update_class",
         "class_id":1,
         "user_id":3,
         "school_id":1,
         "course_id":"2",
         "teacher_id":"2",
         "crn_id":"2",
         "books":"no",
         "notes":"yes",
         "title":"Accounting",
         "token":"2076095124"

 */
        if edit {
            self.tag = "update_class"
            self.saveBarBtn.title = "Save"
            self.tblView.isUserInteractionEnabled = true
            self.edit = false
        }else {
        
        if crnValue == "CRN#*"   {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter CRN#", iButtonTitle: "OK", iViewController: self)
            return
        }
        if courseValue == "Course Name*" {
         Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter Course Name", iButtonTitle: "OK", iViewController: self)
         return
         }
//         if titleValue == "Title*" || titleValue == ""{
//         Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter title", iButtonTitle: "OK", iViewController: self)
//         return
//         }
         if (teacherValue) == "Teacher*"  || teacherValue == ""{
         Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter teacher name", iButtonTitle: "OK", iViewController: self)
         return
         }
        var dictLoginParameter = NSDictionary()
        if tag == "update_class" {
            //tag: update_class
            //class_id, user_id, school_id, token, course_name, crn_id, teacher_name, title, books, notes, class_type
            
            dictLoginParameter = NSDictionary(dictionary:["tag":self.tag,"class_id":self.class_id,"user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","class_type":self.CurrentSeg,"title":"","course_name":"\(self.courseValue)","teacher_name":"\(teacherValue)","crn_id":self.crnValue,"books":self.bookBool,"notes":self.noteBool,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        }else {
            //tag: create_class
            //user_id, school_id, token, course_name, crn_id, teacher_name, title, books, notes, class_type
            dictLoginParameter = NSDictionary(dictionary:["tag":self.tag,"user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","class_type":self.CurrentSeg,"title":"","course_name":"\(self.courseValue)","teacher_name":"\(teacherValue)","crn_id":self.crnValue,"books":self.bookBool,"notes":self.noteBool,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        }
        print(dictLoginParameter)
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    let iDictUserData = iData as! NSDictionary
                    if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber{
                        if iIntSuccess == 1 {
                            
                            if self.tag == "update_class" || self.boo{
                                let alert = UIAlertController(title: "", message: iDictUserData.object(forKey: Constant.MESSAGE) as! String, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                                    
                                     _ = self.navigationController?.popViewController(animated: true)
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                                
                            }else {
                                Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                                    //Constant.appDelegate.createMenubar()
                                

                            }
                            Constant.USER_DEFAULT.set("1", forKey: Constant.CREATE_CLASS)
                        }
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func bookSegment(_ sender: UISegmentedControl) {
        if (sender).selectedSegmentIndex  == 0 {
            self.bookBool = "yes"
        }else {
            self.bookBool = "no"
        }
    }
    
    @IBAction func noteSegment(_ sender: UISegmentedControl) {
        if (sender).selectedSegmentIndex  == 0 {
            self.noteBool = "yes"
        }else {
            self.noteBool = "no"
        }
    }
    
    @IBAction func currentSegmentController(_ sender: UISegmentedControl) {
        //if (sender).selectedSegmentIndex  == 0 {
            self.CurrentSeg = "Current"
        //}else {
            //self.CurrentSeg = "Previous"
        //}

    }
    
    
    
    
    //MARK : WEB SERVICE CALL
    
    func crnServiceCAll(){
        let dictLoginParameter = NSDictionary(dictionary: ["tag": "crn_list","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)"])

        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        if let crnData = iDictUserData.object(forKey: "crn_list") as? [Any] {
                            for i in crnData {
                                self.crnName.append("\(i)")
                            }
                        }
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                    self.searchCrn = self.crnName
                    self.crnTbleView.reloadData()
                }
                
            }
        }
    }
    func getCrndetailServiceCall(){
        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"get_crn_details","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","crn_no":self.crnValue])
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        if let crnData = iDictUserData.object(forKey: "crn_details") as? [String:Any] {
                            self.crnId = "\(crnData["id"]!)"
                            if let carr = crnData["courses"] as? NSArray {
                                if carr.count > 0 {
                                    self.courseValue = "\(carr[0] as! String)"
                                }else {
                                    self.courseValue = ""
                                }
                                
                            }else {
                                self.courseValue = ""
                            }
                            //self.courceId = "\(crnData["course_id"]!)"
                            if let teacher:String = crnData["teacher_name"] as? String {
                                self.teacherValue = teacher
                            }else {
                                self.teacherValue = ""
                            }
                            self.teacherId = "\(crnData["teacher_id"]!)"
                            self.tblView.reloadData()
                        }
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }

    }
    func courceServiceCall(){
        let dictLoginParameter = NSDictionary(dictionary: ["tag": "course_list","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        if let courceData = iDictUserData.object(forKey: "course_list") as? [NSDictionary] {
                            for i in courceData {
                                self.courceList["\(i.object(forKey: "name")!)"] = "\(i.object(forKey: "id")!)"
                            }
                        }
                    }else {
                        //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }
    }
    
    func teacherServiceCall(){
        if courseValue == "Course Name*" {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please select course", iButtonTitle: "OK", iViewController: self)
            return
        }

        let dictLoginParameter = NSDictionary(dictionary: ["tag": "teachers_list","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","course_name":"\(self.courseValue)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)"])
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        if let teacherData = iDictUserData.object(forKey: "teachers_list") as? [NSDictionary] {
                            self.teacherList.removeAll()
                            for i in teacherData {
                                self.teacherList["\(i.object(forKey: "name")!)"] = "\(i.object(forKey: "id")!)"
                            }
                            
                            let values = Array(self.teacherList.keys) as [String]
                            PickerView().show(title: "Teachers", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: values, selected:nil,iViewController:self) { (value) -> Void in
                                let indexPath = IndexPath(item: 4, section: 0)
                                let cell = self.tblView.cellForRow(at: indexPath) as! ClassesCell
                                cell.lblTeacher.text = value
                                self.teacherId = self.teacherList[value]!
                                print(self.teacherId)
                            }

                        }
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                        let indexPath = IndexPath(item: 4, section: 0)
                        let cell = self.tblView.cellForRow(at: indexPath) as! ClassesCell
                        self.teacherValue = "Teacher*"
                        cell.lblTeacher.text = self.teacherValue
                        self.teacherList.removeAll()
                    }
                }
                
            }
        }
        
    }
    
    
   
    func keyboardWillShow(_ notification:Notification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            //self.view.frame.origin.y -= keyboardSize.height
            /*var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var contentInset:UIEdgeInsets = self.tblView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.tblView.contentInset = contentInset
            
            //get indexpath
            print(index)
            let indexpath = NSIndexPath(row: 2, section: 0)
            
            self.tblView.scrollToRow(at: indexpath as IndexPath, at: UITableViewScrollPosition.top, animated: true)*/
        }
        
    }
    
    
    // This method will adjust tableview inset when keyboard will disappear
    
    func keyboardWillHide(_ notification:Notification)
    {
        /*UIView.beginAnimations("tableViewAnimation", context: nil)
        UIView.setAnimationDuration(0.1)
        // change tableview inset to default
        self.tblView.contentInset = self.defaultTableViewInset!
        UIView.commitAnimations()*/
        self.crnTbleView.isHidden = true
        //self.getCrndetailServiceCall()
    }

    
}
