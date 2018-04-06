//
//  SG_RateofteacherVC.swift
//  Student_GPA
//
//  Created by mac 2 on 21/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_RateofteacherVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    //
    @IBOutlet weak var rOneBtn: UIButton!
    
    @IBOutlet weak var rtwoBtn: UIButton!
    
    @IBOutlet weak var rthreeBtn: UIButton!
    
    @IBOutlet weak var rfourBtn: UIButton!
    
    
    @IBOutlet weak var rfiveBtn: UIButton!
    
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var hdOneBtn: UIButton!
    
    @IBOutlet weak var hdtwoBtn: UIButton!
    
    @IBOutlet weak var hdthreeBtn: UIButton!
    
    @IBOutlet weak var hdfourBtn: UIButton!
    
    
    @IBOutlet weak var hdfiveBtn: UIButton!
    
    
    @IBOutlet weak var lblAttendance: UILabel!
    
    @IBOutlet weak var lblHomeworks: UILabel!
    @IBOutlet weak var lblTextbook: UILabel!
    @IBOutlet weak var lblGroupPrj: UILabel!
    @IBOutlet weak var lblCellphone: UILabel!
    @IBOutlet weak var lblCurving: UILabel!
    @IBOutlet weak var lblTakeagain: UILabel!
    
    @IBOutlet weak var lblComment: UILabel!
    //
    var teacher:TeacherList!
    var teacherDetails = [[String:Any]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(teacher.name)"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView.allowsSelection = false
        let titleNib = UINib(nibName: Constant.SEARCH_NIBNAME, bundle: nil)
        self.tableView.register(titleNib, forCellReuseIdentifier: Constant.SEARCH_CELLID)
        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
        let rightButton: UIBarButtonItem =  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addBtnTaped))
        self.navigationItem.rightBarButtonItem = rightButton
        //if teacher["rated_teacher"] as! NSNumber != 0 {
            self.teacherServiceCall()
        //}
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            Utility.sharedInstance().setstatusbarColor()
       
         self.teacherServiceCall()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : TABLEVIEW DATASOURCE
    func numberOfSections(in tableView: UITableView) -> Int {
        return teacherDetails.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Course/crnCell", for: indexPath) as! RateofteacherCell
            cell.courseLbl.text = "\(teacherDetails[indexPath.section]["course_crn"]!)"
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RatemyteacherCell", for: indexPath) as! RateofteacherCell
            
            let rate:String = "\(teacherDetails[indexPath.section]["rate"]!)"
            cell.lblRating.text = "\(rate) ratings"
            cell.rOneBtn.isHidden = true
            cell.rtwoBtn.isHidden = true
            cell.rthreeBtn.isHidden = true
            cell.rfourBtn.isHidden = true
            cell.rfiveBtn.isHidden = true
            let no:Int = Int(rate)!
            if no > 0{
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
            }
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "HowdifficultCell", for: indexPath) as! RateofteacherCell
            let hdrate = "\(teacherDetails[indexPath.section]["difficult"]!)"
            cell.hdOneBtn.isHidden = true
            cell.hdtwoBtn.isHidden = true
            cell.hdthreeBtn.isHidden = true
            cell.hdfourBtn.isHidden = true
            cell.hdfiveBtn.isHidden = true
            let no:Int = Int(hdrate)!
            if no > 0 {
            for i in 1...no {
                switch i {
                case 1:
                    cell.hdOneBtn.isHidden = false
                case 2:
                    cell.hdtwoBtn.isHidden = false
                case 3:
                    cell.hdthreeBtn.isHidden = false
                case 4:
                    cell.hdfourBtn.isHidden = false
                case 5:
                    cell.hdfiveBtn.isHidden = false
                default:
                    cell.hdOneBtn.isHidden = true
                    cell.hdtwoBtn.isHidden = true
                    cell.hdthreeBtn.isHidden = true
                    cell.hdfourBtn.isHidden = true
                    cell.hdfiveBtn.isHidden = true
                }
            }
            }
            return cell
        case 3:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "AttendanceCell", for: indexPath) as! RateofteacherCell
            cell.lblAttendance.text = "\(teacherDetails[indexPath.section]["attendance"]!)"
            return cell
        case 4:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "HomeworksCell", for: indexPath) as! RateofteacherCell
            cell.lblHomework.text = "\(teacherDetails[indexPath.section]["homeworks"]!)"
            return cell
        case 5:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextbookuseCell", for: indexPath) as! RateofteacherCell
            cell.lblBook.text = "\(teacherDetails[indexPath.section]["textbook_used"]!)"
            return cell
        case 6:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "GroupprojectCell", for: indexPath) as! RateofteacherCell
            cell.lblGrp.text = "\(teacherDetails[indexPath.section]["group_projects"]!)"
            return cell
        case 7:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CellphoneuseCell", for: indexPath) as! RateofteacherCell
            cell.lblCellphone.text = "\(teacherDetails[indexPath.section]["cellphone_used"]!)"
            return cell
        case 8:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CurvingCell", for: indexPath) as! RateofteacherCell
            cell.lblCurving.text = "\(teacherDetails[indexPath.section]["curving"]!)"
            return cell
        case 9:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "WouldtakeagainCell", for: indexPath) as! RateofteacherCell
            cell.lblTakeagain.text = "\(teacherDetails[indexPath.section]["take_again"]!)"
            return cell
        
        default:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! RateofteacherCell
            cell.lblCmnt.text = "\(teacherDetails[indexPath.section]["comment"]!)"
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(teacherDetails[section]["rate_username"]!)"
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
        return 70
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0 {
            return 0
        }else if indexPath.row == 10 {
            return   UITableViewAutomaticDimension
        }else if indexPath.row == 1 {
            return 70
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 10 {
            return   UITableViewAutomaticDimension
        }else if indexPath.row == 1 {
            return 70
        }else {
            return 50
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    
    //MARK:WEBSERVICECALL
    
    func teacherServiceCall(){
        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"teacher_rate_details","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","teacher_id":"\(teacher.id)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN) as! String)"])
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_TEACHER, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        self.teacherDetails.removeAll()
                        if let teacher = iDictUserData.object(forKey: "rated") as? NSNumber {
                            if teacher == 1 {
                                self.navigationItem.rightBarButtonItem = nil
                            }
                        }
                        if let teacherData = iDictUserData.object(forKey: "teacher_rate_details") as? [NSDictionary] {
                            for i in teacherData{
                                self.teacherDetails.append(i as! [String : Any])
                            }
                        }
                        self.tableView.reloadData()
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }
        
    }


    //MARK : EVENTS
    
    func addBtnTaped(){
        self.performSegue(withIdentifier: "Addratetoteacher", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "Addratetoteacher" {
            let nextvc = segue.destination as! SG_AddratetoteacherVC
            nextvc.teacher = self.teacher
        }
    }

    func backBtnClicked() {
        _ = self.navigationController?.popViewController(animated: true)
    }


}
