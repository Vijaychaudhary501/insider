//
//  SG_ClassStudentVC.swift
//  Student_GPA
//
//  Created by mac 2 on 12/08/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_ClassStudentVC: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var clsStudent = [[String:String]]()
    
    var dindexPath = IndexPath()
    
    var courseName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CLASSMATES"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        let contactNib = UINib(nibName: Constant.CONTACT_NIBNAME, bundle: nil)
        self.tableView.register(contactNib, forCellReuseIdentifier: Constant.CONTACT_CELLID)

        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
        self.getClassStudentServiceCall()
        
        
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
        
    }
    
    //MARK:TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clsStudent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        if clsStudent[indexPath.row]["photo"] == ""{
            //cell.profileImageView.image = #imageLiteral(resourceName: "User_profile")
        }else {
            //cell.profileImageView.imageURL = NSURL(string: clsStudent[indexPath.row]["photo"]!) as! URL
        }
        cell.userLbl.text = "\(clsStudent[indexPath.row]["full_name"]!)"
        cell.selectImgView.isHidden = true
        cell.selectBtn.isHidden = true
        return cell
            
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dindexPath = indexPath
        //self.performSegue(withIdentifier: "class_studentVC", sender: nil)
        /*
         "id": "89",
         "school_id": "2",
         "first_name": "Dheeraj",
         "last_name": "Kumar",
         "full_name": "Dheeraj Kumar",
         "photo": "http://kalpcorp.in/insight/uploads/1501680159_89_post_files.jpeg",
         "insight_user": "0"

 */
        let dataAry = ["attachements":[],"comments":[],"created_by":"\(self.clsStudent[indexPath.row]["full_name"]!)","created_date":"48 minutes ago","like":[],"photo":"\(self.clsStudent[indexPath.row]["photo"]!)","post_description":"Hiii","post_id":"460","post_type":"text","school_id":"\(self.clsStudent[indexPath.row]["school_id"]!)","tagged":[],"user_id":"\(self.clsStudent[indexPath.row]["id"]!)","insight_user":"\(self.clsStudent[indexPath.row]["insight_user"]!)"] as [String : Any]
        let postdataModel = SG_POST_DATA(fromDictionary: (dataAry))
//        let viewController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "MypostVC") as? SG_MypostVC
//        //let nav = UINavigationController(rootViewController: viewController!)
//        viewController?.title = self.clsStudent[indexPath.row]["full_name"]
//        viewController?.myPost = false
//        viewController?.postDataUser = postdataModel
//        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    //MARK:WEBSERVICESCALL
    
    func getClassStudentServiceCall(){
        /*
         tag:common_students
         user_id:21
         school_id:2
         token:Wl1V57ymFTOkl2Vl56duMRkAnLZn3gnF
         course_name:Maths
 */
        let dictLoginParameter = NSDictionary(dictionary: ["tag": "common_students","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","course_name":self.courseName])
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        if let classData = iDictUserData.object(forKey: "common_students") as? NSArray {
                            for i in classData{
                                self.clsStudent.append(i as! [String : String])
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
    
    //MARK:EVENTS
    func backBtnClicked() {
        _ = self.navigationController?.popViewController(animated: true)
        //Constant.appDelegate.createMenubar()
    }
    
    func toggleRigh() {
        self.performSegue(withIdentifier: "addClassVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teacherListVC"{
            
            let nextVC = segue.destination as! SG_RatemyteacherVC
            
        }
        
    }
}
