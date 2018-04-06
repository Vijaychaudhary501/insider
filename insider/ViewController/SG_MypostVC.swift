//
//  SG_MypostVC.swift
//  Student_GPA
//
//  Created by mac 2 on 18/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SG_MypostVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var groupStudyView: UIView!
    
    @IBOutlet weak var grptableView: UITableView!
    
    var myPost:Bool = true
    var cmntLblTag:Int?
    var postEmpty = false
    var postPage:Int = 0
    let indicator = UIActivityIndicatorView()
    var postDataUser:SG_POST_DATA!
    var postDataArray = [SG_POST_DATA]()
    var groupStudyArray = [[String:Any]]()
    let userid:String = "\(Constant.USER_DEFAULT.value(forKey:Constant.USER_ID)!)"
    var videoIndex = IndexPath()
    var suserid:String = ""
    var sSchoolid:String = ""
    
    var storyDataArray = [StoryDataModal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupStudyView.isHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.grptableView.delegate = self
        self.grptableView.dataSource = self
        self.grptableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.grptableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width - 40, height: grptableView.contentSize.height)
        let postdataNib = UINib(nibName: "PostdataCell", bundle: nil)
        self.tableView.register(postdataNib, forCellReuseIdentifier: "PostdataCell")
        let grpStudyNib = UINib(nibName: "GroupstudyviewCell", bundle: nil)
        self.grptableView.register(grpStudyNib, forCellReuseIdentifier: "GroupstudyCell")
        
        let leftButton: UIBarButtonItem = UIBarButtonItem(image:UIImage(named: "Back_btn") , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.backBtnClicked))
        self.navigationItem.leftBarButtonItem = leftButton
        
        //print(postDataUser)
        getStoryApiCall()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        indicator.frame = CGRect(x: self.view.frame.width / 2 - 45, y: self.view.frame.height-120, width: 90, height: 90)
        indicator.color = UIColor.darkGray
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
        self.postListAPICall(page: postPage)
        navigationController?.view.backgroundColor = UIColor.red
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        Utility.sharedInstance().setstatusbarColor()
        
    }
    //MARK : TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
                if postDataUser == nil {
                    
                    return postDataArray.count+1
                    
                }else if "\(postDataUser.user_id!)" == "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)"{
                    return postDataArray.count
            }else {
                return  postDataArray.count+1
            }
        }else {
            return groupStudyArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
        if indexPath.row == 0 {
            if "\(postDataUser.user_id!)" != "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)"{
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)   as! SG_CreatePostCell
                cell.myPostImageView.setCircleView(width: cell.myPostImageView.bounds.width)
            cell.sendMsgBtn.layer.cornerRadius = 10.0
            cell.sendMsgBtn.layer.masksToBounds = true
            
            if self.postDataUser.insight_user == "1" {
                cell.addFavouriteBtn.setTitle("Insight", for: UIControlState())
                cell.addFavouriteBtn.backgroundColor = UIColor.lightGray
                cell.addFavouriteBtn.isUserInteractionEnabled = false
            }else {
                cell.addFavouriteBtn.backgroundColor = UIColor(hexString: "ff8400")
                cell.addFavouriteBtn.isUserInteractionEnabled = true
            }
            cell.addFavouriteBtn.layer.cornerRadius = 10.0
            cell.addFavouriteBtn.layer.masksToBounds = true
            cell.viewGrpStudyBtn.layer.cornerRadius = 10.0
            cell.viewGrpStudyBtn.layer.masksToBounds = true
            cell.classBtn.layer.cornerRadius = 10.0
            cell.classBtn.layer.masksToBounds = true
            
            cell.myPostImageView.setCircleView(width: cell.myPostImageView.bounds.width)
            
                if postDataUser == nil {
                    
                    if self.postDataArray.isEmpty {
                        
                    }else {
                        cell.myPostImageView.imageURL = NSURL(string: (self.postDataArray[indexPath.row].photo)) as URL!
                    }
                }else {
                    if self.postDataUser.photo == "" {
                        
                    }else {
                        cell.myPostImageView.imageURL = NSURL(string: (self.postDataUser.photo)) as URL!
                    }
                    
                }
                return cell
            }else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostdataCell", for: indexPath) as! PostdataCell
                if myPost {
                    cell.shareBtn.setImage(#imageLiteral(resourceName: "DeleteIcon"), for: UIControlState())
                }
                if "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" == self.postDataArray[indexPath.row].user_id {
                    cell.report_editBtn.isHidden = true
                }else {
                    cell.report_editBtn.isHidden = true
                    cell.report_editBtn.setBackgroundImage(#imageLiteral(resourceName: "round-error-symbol"), for: UIControlState())
                }
                
                if postDataArray[indexPath.row].post_type == "text" {
                    cell.postDataView.isHidden = true
                    cell.postDataImage.isHidden = true
                    cell.postDescTop.constant = -(UIScreen.main.bounds.width)
                }else if postDataArray[indexPath.row].post_type == "photo"{
                    let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTaped))
                    tap.numberOfTapsRequired = 2
                    cell.contentView.addGestureRecognizer(tap)
                    cell.contentView.tag = indexPath.row
                    cell.postDataView.isHidden = true
                    cell.postDataImage.isHidden = false
                    cell.postDataImage.backgroundColor = UIColor.white
                    print(self.postDataArray[indexPath.row].attachements)
                    if self.postDataArray[indexPath.row].attachements.isEmpty {
                        cell.postDataView.isHidden = true
                        cell.postDataImage.isHidden = true
                        cell.postDescTop.constant = -(UIScreen.main.bounds.width-20)
                    }else {
                        cell.postDataView.isHidden = true
                        cell.postDataImage.isHidden = false
                        cell.postDescTop.constant = 10
                        cell.playImg.isHidden = true
                        let imageUrl = self.postDataArray[indexPath.row].attachements[0]
                        
                        if let url = NSURL(string:imageUrl["url"]!) {
                            cell.postDataImage.imageURL = url as URL!
                            
                        }
                        
                        
                    }
                }
                if self.postDataArray[indexPath.row].photo == "" {
                    
                }else {
                    cell.profileImageview.imageURL = NSURL(string: (self.postDataArray[indexPath.row].photo)) as URL!
                }
                cell.userNameLbl.isUserInteractionEnabled = true
                cell.commentBtn.addTarget(self,action:#selector(commentBtnClicked),for:.touchUpInside)
                cell.userNameLbl.tag = indexPath.row
                //
                cell.userNameLbl.text = postDataArray[indexPath.row].created_by
                cell.timeLbl.text  = postDataArray[indexPath.row].created_date
                cell.discriptionLbl.text = postDataArray[indexPath.row].post_description
               // cell.descTextView.text = postDataArray[indexPath.row].post_description
//                cell.descTextView.addAttribute(.mention, attribute: .textColor(.blue))
//                cell.descTextView.addAttribute(.hashTag, attribute: .textColor(.blue), values: ["URL": ""])
                
                
                cell.shareBtn.tag = indexPath.row
                
                cell.shareBtn.addTarget(self,action:#selector(shareBtnTaped),for:.touchUpInside)
                cell.report_editBtn.tag = indexPath.row
                cell.report_editBtn.addTarget(self,action:#selector(report_editBtnTaped),for:.touchUpInside)
                cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: .normal)
                cell.likeBtn.addTarget(self,action:#selector(likeBtnClicked),for:.touchUpInside)
                cell.likeBtn.tag = indexPath.row
                for i in postDataArray[indexPath.row].like {
                    if userid == i["user_id"] {
                        cell.likeBtn.setImage(UIImage(named:"LikeSelectedIcone"), for: UIControlState())
                        break
                    }else {
                        cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: UIControlState())
                    }
                }
                let dicAry:[[String:String]] = postDataArray[indexPath.row].comments
                
                cell.cmntLbl.isUserInteractionEnabled = true
                let tap2 = UITapGestureRecognizer(target: self, action: #selector(cmntLblTaped(_:)))
                cell.cmntLbl.addGestureRecognizer(tap2)
                cell.cmntLbl.text = "\(dicAry.count) comments"
                
                cell.cmntLbl.tag = indexPath.row
                //
                
                return cell

            }
        }else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostdataCell", for: indexPath) as! PostdataCell
            if myPost {
                cell.shareBtn.setImage(#imageLiteral(resourceName: "DeleteIcon"), for: UIControlState())
            }
            if "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" == self.postDataArray[indexPath.row-1].user_id {
                cell.report_editBtn.isHidden = true
            }else {
                cell.report_editBtn.isHidden = true
                cell.report_editBtn.setBackgroundImage(#imageLiteral(resourceName: "round-error-symbol"), for: UIControlState())
            }

            if postDataArray[indexPath.row-1].post_type == "text" {
                cell.postDataView.isHidden = true
                cell.postDataImage.isHidden = true
                cell.postDescTop.constant = -(UIScreen.main.bounds.width)
            }else if postDataArray[indexPath.row-1].post_type == "photo"{
                let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTaped))
                tap.numberOfTapsRequired = 2
                cell.contentView.addGestureRecognizer(tap)
                cell.contentView.tag = indexPath.row
                cell.postDataView.isHidden = true
                cell.postDataImage.isHidden = false
                cell.postDataImage.backgroundColor = UIColor.white
                print(self.postDataArray[indexPath.row-1].attachements)
                if self.postDataArray[indexPath.row-1].attachements.isEmpty {
                    cell.postDataView.isHidden = true
                    cell.postDataImage.isHidden = true
                    cell.postDescTop.constant = -(UIScreen.main.bounds.width-20)
                }else {
                    cell.postDataView.isHidden = true
                    cell.postDataImage.isHidden = false
                    cell.postDescTop.constant = 10
                    cell.playImg.isHidden = true
                    let imageUrl = self.postDataArray[indexPath.row - 1].attachements[0]
                    
                        if let url = NSURL(string:imageUrl["url"]!) {
                            cell.postDataImage.imageURL = url as URL!
                            
                        }
                        
                    
                }
            }
            if self.postDataArray[indexPath.row-1].photo == "" {
                
            }else {
                cell.profileImageview.imageURL = NSURL(string: (self.postDataArray[indexPath.row-1].photo)) as URL!
            }
            cell.userNameLbl.isUserInteractionEnabled = true
            cell.commentBtn.addTarget(self,action:#selector(commentBtnClicked),for:.touchUpInside)
            cell.userNameLbl.tag = indexPath.row - 1
            //
            cell.userNameLbl.text = postDataArray[indexPath.row-1].created_by
            cell.timeLbl.text  = postDataArray[indexPath.row-1].created_date
            cell.discriptionLbl.text = postDataArray[indexPath.row-1].post_description
//            cell.descTextView.text = postDataArray[indexPath.row-1].post_description
//            cell.descTextView.addAttribute(.mention, attribute: .textColor(.blue))
//            cell.descTextView.addAttribute(.hashTag, attribute: .textColor(.blue), values: ["URL": ""])
//            
           
            cell.shareBtn.tag = indexPath.row-1
            
            cell.shareBtn.addTarget(self,action:#selector(shareBtnTaped),for:.touchUpInside)
            cell.report_editBtn.tag = indexPath.row-1
            cell.report_editBtn.addTarget(self,action:#selector(report_editBtnTaped),for:.touchUpInside)
            cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: .normal)
            cell.likeBtn.addTarget(self,action:#selector(likeBtnClicked),for:.touchUpInside)
            cell.likeBtn.tag = indexPath.row
            for i in postDataArray[indexPath.row-1].like {
                if userid == i["user_id"] {
                    cell.likeBtn.setImage(UIImage(named:"LikeSelectedIcone"), for: UIControlState())
                    break
                }else {
                    cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: UIControlState())
                }
            }
            let dicAry:[[String:String]] = postDataArray[indexPath.row-1].comments
            
            cell.cmntLbl.isUserInteractionEnabled = true
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(cmntLblTaped(_:)))
            cell.cmntLbl.addGestureRecognizer(tap2)
            cell.cmntLbl.text = "\(dicAry.count) comments"
           
            cell.cmntLbl.tag = indexPath.row - 1
            //

            return cell
        }
        }else {
            let cell = self.grptableView.dequeueReusableCell(withIdentifier: Constant.GRPSTUDYVIEWID, for: indexPath)   as! ViewGroupStudyCell
            cell.lblDate.text = "Date : \(groupStudyArray[indexPath.row]["date"] as! String)"
            cell.lblTime.text = "Time : \(groupStudyArray[indexPath.row]["time"] as! String)"
            cell.lblTitle.text = groupStudyArray[indexPath.row]["title"] as? String
            cell.lblUserName.text = groupStudyArray[indexPath.row]["name"] as? String
            cell.askToJoinBtn.isHidden = true
            cell.askToJoinBtn.tag = indexPath.row
            cell.askToJoinBtn.addTarget(self,action:#selector(askToJoinClicked),for:.touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 0 {
            if indexPath.row == 0 {
                
            }else {
                if self.postDataArray[indexPath.row-1].post_type == "video" {
                    let cell = self.tableView.cellForRow(at: indexPath) as! PostdataCell
                    cell.playImg.isHidden = true
                    cell.player?.play()
                    self.videoIndex = indexPath
                    NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell.player!.currentItem)
                }else if self.postDataArray[indexPath.row-1].post_type == "photo" {
                    
                    
                }
            }
        }
        
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = .clear
        

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if tableView.tag == 0 {
            if indexPath.row == 0 {
                if "\(postDataUser.user_id!)" != "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)"{
                if postDataUser == nil{
                    return 280
                }else if "\(postDataUser.user_id!)" == "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" {
                        return UITableViewAutomaticDimension
                }else {
                    return 280
                }
                }else {
                    return   UITableViewAutomaticDimension
                }
            }else {
                return   UITableViewAutomaticDimension
            }
        }else {
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            if indexPath.row == 0 {
                if postDataUser == nil || "\(postDataUser.user_id!)" == "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" {
                    return 0
                }else {
                    return 120
                }

            }else {
                return   UITableViewAutomaticDimension
            }
        }else {
            return 200
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
            let Alert = UIAlertController(title: "", message: "Are you sure to delete this post?", preferredStyle: UIAlertControllerStyle.alert)
            
            Alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
                
                 self.deletePostApiCAll(postId:self.postDataArray[indexPath.row-1].post_id,index:indexPath)
            }))
            Alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                
                
            }))
            present(Alert, animated: true, completion: nil)
        }
    }
    //MARK:WEB SERVICES
    func postListAPICall(page:Int){
        
        var dictPostParameter = NSDictionary()
        if myPost {
            
            dictPostParameter = NSDictionary(dictionary: ["tag":Constant.POST_LIST,"school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","post_type":"","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","limit":"","page":"\(page)"])
        }else {
            if postDataUser == nil {
            dictPostParameter = NSDictionary(dictionary: ["tag":Constant.POST_LIST,"school_id":self.sSchoolid,"user_id":suserid,"post_type":"","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","limit":"","page":"\(page)"])
            }else{
            dictPostParameter = NSDictionary(dictionary: ["tag":Constant.POST_LIST,"school_id":postDataUser.school_id,"user_id":postDataUser.user_id,"post_type":"","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","limit":"","page":"\(page)"])
            }
        }
        
        print(dictPostParameter)
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams: dictPostParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
        //WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_POST, WSParams: dictPostParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictPostData = iData as! NSDictionary
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        print(iData ?? "e")
                        if let postDetail = iDictPostData.object(forKey: "post_list") as? NSDictionary {
                            if let record = postDetail.object(forKey: "records") as? NSArray{
                                self.postDataArray.removeAll()
                                for i in record {
                                    let postdataModel = SG_POST_DATA(fromDictionary: (i) as! [String : Any])
                                    self.postDataArray.append(postdataModel)
                                }
                            }
                        }
                        self.indicator.stopAnimating()
                        self.tableView.reloadData()
                        
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                        
                    }
                }
            }
            
        }
    }
    @objc  func report_editBtnTaped (sender:UIButton) {
       
            if "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" == self.postDataArray[sender.tag].user_id {
                Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "You can not report your own post.", iButtonTitle: "ok", iViewController: self)
            }else {
                let Alert = UIAlertController(title: "", message: "Are you sure to report for this post?", preferredStyle: UIAlertControllerStyle.alert)
                
                Alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
                    let index = IndexPath(item: sender.tag, section: 0)
                    self.reportPostApiCAll(postId:self.postDataArray[sender.tag].post_id,index:index)
                }))
                Alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                    
                    
                }))
                present(Alert, animated: true, completion: nil)
            }
        
    }
    func reportPostApiCAll(postId:String, index:IndexPath){
        /*
         user_id, school_id, token, post_id, report_abuse
         */
        let dictParameter = NSDictionary(dictionary: ["tag":"report_abuse","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","report_abuse":"1","post_id":postId,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        
        print(dictParameter)
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams: dictParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                print(iData ?? "e")
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        
                        
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
            }
        }
    }

    func groupStudyAPICall(){
        /*
         "tag":"my_group_study",
         "id":3,
         "token":"2076095124"
 */
        var dictPostParameter = NSDictionary()
        if postDataUser == nil {
            dictPostParameter = NSDictionary(dictionary:["tag":"my_group_study","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)"])
        }else {
            dictPostParameter = NSDictionary(dictionary: ["tag":"my_group_study","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","user_id":"\(postDataUser.user_id!)"])
        }
        
        print(dictPostParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_GROUPSTUDY, WSParams: dictPostParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictPostData = iData as! NSDictionary
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        //print(iData ?? "e")
                        if let grpDetail = iDictPostData.object(forKey: "gs_details") as? NSArray {
                            print(grpDetail)
                            for i in grpDetail{
                            self.groupStudyArray.append(i as! [String : Any])
                            }
                        }
                        self.groupStudyView.isHidden = false
                        self.grptableView.reloadData()
                        //self.grptableView.frame = CGRect(x: 40, y: self.groupStudyView.frame.origin.y, width: self.groupStudyView.frame.size.width, height: self.grptableView.contentSize.height)
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                    
                }
            }
            
        }
    }

    func deletePostApiCAll(postId:String, index:IndexPath){
       let dictParameter = NSDictionary(dictionary: ["tag":"delete_post","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","post_id":postId,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
    
    
        print(dictParameter)
    
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams: dictParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
    
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                print(iData)
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        
                        self.postDataArray.remove(at: index.row)
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
    
    
    func getStoryApiCall(){
        /*
         tag:get_stories
         school_id:2
         user_id:21
         token:RsvguEmaSNYAb7f8HqCeBTdOZaHxfajK
         */
        
        let dictParameter = NSDictionary(dictionary: ["tag":"get_stories","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        print(dictParameter)
        WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_CREAT_STORY, WSParams: dictParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictPostData = iData as! NSDictionary
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        print(iData ?? "e")
                        if let storyDetail = iDictPostData.object(forKey: "stories") as? NSArray {
                            
                            for i in storyDetail {
                                let storydataModel = StoryDataModal(fromDictionary: (i) as! [String : Any])
                                self.storyDataArray.append(storydataModel)
                            }
                            
                        }
                        
                    }else {
                        
                        
                    }
                }
                
            }
            
        }
        
    }

    
    
    //MARK:EVENTS
    @objc func shareBtnTaped(sender:UIButton){
        if myPost {
        let Alert = UIAlertController(title: "", message: "Are you sure to delete this post?", preferredStyle: UIAlertControllerStyle.alert)
        
        Alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            let index = IndexPath(item: sender.tag, section: 0)
            self.deletePostApiCAll(postId:self.postDataArray[sender.tag].post_id,index:index)
        }))
        Alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            
            
        }))
        present(Alert, animated: true, completion: nil)
        }else {
            let index = IndexPath(row: sender.tag, section: 0)
            print(index)
            //if postDataArray[sender.tag-1].post_type == "photo" {
            if postDataArray[sender.tag].user_id == "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" {
                Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "You can not share own post", iButtonTitle: "ok", iViewController: self)
            }else {
                //let cell = tableView.cellForRow(at: index) as! PostdataCell
                /*id:20
                 token:fJ8ykNLAFt9PO1lVBhvtAHgSnoKBMPnV
                 post_id:131
                 tag:share_post
                 school_id:2
                 shared_user_id:21*/
                let dictParameter = NSDictionary(dictionary: ["tag":"share_post","post_id":postDataArray[sender.tag].post_id,"school_id":postDataArray[sender.tag].school_id,
                                                              "shared_user_id":postDataArray[sender.tag].user_id,
                                                              "id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
                
                print(dictParameter)
                WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams: dictParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
                    
                    if iError != nil {
                        print(iError?.localizedDescription ?? "")
                    }else {
                        
                        if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                        {
                            if iIntSuccess == 1 {
                                Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"All"])
                            }else {
                                Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                            }
                        }
                    }
                }
            }

        }
    }
    @objc func doubleTaped(gesture: UITapGestureRecognizer){
        print("double tap")
        let image = gesture.view
        print(image?.tag ?? 0)
        self.likeServiceCall(tag: image!.tag)
    }

    @objc func likeBtnClicked(sender:UIButton){
        self.likeServiceCall(tag: sender.tag)
    }
    func likeServiceCall(tag:Int){
        print(tag)
        let likeIndexPath = IndexPath(row: tag, section: 0)
        let cell = self.tableView.cellForRow(at: likeIndexPath) as! PostdataCell
        
        var dictNotiParameter = NSDictionary()
        if (cell.likeBtn.imageView?.image == UIImage(named: "LIkeNormalIcone")){
            cell.likeBtn.setImage(UIImage(named:"LikeSelectedIcone"), for: UIControlState())
            
            dictNotiParameter = NSDictionary(dictionary: ["tag":"post_like","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_id":postDataArray[tag-1].post_id,"user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
            print(dictNotiParameter)
            WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_POST, WSParams: dictNotiParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                    {
                        if iIntSuccess == 1 {
                            //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                            self.postDataArray[tag-1].like.append(["name":"Super Super","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)"])
                        }else {
                            cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: UIControlState())
                            //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                        }
                    }
                    
                }
            }
            
            
        }else {
            cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: UIControlState())
            dictNotiParameter = NSDictionary(dictionary: ["tag":"post_unlike","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_id":postDataArray[tag-1].post_id,"user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
            print(dictNotiParameter)
            WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_POST, WSParams: dictNotiParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                    {
                        if iIntSuccess == 1 {
                            //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                            let ary:[[String:String]] = self.postDataArray[tag-1].like
                            for (_,i) in ary.enumerated(){
                                if self.userid == i["user_id"] {
                                    self.postDataArray[tag-1].like.removeAll()
                                    break
                                }
                            }
                            
                        }else {
                            cell.likeBtn.setImage(UIImage(named:"LikeSelectedIcone"), for: UIControlState())
                            //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                        }
                    }
                    
                }
            }
            
            
        }
    }
    
    @objc func commentBtnClicked(sender:UIButton)
    {
        self.cmntLblTag = sender.tag
        self.performSegue(withIdentifier: "Mypostcomment", sender: nil)
        
    }
    @objc func cmntLblTaped(_ sender:UITapGestureRecognizer) {
        let lbl = sender.view
        self.cmntLblTag = lbl!.tag
        self.performSegue(withIdentifier: "Mypostcomment", sender: nil)
    }

    @objc func askToJoinClicked(sender:UIButton){
        print(sender.tag)
        
    }
    @IBAction func sendBtnTaped(_ sender: Any) {
        self.performSegue(withIdentifier: "Profileshowchat", sender: nil)
    }
    @objc  func backBtnClicked() {
        //if postDataUser == nil {
            
            //Constant.appDelegate.createMenubar()
           
        //}else {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "start"), object: nil, userInfo: [:])
            _ = self.navigationController?.popViewController(animated: true)
        //}
        
    }

    @IBAction func addFavouriteBtn(_ sender: UIButton) {
        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"add_to_fav",
                                                           "id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)",
                                                           "user_id":"\(postDataUser.user_id!)",
                                                           "token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_USER, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                self.postDataUser.insight_user = "1"
                sender.backgroundColor = UIColor.lightGray
                sender.isUserInteractionEnabled = false
                //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
            }
        }

    }

    @IBAction func closeGrpStudyBtnTaped(_ sender: Any) {
        self.groupStudyView.isHidden = true
    }
    @IBAction func viewGroupStudyBtnTaped(_ sender: Any) {
        self.groupStudyAPICall()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Mypostcomment" {
            let nextVC = segue.destination as! SG_CommentVC
            nextVC.postData = postDataArray[cmntLblTag!]
        }
        if segue.identifier == "userClass" {
            let nextVC = segue.destination as! SG_UserClassVC
            nextVC.user_ID = postDataUser.user_id
        }
        
        /*if segue.identifier == "Profileshowchat" {
            let nextVC = segue.destination as! CC_UserChatVC
            nextVC.strChatUserName = self.postDataUser.created_by
            nextVC.intChatUserID = self.postDataUser.user_id
            nextVC.strUserPhotoURL = "\(self.postDataUser.photo!)"
            nextVC.strSchoolId = "\(self.postDataUser.school_id)"
            nextVC.strinsightId = "\(self.postDataUser.insight_user)"
            nextVC.myPost = true
        }*/

        
    }
    
    @IBAction func classBtnTaped(_ sender: Any) {
        self.performSegue(withIdentifier: "userClass", sender: nil)
    }
    @objc  func playerItemDidReachEnd(_ notification: Notification) {
        print(videoIndex)
        let cell = tableView.cellForRow(at: videoIndex) as! PostdataCell
        if cell.player != nil {
            cell.player!.seek(to: kCMTimeZero)
            cell.player!.play()
        }
    }

   /* @IBAction func btnStoryClicked(_ sender: Any) {
        
        for i in storyDataArray{
            if i.user_id == postDataUser.user_id {
                if i.user_stories.count > 0 {
                    if let urld = i.user_stories[0] as? [String:String]{
                        if let str:String = urld["file_name"] {
                            var newStory = [StoryDataModal]()
                            newStory.append(i)
                            let newVC = MyStoryImageVC(imageurl:str,index:0)
                            newVC.storyDataArray = newStory
                            newVC.myPost = false
                            _ = self.navigationController?.pushViewController(newVC, animated: true)
                        }
                    }
                }
            }
        }
        
    }*/
}
