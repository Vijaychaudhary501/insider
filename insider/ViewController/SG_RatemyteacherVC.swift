//
//  SG_RatemyteacherVC.swift
//  Student_GPA
//
//  Created by mac 2 on 18/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_RatemyteacherVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTxtFild: UITextField!
    
    var teacherList = [TeacherList]()
    var searchList = [TeacherList]()
    var index:Int = 0
    var courseName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TEACHERS"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        let RateAverageNib = UINib(nibName: "RateAverageCell", bundle: nil)
        self.tableView.register(RateAverageNib, forCellReuseIdentifier: "rateAverageCell")
        //let searchNib = UINib(nibName: Constant.SEARCH_NIBNAME, bundle: nil)
        //self.tableView.register(searchNib, forCellReuseIdentifier: Constant.SEARCH_CELLID)
        
        searchTxtFild.addBorderToBottomOfTextfield(borderColor: UIColor(hexString:"8c8c8c")!)
        searchTxtFild.setLeftViewIcon(UIImage(named:"SearchIconBlack")!)
        searchTxtFild.placeHolderCustomized("Search teacher name", strHexColor: "000000")
        searchTxtFild.delegate = self
        searchTxtFild.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
        
        self.teacherServiceCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.sharedInstance().setstatusbarColor()
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
        
        let searchedArray = teacherList.filter { (TeacherList) -> Bool in
            return TeacherList.name.range(of: str, options: .caseInsensitive) != nil
        }
        print(searchedArray)
        self.searchList = searchedArray
        
        if str == "" {
            self.searchList = self.teacherList
        }else if searchList.isEmpty{
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "No contact found", iButtonTitle: "ok", iViewController: self)
        }
        self.tableView.reloadData()
    }
    

    
    
    //MARK : TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "rateAverageCell", for: indexPath) as! RateAverageCell
        if searchList[indexPath.row].teacher_photo == "" {
           // cell.userProfImage.image = #imageLiteral(resourceName: "User_profile")
        }else {
            //cell.userProfImage.imageURL = NSURL(string: (searchList[indexPath.row].teacher_photo)) as! URL
        }
        //cell.userProfImage.layer.cornerRadius = cell.userProfImage.frame.width/2
        //cell.userProfImage.layer.masksToBounds = true
        //cell.lblTeacherName.text = searchList[indexPath.row].name
        
        
        let rate:String = "\(searchList[indexPath.row].average_rating)"
        cell.lblNoRate.isHidden = true
        cell.lblRating.isHidden = false
        cell.rOneBtn.isHidden = true
        cell.rtwoBtn.isHidden = true
        cell.rthreeBtn.isHidden = true
        cell.rfourBtn.isHidden = true
        cell.rfiveBtn.isHidden = true
        let no:Int = Int(Double(rate)!)
        if no > 0{
            cell.lblRating.text = "\(rate) ratings"
            for i in 1...no {
                switch i {
                case 1:
                    cell.rOneBtn.isHidden = false
                case 2:
                    cell.rtwoBtn.isHidden = false
                case 3:
                    cell.rthreeBtn.isHidden = false
                case 4:
                    cell.rfourBtn.isHidden = false
                case 5:
                    cell.rfiveBtn.isHidden = false
                default:
                    cell.rOneBtn.isHidden = true
                    cell.rtwoBtn.isHidden = true
                    cell.rthreeBtn.isHidden = true
                    cell.rfourBtn.isHidden = true
                    cell.rfiveBtn.isHidden = true
                }
            }
         }else {
            cell.lblNoRate.isHidden = false
            cell.lblRating.isHidden = true
        }

 
        return cell

        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.index = indexPath.row
        self.performSegue(withIdentifier: "Rateofteacher", sender: nil)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 80
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
    //MARK:WEBSERVICECALL
    
    func teacherServiceCall(){
        let dictLoginParameter = NSDictionary(dictionary: ["tag": "teachers_list","course_name":"\(self.courseName)","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)"])
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        if let teacherData = iDictUserData.object(forKey: "teachers_list") as? [NSDictionary] {
                            for i in teacherData{
                                let teacher = TeacherList(id: (i)["id"] as! String, rated_teacher: (i )["rated_teacher"] as! Int, name: (i)["name"] as! String, photo: (i)["teacher_photo"] as! String,average_rating: (i)["average_rating"] as! String)
                                self.teacherList.append(teacher)
                            }
                        }
                        self.searchList = self.teacherList
                        self.tableView.reloadData()
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }
        
    }

    //MARK:EVENTS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Rateofteacher" {
            let nextvc = segue.destination as! SG_RateofteacherVC
            nextvc.teacher = self.searchList[index]
        }
        
        if segue.identifier == "addRate" {
            let nextvc = segue.destination as! SG_AddratetoteacherVC
            nextvc.teacher = self.searchList[index]
        }
    }

    func backBtnClicked() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
