//
//  SG_OnlyMyPostVC.swift
//  Student_GPA
//
//  Created by mac 2 on 08/06/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import Foundation
import XLPagerTabStrip
import AVKit
import AVFoundation
import MediaPlayer

class SG_OnlyMyPostVC:UITableViewController, IndicatorInfoProvider {
    
    let cellIdentifier = "postCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    var postDataArray = [SG_POST_DATA]()
    var indexofLbl:Int?
    var cmntLblTag:Int?
    let userid:String = "\(Constant.USER_DEFAULT.value(forKey:Constant.USER_ID)!)"
    var videoIndex = IndexPath()
    var postText:String = ""
    let indicator = UIActivityIndicatorView()
    var postPage:Int = 0
    var postEmpty = false
    var post_Type:String = ""
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        indicator.frame = CGRect(x: self.view.frame.width / 2 - 45, y: self.view.frame.height-120, width: 90, height: 90)
        indicator.color = UIColor.darkGray
    }
    
    
    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 140.0;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = true
        tableView.showsVerticalScrollIndicator = false
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorStyle = .singleLine
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
        //SG_CreatePostCell
        let postdataNib = UINib(nibName: Constant.POSTDATA_NIBNAME, bundle: nil)
        self.tableView.register(postdataNib, forCellReuseIdentifier: Constant.POSTDATA_CELLID)
        
        let myprofileNib = UINib(nibName: Constant.MYPROFILE_NIBNAME, bundle: nil)
        self.tableView.register(myprofileNib, forCellReuseIdentifier: Constant.MYPROFILE_CELLID)
        self.postListAPICall(page:0,postType:post_Type)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(_:)), name: NSNotification.Name(rawValue: "searchPost"), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    // handle notification
    func showNotification(_ notification: NSNotification) {
        
        if let str = notification.userInfo?["post"] as? String {
            self.postDataArray.removeAll()
            self.postPage = 0
            var postEmpty = false
            if str == "text"{
                self.post_Type = "text"
                self.postListAPICall(page:0,postType:"text")
                //self.postBtn.setImage(#imageLiteral(resourceName: "OnlytextWhite"), for: .normal)
            }else if str == "video"{
                self.post_Type = "video"
                self.postListAPICall(page:0,postType:"video")
                //self.postBtn.setImage(#imageLiteral(resourceName: "OnlyvideoWhite"), for: .normal)
            }else if str == "photo"{
                self.post_Type = "photo"
                self.postListAPICall(page:0,postType:"photo")
                //self.postBtn.setImage(#imageLiteral(resourceName: "OnlyphotoWhite"), for: .normal)
            }else {
                self.post_Type = ""
                self.postListAPICall(page:0,postType:"")
                //self.postBtn.setImage(#imageLiteral(resourceName: "Post"), for: .normal)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:TEXTFIELD(SEARCHBAR)
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.postText = textField.text!
        
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  postDataArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "MyprofileCell", for: indexPath) as! MyProfileCell
            if let profUrl:String = Constant.USER_DEFAULT.value(forKey: Constant.USER_PHOTO) as? String {
                //cell.profileImageView.imageURL = NSURL(string: (profUrl)) as URL!
            }
            cell.editBtn.tag = 11
            cell.editBtn.addTarget(self,action:#selector(myProfileBtnEvent),for:.touchUpInside)
            cell.classesBtn.tag = 12
            cell.classesBtn.addTarget(self,action:#selector(myProfileBtnEvent),for:.touchUpInside)
            cell.groupStudiesBtn.tag = 13
            cell.groupStudiesBtn.addTarget(self,action:#selector(myProfileBtnEvent),for:.touchUpInside)
            return cell
            
        }else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostdataCell", for: indexPath) as! PostdataCell
            cell.shareBtn.setImage(#imageLiteral(resourceName: "ShareNormal"), for: UIControlState())
            if postDataArray[indexPath.row-1].post_type == "text" {
                cell.postDataView.isHidden = true
               // cell.postDataImage.isHidden = true
                cell.postDescTop.constant = -320
            }else if postDataArray[indexPath.row-1].post_type == "photo"{
                cell.postDataView.isHidden = true
                //cell.postDataImage.isHidden = false
                //cell.postDataImage.backgroundColor = UIColor.white
                print(self.postDataArray[indexPath.row-1].attachements)
                if self.postDataArray[indexPath.row-1].attachements.isEmpty {
                    cell.postDataView.isHidden = true
                  //  cell.postDataImage.isHidden = true
                    cell.postDescTop.constant = -320
                }else {
                    cell.postDataView.isHidden = true
                    //cell.postDataImage.isHidden = false
                    cell.postDescTop.constant = 10
                    cell.playImg.isHidden = true
                    let imageUrl = self.postDataArray[indexPath.row-1].attachements[0]
                        //print(imageUrl["url"]!)
                        if let url = NSURL(string:imageUrl["url"]!) {
                      //      cell.postDataImage.imageURL = url as URL!
                            /*let request = NSURLRequest(url: url as URL)
                             NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                             (response,data,error) -> Void in
                             //print(response)
                             //print(error)
                             //print(data)
                             cell.postDataImage.contentMode = .scaleToFill
                             if let imageData = data as NSData? {
                             //print(imageData)
                             cell.postDataImage.image = UIImage(data: imageData as Data)
                             }
                             }*/
                        }
                        
                    
                }
            }else if postDataArray[indexPath.row-1].post_type == "video" {
                cell.postDataView.isHidden = false
//                cell.postDataImage.isHidden = true
//                cell.postDataImage.backgroundColor = UIColor.lightGray
                print(self.postDataArray[indexPath.row-1].attachements)
                if self.postDataArray[indexPath.row-1].attachements.isEmpty {
                    cell.postDataView.isHidden = true
                    //cell.postDataImage.isHidden = true
                    cell.postDescTop.constant = -320
                }else {
                    cell.postDescTop.constant = 10
                    cell.postDataView.isHidden = false
                    //cell.postDataImage.isHidden = true
                    let vdoUrl = self.postDataArray[indexPath.row-1].attachements[0]
                        cell.playImg.isHidden = false
                        print(vdoUrl["url"]!)
                        //if vdoUrl["file_type"] == "video/mp4" {
                        if let url = NSURL(string:vdoUrl["url"]!) {
                            
                            /*let asset: AVAsset = AVAsset(url: url as URL)
                             let imageGenerator = AVAssetImageGenerator(asset: asset)
                             imageGenerator.appliesPreferredTrackTransform = true
                             
                             do {
                             let cgImage: CGImage? = try? imageGenerator.copyCGImage(at: CMTimeMake(1,5), actualTime: nil)
                             if cgImage != nil {
                             cell.postDataImage.image = UIImage(cgImage: cgImage!)
                             }
                             
                             } catch let error {
                             print(error)
                             cell.postDataImage.image = #imageLiteral(resourceName: "User_profile")
                             }*/
                            //DispatchQueue.main.async {
                            
                            cell.player = AVPlayer(url: url as URL)
                            cell.playerController!.videoGravity =  AVLayerVideoGravityResizeAspectFill
                            
                            cell.playerController!.showsPlaybackControls = false
                            
                            cell.playerController!.player = cell.player!
                            
                            //cell.postDataView.addChildViewController(playerController!)
                            
                            
                            //player?.play()
                            //}
                        }
                        
                        //}
                    
                }
                
            }else {
                cell.postDataView.isHidden = false
                cell.postDescTop.constant = 10
            }
            if self.postDataArray[indexPath.row-1].photo == "" {
                
            }else {
                //cell.profileImageview.imageURL = NSURL(string: (self.postDataArray[indexPath.row-1].photo)) as URL!
            }
            cell.userNameLbl.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(userNameLblTaped(_:)))
            cell.userNameLbl.addGestureRecognizer(tap)
            cell.commentBtn.addTarget(self,action:#selector(commentBtnClicked),for:.touchUpInside)
            cell.commentBtn.tag = indexPath.row - 1
            cell.userNameLbl.tag = indexPath.row - 1
            //
            cell.userNameLbl.text = postDataArray[indexPath.row-1].created_by
            cell.timeLbl.text  = postDataArray[indexPath.row-1].created_date
            cell.discriptionLbl.text = postDataArray[indexPath.row-1].post_description
            cell.shareBtn.tag = indexPath.row-1
            cell.shareBtn.addTarget(self,action:#selector(shareBtnTaped),for:.touchUpInside)
            cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: .normal)
            cell.likeBtn.addTarget(self,action:#selector(likeBtnClicked),for:.touchUpInside)
            cell.likeBtn.tag = indexPath.row-1
            for i in postDataArray[indexPath.row-1].like {
                if userid == i["user_id"] {
                    cell.likeBtn.setImage(UIImage(named:"LikeSelectedIcone"), for: UIControlState())
                    break
                }else {
                    cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: UIControlState())
                }
            }
            let dicAry:[[String:String]] = postDataArray[indexPath.row-1].comments
            //if dicAry.count > 0 {
            cell.cmntLbl.isUserInteractionEnabled = true
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(cmntLblTaped(_:)))
            cell.cmntLbl.addGestureRecognizer(tap2)
            cell.cmntLbl.text = "\(dicAry.count) comments"
            //}else {
            // cell.cmntLbl.text = ""
            //}
            cell.cmntLbl.tag = indexPath.row - 1
            //
            return cell
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        
        if indexPath.row != 0 {
        }
        print(postDataArray.count)
        if indexPath.row == postDataArray.count{
            if !postEmpty {
                postPage = postPage + 1
                indicator.startAnimating()
                self.postListAPICall(page: postPage,postType:post_Type)
            }
        }
        //self.tableView.allowsSelection = false
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0 {
            
            return 250
            
        }else {
            return   UITableViewAutomaticDimension
        }
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return 250
            
        }else {
            return   UITableViewAutomaticDimension
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            
        }else {
            if self.postDataArray[indexPath.row-1].post_type == "video" {
                let cell = self.tableView.cellForRow(at: indexPath) as! PostdataCell
                cell.playImg.isHidden = true
                cell.player?.play()
                self.videoIndex = indexPath
                NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell.player!.currentItem)
                /*if let vdoUrl = self.postDataArray[indexPath.row-1].attachements[0] as? Dictionary {
                 let url:URL = URL(string:vdoUrl["url"]!)!
                 let newVC = SG_VideoVC(videoURL: url)
                 self.present(newVC, animated: true, completion: nil)
                 }*/
            }else if self.postDataArray[indexPath.row-1].post_type == "photo" {
                //let cell = tableView.cellForRow(at: indexPath) as! PostdataCell
                 //let imageUrl = self.postDataArray[indexPath.row-1].attachements[0]
                    //print(imageUrl["url"]!)
                    //let newVC = SG_PhotoVC(imageurl:imageUrl["url"]! )
                    //self.present(newVC, animated: true, completion: nil)
                    
                }
                //                    if let vdoUrl = self.postDataArray[indexPath.row-1].attachements[0] as? Dictionary {
                //                        let url:URL = URL(string:vdoUrl["url"]!)!
                //
                //                        let newVC = SG_PhotoVC(image: photo)
                //                        self.present(newVC, animated: true, completion: nil)
                //                    }
            
        }
        
        
        
    }
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    //MARK:WEB SERVICES
    func postListAPICall(page:Int,postType:String){
        
        let dictPostParameter = NSDictionary(dictionary: ["tag":Constant.POST_LIST,"school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","post_type":postType,"id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","limit":"","page":"\(page)"])
        
        print(dictPostParameter)
        
        //WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams: dictPostParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
        WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_POST, WSParams: dictPostParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
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
                                //self.postDataArray.removeAll()
                                for i in record {
                                    let postdataModel = SG_POST_DATA(fromDictionary: (i) as! [String : Any])
                                    self.postDataArray.append(postdataModel)
                                }
                            }
                        }
                        self.indicator.stopAnimating()
                        self.tableView.reloadData()
                        
                        
                    }else {
                        self.postEmpty = true
                        self.indicator.stopAnimating()
                        print(self.postPage)
                        if self.postDataArray.count == 0 {
                            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                        }
                        self.tableView.reloadData()
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

    
    func playerItemDidReachEnd(_ notification: Notification) {
        print(videoIndex)
        let cell = tableView.cellForRow(at: videoIndex) as! PostdataCell
        if cell.player != nil {
            cell.player!.seek(to: kCMTimeZero)
            cell.player!.play()
        }
    }
    //MARK:EVENTS
    func myProfileBtnEvent(sender:UIButton){
        if sender.tag == 11 {
            self.performSegue(withIdentifier: "myprofileEdit", sender: nil)
        }
        if sender.tag == 12 {
            self.performSegue(withIdentifier: "myprofileClasses", sender: nil)
        }
        if sender.tag == 13 {
            self.performSegue(withIdentifier: "myprofileGroupStudies", sender: nil)
        }
    }
    func userNameLblTaped(_ sender:UITapGestureRecognizer) {
        //let vcc = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "MypostVC") as! SG_MypostVC
        //self.navigationController?.pushViewController(vcc, animated: true)
        let lbl = sender.view
        print(lbl?.tag)
        indexofLbl = lbl!.tag
        self.performSegue(withIdentifier: "UserpostVC", sender:nil)
    }
    func cmntLblTaped(_ sender:UITapGestureRecognizer) {
        let lbl = sender.view
        self.cmntLblTag = lbl!.tag
        self.performSegue(withIdentifier: "Maincommentview", sender: nil)
    }
    
    func shareBtnTaped(sender:UIButton){
        print(sender.tag)
        let index = IndexPath(row: sender.tag, section: 0)
        print(index)
        
        let Alert = UIAlertController(title: "", message: "Are you sure to delete this post?", preferredStyle: UIAlertControllerStyle.alert)
        
        Alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            let index = IndexPath(item: sender.tag, section: 0)
            self.deletePostApiCAll(postId:self.postDataArray[sender.tag].post_id,index:index)
        }))
        Alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            
            
        }))
        present(Alert, animated: true, completion: nil)
        
    }
    
    
    func likeBtnClicked(sender:UIButton){
        /*tag:post_like
         user_id:2
         post_id:1
         school_id:1
         token:2076095124*/
        var dictNotiParameter = NSDictionary()
        if (sender.imageView?.image == UIImage(named: "LIkeNormalIcone")){
            sender.setImage(UIImage(named:"LikeSelectedIcone"), for: UIControlState())
            
            dictNotiParameter = NSDictionary(dictionary: ["tag":"post_like","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_id":postDataArray[sender.tag].post_id,"user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
            print(dictNotiParameter)
            WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_POST, WSParams: dictNotiParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                    {
                        if iIntSuccess == 1 {
                            //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                            self.postDataArray[sender.tag].like.append(["name":"Super Super","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)"])
                        }else {
                            sender.setImage(UIImage(named:"LIkeNormalIcone"), for: UIControlState())
                            //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                        }
                    }
                    
                }
            }
            
            
        }else {
            sender.setImage(UIImage(named:"LIkeNormalIcone"), for: UIControlState())
            dictNotiParameter = NSDictionary(dictionary: ["tag":"post_unlike","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_id":postDataArray[sender.tag].post_id,"user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
            print(dictNotiParameter)
            WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_POST, WSParams: dictNotiParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                    {
                        if iIntSuccess == 1 {
                            //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                            let ary:[[String:String]] = self.postDataArray[sender.tag].like
                            for (key,i) in ary.enumerated(){
                                if self.userid == i["user_id"] {
                                    self.postDataArray[sender.tag].like.removeAll()
                                    break
                                }
                            }
                            
                        }else {
                            sender.setImage(UIImage(named:"LikeSelectedIcone"), for: UIControlState())
                            //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                        }
                    }
                    
                }
            }
            
            
        }
    }
    func commentBtnClicked(sender:UIButton)
    {
        self.cmntLblTag = sender.tag
        self.performSegue(withIdentifier: "Maincommentview", sender: nil)
        
    }
    
}
