//
//  SG_InsightVC.swift
//  Student_GPA
//
//  Created by mac 2 on 18/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_InsightVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

     @IBOutlet weak var tableView: UITableView!
    
    var favouriteList = [[String:Any]]()
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "INSIGHTS"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let insightNib = UINib(nibName: Constant.INSIGHT_NIBNAME, bundle: nil)
        self.tableView.register(insightNib, forCellReuseIdentifier: Constant.INSIGHT_CELLID)
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
        
        self.getFavouriteListServiceCall()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utility.sharedInstance().setstatusbarColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK : TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   favouriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "InsightCell", for: indexPath) as! InsightCell
        if self.favouriteList[indexPath.row]["photo"] as? String != "" {
            //cell.profileImgView.imageURL = NSURL(string: (self.favouriteList[indexPath.row]["photo"] as? String)!) as URL!

        }else {
            //cell.profileImgView.image = #imageLiteral(resourceName: "User_profile")
        }

        cell.userNameLbl.text = favouriteList[indexPath.row]["favorite_name"] as? String
        cell.userNameLbl.tag = indexPath.row
        cell.userNameLbl.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(userNameLblTaped(_:)))
        
        
        cell.userNameLbl.addGestureRecognizer(tap)
        cell.msgCntLbl.text = favouriteList[indexPath.row]["msg_count"] as? String
        
        //
        cell.removeFavBtn.tag = indexPath.row
        cell.removeFavBtn.layer.cornerRadius = 10.0
        cell.removeFavBtn.layer.masksToBounds = true
        cell.removeFavBtn.addTarget(self,action:#selector(removeFavBtnTaped),for:.touchUpInside)
        
        cell.msgBtn.tag = indexPath.row
        cell.msgBtn.addTarget(self,action:#selector(msgBtnTaped),for:.touchUpInside)
        cell.imgBtn.tag = indexPath.row
        cell.imgBtn.addTarget(self, action: #selector(imgBtnTaped(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 115
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    //MARK:WEBSERVICES
    func getFavouriteListServiceCall(){
        
        let dictParameter = NSDictionary(dictionary: ["tag":"fav_list","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        print(dictParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_USER, WSParams: dictParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictNotiData = iData as! NSDictionary
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        print(iData ?? "e")
                        if let details = iDictNotiData.object(forKey: "favorite_list") as? NSArray {
                            for i in details{
                                self.favouriteList.append(i as! [String : Any])
                            }
                        }
                        self.tableView.reloadData()
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)                    }
                }
            }
            
        }
    }
    
    //MARK:EVENTS
    func removeFavBtnTaped(sender:UIButton){
        /*
         "tag":"remove_from_fav",
         "id":"3",
         "user_id":"2",
         "token":"2076095124"
 */
        let dictParameter = NSDictionary(dictionary: ["tag":"remove_from_fav","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","user_id":"\(favouriteList[sender.tag]["user_id"]!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        print(dictParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_USER, WSParams: dictParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictNotiData = iData as! NSDictionary
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    print(iData ?? "e")
                    if iIntSuccess == 1 {
                        self.favouriteList.remove(at: sender.tag)
                        let indexPath = IndexPath(item: sender.tag, section: 0)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
            }
            
        }

        
    }
    func msgBtnTaped(sender:UIButton){
        self.index = sender.tag
        self.performSegue(withIdentifier: "insightChat", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "insightChat" {
//            let nextVC = segue.destination as! CC_UserChatVC
//            nextVC.strChatUserName = favouriteList[index]["favorite_name"] as! String
//            nextVC.intChatUserID = favouriteList[index]["fav_user_id"] as! String
//            nextVC.strUserPhotoURL = "\(favouriteList[index]["photo"] as! String)"
            
        }
        
        
    }
    func userNameLblTaped(_ sender:UITapGestureRecognizer) {
        //let vcc = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "MypostVC") as! SG_MypostVC
        //self.navigationController?.pushViewController(vcc, animated: true)
       let lbl = sender.view
        
        
        let dataAry = ["attachements":[],"comments":[],"created_by":"\(self.favouriteList[lbl!.tag]["favorite_name"]!)" ,"created_date":"48 minutes ago","like":[],"photo":"\(self.favouriteList[lbl!.tag]["photo"]!)","post_description":"Hiii","post_id":"460","post_type":"text","school_id":"\(self.favouriteList[lbl!.tag]["school_id"]!)" ,"tagged":[],"user_id":"\(self.favouriteList[lbl!.tag]["fav_user_id"]!)","insight_user":"1"] as [String : Any]
        let postdataModel = SG_POST_DATA(fromDictionary: (dataAry))
        //let viewController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "MypostVC") as? SG_MypostVC
//        let nav = UINavigationController(rootViewController: viewController!)
//        viewController?.title = "\(self.favouriteList[lbl!.tag]["favorite_name"]!)"
//        viewController?.myPost = false
//        viewController?.postDataUser = postdataModel
//        self.navigationController?.pushViewController(viewController!, animated: true)

    }
    
    func imgBtnTaped(_ sender:UIButton){
        let dataAry = ["attachements":[],"comments":[],"created_by":"\(self.favouriteList[sender.tag]["favorite_name"]!)" ,"created_date":"48 minutes ago","like":[],"photo":"\(self.favouriteList[sender.tag]["photo"]!)","post_description":"Hiii","post_id":"460","post_type":"text","school_id":"\(self.favouriteList[sender.tag]["school_id"]!)"  ,"tagged":[],"user_id":"\(self.favouriteList[sender.tag]["fav_user_id"]!)","insight_user":"1"] as [String : Any]
        let postdataModel = SG_POST_DATA(fromDictionary: (dataAry))
        //let viewController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "MypostVC") as? SG_MypostVC
//        let nav = UINavigationController(rootViewController: viewController!)
//        viewController?.title = "\(self.favouriteList[sender.tag]["favorite_name"]!)"
//        viewController?.myPost = false
//        viewController?.postDataUser = postdataModel
//        self.navigationController?.pushViewController(viewController!, animated: true)

    }
    func backBtnClicked() {
        _ = self.navigationController?.popViewController(animated: true)
        //Constant.appDelegate.createMenubar()
    }


}
