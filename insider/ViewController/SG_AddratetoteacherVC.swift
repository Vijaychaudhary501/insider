//
//  SG_AddratetoteacherVC.swift
//  Student_GPA
//
//  Created by mac 2 on 21/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_AddratetoteacherVC: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var courseTableView: UITableView!
    
    var teacher : TeacherList!
    var valueSwitchAry = [String]()
    var valueAttendence:String = ""
    var valueHomework:String = ""
    var valueComment:String = ""
    var rateValue = 0
    var hdValue = 0
    var crnValue = ""
    var crnName = [String]()
    var searchCrn = [String]()
    var courceList = [String]()
     var crnIndexpath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(teacher.name)"
        courseTableView.isHidden = true
        courseTableView.delegate = self
        courseTableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
        self.valueSwitchAry = Array(repeating: "Yes", count: 5)
        //self.crnServiceCAll()
        //self.courceServiceCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
            Utility.sharedInstance().setstatusbarColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:TABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0{
            return 11
        }else {
            return searchCrn.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0{
        switch indexPath.row {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CRNCell", for: indexPath) as! RateofteacherCell
            //cell.crnTxtFld.delegate = self
            //cell.crnTxtFld.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)
            crnIndexpath = indexPath
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RatemyteacherCell", for: indexPath) as! RateofteacherCell
            cell.rOneBtn.addTarget(self,action:#selector(rateBtnEvents),for:.touchUpInside)
            cell.rOneBtn.tag = 1
            cell.rtwoBtn.addTarget(self,action:#selector(rateBtnEvents),for:.touchUpInside)
            cell.rtwoBtn.tag = 2
            cell.rthreeBtn.addTarget(self,action:#selector(rateBtnEvents),for:.touchUpInside)
            cell.rthreeBtn.tag = 3
            cell.rfourBtn.addTarget(self,action:#selector(rateBtnEvents),for:.touchUpInside)
            cell.rfourBtn.tag = 4
            cell.rfiveBtn.addTarget(self,action:#selector(rateBtnEvents),for:.touchUpInside)
            cell.rfiveBtn.tag = 5
            
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "HowdifficultCell", for: indexPath) as! RateofteacherCell
            cell.hdOneBtn.addTarget(self,action:#selector(hdBtnEvents),for:.touchUpInside)
            cell.hdOneBtn.tag = 1
            cell.hdtwoBtn.addTarget(self,action:#selector(hdBtnEvents),for:.touchUpInside)
            cell.hdtwoBtn.tag = 2
            cell.hdthreeBtn.addTarget(self,action:#selector(hdBtnEvents),for:.touchUpInside)
            cell.hdthreeBtn.tag = 3
            cell.hdfourBtn.addTarget(self,action:#selector(hdBtnEvents),for:.touchUpInside)
            cell.hdfourBtn.tag = 4
            cell.hdfiveBtn.addTarget(self,action:#selector(hdBtnEvents),for:.touchUpInside)
            cell.hdfiveBtn.tag = 5
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as! RateofteacherCell
            cell.lblAttendance.text = "Attendance"
            //cell.lblAttendance.isUserInteractionEnabled = true
            //let tap = UITapGestureRecognizer(target: self, action: #selector(userNameLblTaped(_:)))
            //cell.lblAttendance.addGestureRecognizer(tap)
            cell.lblAttendance.tag = indexPath.row
            return cell
        case 4:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "HomeworksCell", for: indexPath) as! RateofteacherCell
            cell.lblHomework.text = "Homework"
            //cell.lblHomework.isUserInteractionEnabled = true
            //let tap = UITapGestureRecognizer(target: self, action: #selector(userNameLblTaped(_:)))
            //cell.lblHomework.addGestureRecognizer(tap)
            cell.lblHomework.tag = indexPath.row
            return cell
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextbookuseCell", for: indexPath) as! RateofteacherCell
            //cell.textBook.isOn = false
            
            cell.textBookSegment.tag = indexPath.row
            cell.textBookSegment.addTarget(self, action: #selector(segmentEvent), for: .valueChanged)
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupprojectCell", for: indexPath) as! RateofteacherCell
        
            //cell.grpSegment.isOn = false
            cell.grpSegment.tag = indexPath.row
            cell.grpSegment.addTarget(self, action: #selector(segmentEvent), for: .valueChanged)
            return cell
        case 7:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellphoneuseCell", for: indexPath) as! RateofteacherCell
            //cell.cellPhone.isOn = false
            cell.cellphoneSegment.tag = indexPath.row
            cell.cellphoneSegment.addTarget(self, action: #selector(segmentEvent), for: .valueChanged)
            return cell
        case 8:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CurvingCell", for: indexPath) as! RateofteacherCell
            //cell.curving.isOn = false
            cell.curvingSegment.tag = indexPath.row
            cell.curvingSegment.addTarget(self, action: #selector(segmentEvent), for: .valueChanged)
            return cell
        case 9:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "WouldtakeagainCell", for: indexPath) as! RateofteacherCell
            //cell.takeAgain.isOn = false
            cell.takeagainSegment.tag = indexPath.row
            cell.takeagainSegment.addTarget(self, action: #selector(segmentEvent), for: .valueChanged)
            return cell
            
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! RateofteacherCell
            cell.commentTxtview.delegate = self
            cell.commentTxtview.layer.borderColor = UIColor.init(hexString: "cbcbcb")?.cgColor
            cell.commentTxtview.layer.borderWidth = 1.0
            return cell
        }
        }else {
            let cell = self.courseTableView.dequeueReusableCell(withIdentifier: "courseDetailCell", for: indexPath)
            cell.textLabel?.text = searchCrn[indexPath.row]
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0{
            
        if indexPath.row == 3 {
            PickerView().show(title: "Attendance", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: ["Mandatory","Optional"], selected:nil,iViewController:self) { (value) -> Void in
                
                let cell = self.tableView.cellForRow(at: indexPath) as! RateofteacherCell
                cell.lblAttendance.text = value
                self.valueAttendence = value
            }
        }else if indexPath.row == 4 {
            PickerView().show(title: "Homework", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: ["Mandatory","Optional"], selected:nil,iViewController:self) { (value) -> Void in
                
                let cell = self.tableView.cellForRow(at: indexPath) as! RateofteacherCell
                cell.lblHomework.text = value
                self.valueHomework = value
            }
        }
            self.courseTableView.isHidden = true
        }else {
            let cell = self.tableView.cellForRow(at:crnIndexpath!) as! RateofteacherCell
            self.crnValue = searchCrn[indexPath.row]
            cell.crnTxtFld.text = crnValue
            self.courseTableView.isHidden = true
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0{
            if indexPath.row == 0 {
                return 0
            }else if indexPath.row == 1 {
                return 80
            }else if indexPath.row == 10 {
                return 200
            }else {
                return 65
            }
        }else {
            return 40
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    //MARK:TEXTFILD
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.courseTableView.isHidden = false
        self.courseTableView.reloadData()
        self.courseTableView.frame = CGRect(x:30, y:120, width: textField.bounds.width, height: self.courseTableView.contentSize.height)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.courseTableView.isHidden = false
        
        let str = "\(textField.text!)"
        print(str)
        let searchedArray = crnName.filter { (string) -> Bool in
            return string.range(of: str, options: .caseInsensitive) != nil
        }
        print(searchedArray)
        if searchedArray == [] {
            self.searchCrn = self.crnName
            //self.courseTableView.isHidden = true
        }else {
            self.searchCrn = searchedArray
        }
        self.courseTableView.reloadData()
        self.courseTableView.frame = CGRect(x:30, y:120, width: textField.bounds.width, height: self.courseTableView.contentSize.height)
        self.crnValue = "\(textField.text!)"
    }

    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Comment"{
            textView.text = ""
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.valueComment = textView.text
    }
    
    
    func userNameLblTaped(_ sender:UITapGestureRecognizer) {
        let lbl = sender.view
        
        if lbl?.tag == 3 {
            PickerView().show(title: "Attendance", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: ["Senior","Junior","Freshman","Sophmore","Grade Student"], selected:nil,iViewController:self) { (value) -> Void in
                let index = IndexPath(item: lbl!.tag, section: 0)
                let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
                cell.lblAttendance.text = value
                self.valueAttendence = value
            }
        }else if lbl?.tag == 4 {
            PickerView().show(title: "Homework", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: ["Senior","Junior","Freshman","Sophmore","Grade Student"], selected:nil,iViewController:self) { (value) -> Void in
                let index = IndexPath(item: lbl!.tag, section: 0)
                let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
                cell.lblHomework.text = value
                self.valueHomework = value
            }
        }

    }
    
    //MARK:WEB SERVICE CALL
    
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
                                self.crnName.append(i.object(forKey: "name") as! String)
                            }
                        }
                        self.searchCrn = self.crnName
                        self.courseTableView.reloadData()
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }
    }

    
    //MARK:EVENTS
    func rateBtnEvents(sender:UIButton){
        let index = IndexPath(item: 1, section: 0)
        switch sender.tag {
        case 1:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
                sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                rateValue =  1
                //sender.tintColor = UIColor(hexString: "ff8400")
                let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
                cell.rtwoBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                cell.rthreeBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                cell.rfourBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                cell.rfiveBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            /*}else {
                sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                rateValue = rateValue - 1
                sender.tintColor = UIColor(hexString: "acacac")
            }*/
        case 2:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
                sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                 rateValue = 2
                sender.tintColor = UIColor(hexString: "ff8400")
                let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
                cell.rOneBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rtwoBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rthreeBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                cell.rfourBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                cell.rfiveBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            /*}else {
                sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                 rateValue = rateValue - 1
                sender.tintColor = UIColor(hexString: "acacac")
            }*/
        case 3:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
                sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                 rateValue = 3
                sender.tintColor = UIColor(hexString: "ff8400")
                let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
                cell.rOneBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rtwoBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rthreeBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rfourBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                cell.rfiveBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            /*}else {
                sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                 rateValue = rateValue - 1
                sender.tintColor = UIColor(hexString: "acacac")
            }*/
        case 4:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
                sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                 rateValue = 4
                sender.tintColor = UIColor(hexString: "ff8400")
                let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
                cell.rOneBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rtwoBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rthreeBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rfourBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rfiveBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            /*}else {
                sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                 rateValue = rateValue - 1
                sender.tintColor = UIColor(hexString: "acacac")
            }*/
        case 5:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
                sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                 rateValue = 5
                sender.tintColor = UIColor(hexString: "ff8400")
                let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
                cell.rOneBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rtwoBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rthreeBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rfourBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                cell.rfiveBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            /*}else {
                sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                 rateValue = rateValue - 1
                sender.tintColor = UIColor(hexString: "acacac")
            }*/

        default:
            if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
                sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                 rateValue = rateValue + 1
                sender.tintColor = UIColor(hexString: "ff8400")
            }else {
                sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                 rateValue = rateValue - 1
                sender.tintColor = UIColor(hexString: "acacac")
            }
        }
        
        
    }
    
    func hdBtnEvents(sender:UIButton){
        let index = IndexPath(item: 2, section: 0)
        switch sender.tag {
        case 1:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
            sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            //sender.tintColor = UIColor(hexString: "ff8400")
            let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
            cell.hdtwoBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            cell.hdthreeBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            cell.hdfourBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            cell.hdfiveBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            hdValue = 1
            
            /*}else {
                sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                hdValue = hdValue - 1
                sender.tintColor = UIColor(hexString: "acacac")
            }*/
        case 2:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
            sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            //sender.tintColor = UIColor(hexString: "ff8400")
            let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
            cell.hdOneBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdtwoBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdthreeBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            cell.hdfourBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            cell.hdfiveBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            hdValue = 2
            
            /*}else {
             sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
             hdValue = hdValue - 1
             sender.tintColor = UIColor(hexString: "acacac")
             }*/
        case 3:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
            sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            //sender.tintColor = UIColor(hexString: "ff8400")
            let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
            cell.hdOneBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdtwoBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdthreeBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdfourBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            cell.hdfiveBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            hdValue = 3
            
            /*}else {
             sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
             hdValue = hdValue - 1
             sender.tintColor = UIColor(hexString: "acacac")
             }*/
        case 4:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
            sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            //sender.tintColor = UIColor(hexString: "ff8400")
            let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
            cell.hdOneBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdtwoBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdthreeBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdfourBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdfiveBtn.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
            hdValue = 4
            
            /*}else {
             sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
             hdValue = hdValue - 1
             sender.tintColor = UIColor(hexString: "acacac")
             }*/
        case 5:
            //if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
            sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            //sender.tintColor = UIColor(hexString: "ff8400")
            let cell = self.tableView.cellForRow(at: index) as! RateofteacherCell
            cell.hdOneBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdtwoBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdthreeBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdfourBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            cell.hdfiveBtn.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
            hdValue = 5
            
            /*}else {
             sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
             hdValue = hdValue - 1
             sender.tintColor = UIColor(hexString: "acacac")
             }*/
            
        default:
            if (sender.imageView?.image == #imageLiteral(resourceName: "StarNormal")){
                sender.setImage(#imageLiteral(resourceName: "StarSelected"), for: UIControlState())
                hdValue = hdValue + 1
                sender.tintColor = UIColor(hexString: "ff8400")
            }else {
                sender.setImage(#imageLiteral(resourceName: "StarNormal"), for: UIControlState())
                hdValue = hdValue - 1
                sender.tintColor = UIColor(hexString: "acacac")
            }
        }
    }
    
    func segmentEvent(sender:UISegmentedControl){
        switch sender.tag {
        case 5:
            if (sender).selectedSegmentIndex  == 0 {
                self.valueSwitchAry[0] = "Yes"
            }else {
                self.valueSwitchAry[0] = "No"
            }

        case 6:
            if (sender).selectedSegmentIndex  == 0 {
                self.valueSwitchAry[1] = "Yes"
            }else {
                self.valueSwitchAry[1] = "No"
            }
        case 7:
            if (sender).selectedSegmentIndex  == 0 {
                self.valueSwitchAry[2] = "Yes"
            }else {
                self.valueSwitchAry[2] = "No"
            }
        case 8:
            if (sender).selectedSegmentIndex  == 0 {
                self.valueSwitchAry[3] = "Yes"
            }else {
                self.valueSwitchAry[3] = "No"
            }

        case 9:
            if (sender).selectedSegmentIndex  == 0 {
                self.valueSwitchAry[4] = "Yes"
            }else {
                self.valueSwitchAry[4] = "No"
            }

        default:
            if (sender).selectedSegmentIndex  == 0 {
                self.valueSwitchAry[0] = "Yes"
            }else {
                self.valueSwitchAry[0] = "No"
            }

        }
    }

    
    func switchEvent(sender:UISwitch){
        switch sender.tag {
        case 5:
            if sender.isOn {
                sender.isOn = false
                self.valueSwitchAry[0] = "No"
            }else {
                sender.isOn = true
                self.valueSwitchAry[0] = "Yes"
            }
        case 6:
            if sender.isOn {
                sender.isOn = false
                self.valueSwitchAry[1] = "No"
            }else {
                sender.isOn = true
                self.valueSwitchAry[1] = "Yes"
            }
        case 7:
            if sender.isOn {
                sender.isOn = false
                self.valueSwitchAry[2] = "No"
            }else {
                sender.isOn = true
                self.valueSwitchAry[2] = "Yes"
            }
        case 8:
            if sender.isOn {
                sender.isOn = false
                self.valueSwitchAry[3] = "No"
            }else {
                sender.isOn = true
                self.valueSwitchAry[3] = "Yes"
            }
        case 9:
            if sender.isOn {
                sender.isOn = false
                self.valueSwitchAry[4] = "No"
                
            }else {
                sender.isOn = true
                self.valueSwitchAry[4] = "Yes"
            }
        default:
            sender.isOn = true
        }
    }
    
    func backBtnClicked() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitBtnTaped(_ sender: Any) {
        /*"tag":"rate_teacher",
         "id":3,
         "teacher_id":2,
         "rate":5,
         "difficult":4,
         "attendance":"mandatory",
         "homeworks":"mandatory",
         "textbook_used":1,
         "group_projects":1,
         "cellphone_used":0,
         "curving":1,
         "take_again":1,
         "comment":"I like the teaching style.",
         "token":"2076095124"*/
        print(valueComment)
        print(valueSwitchAry)
        /*if Utility.trim(crnValue) == "" {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"Please enter course/crn" , iButtonTitle: "Ok", iViewController: self)
            return
        }*/
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"rate_teacher",
                                                           "id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)",
                                                            "course_crn":"",
                                                           "teacher_id":"\(teacher.id)",
                                                           "rate":self.rateValue,
                                                           "difficult":self.hdValue,
                                                           "attendance":self.valueAttendence,
                                                           "homeworks":self.valueHomework,
                                                           "textbook_used":self.valueSwitchAry[0],
                                                           "group_projects":self.valueSwitchAry[1],
                                                           "cellphone_used":self.valueSwitchAry[2],
                                                           "curving":self.valueSwitchAry[3],
                                                           "take_again":self.valueSwitchAry[4],
                                                           "comment":self.valueComment,
                                                           "token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_TEACHER, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        let Alert = UIAlertController(title: "", message: "\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)", preferredStyle: UIAlertControllerStyle.alert)
                        
                        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            _ = self.navigationController?.popViewController(animated: true)
                        }))
                        
                        self.present(Alert, animated: true, completion: nil)
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
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
        self.courseTableView.isHidden = true
        
    }

}
