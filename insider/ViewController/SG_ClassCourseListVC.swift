//
//  SG_ClassCourseListVC.swift
//  Student_GPA
//
//  Created by mac 2 on 07/06/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_ClassCourseListVC: UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var currentCourse = [String]()
    var currentId = [String]()
    var priviousCourse = [String]()
    var priviousId = [String]()
    
    var irow:Int = 0
    var isection:Int = 0
    var dindexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MY CLASSES"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.sharedInstance().setstatusbarColor()
    }
        
    //MARK:TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return   currentCourse.count
        }else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "classCourseCell", for: indexPath)
            cell.textLabel?.text = currentCourse[indexPath.row]
            return cell
        }else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "classCourseCell", for: indexPath)
            cell.textLabel?.text = priviousCourse[indexPath.row]
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
        self.performSegue(withIdentifier: "teacherListVC", sender: nil)
    }
    
    //MARK:WEBSERVICESCALL
    func getClassServiceCall(){
        let dictLoginParameter = NSDictionary(dictionary: ["tag": "class_list","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)"])
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_CLASS, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        if let classData = iDictUserData.object(forKey: "class_list") as? NSDictionary {
                            var ar = [String]()
                            var arid = [String]()

                            if let currentdata = classData["Current"] as? [NSDictionary] {
                                ar.removeAll()
                                arid.removeAll()
                                for i in currentdata {
                                    ar.append(i["course_name"] as! String)
                                    arid.append(i["course_id"] as! String)
                                }
                                
                                self.currentCourse =  ar
                                    //Utility.sharedInstance().uniqueElementsFrom(array: ar)
                                self.currentId =  arid
                                    //Utility.sharedInstance().uniqueElementsFrom(array: arid)
                            }
                            
                            if let previousdata = classData["Previous"] as? [NSDictionary] {
                                ar.removeAll()
                                arid.removeAll()
                                //for _ in previousdata {
                                    for i in previousdata {
                                        ar.append(i["course_name"] as! String)
                                        arid.append(i["course_id"] as! String)
                                    }
                                    
                                    self.priviousCourse =  ar
                                        //Utility.sharedInstance().uniqueElementsFrom(array: ar)
                                    self.priviousId =  arid
                                        //Utility.sharedInstance().uniqueElementsFrom(array: arid)
                                    
                                }
                            //}
                            
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
        Constant.appDelegate.createMenubar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "teacherListVC"{
            
            let nextVC = segue.destination as! SG_RatemyteacherVC
            if dindexPath.section == 0 {
                nextVC.courseName = currentCourse[dindexPath.row]
                
            }else {
                nextVC.courseName = priviousId[dindexPath.row]
            }
        }
        
    }

}
