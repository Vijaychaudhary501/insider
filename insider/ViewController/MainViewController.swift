//
//  ViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import XLPagerTabStrip
import AVKit
import AVFoundation
import MediaPlayer

class notificataiontblCell:UITableViewCell{
    @IBOutlet var notificationTitle:UILabel!
}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var CTableView: UITableView!
    @IBOutlet weak var subtableView: UITableView!
    @IBOutlet weak var CTView :UIView!
    @IBOutlet weak var collView :UIView!
    @IBOutlet weak var collectionView :UICollectionView!
    @IBOutlet weak var collViewHeight :NSLayoutConstraint!
    @IBOutlet weak var postBtn :UIButton!
    @IBOutlet weak var notificationBtn :UIButton!
    @IBOutlet weak var messageBtn :UIButton!
    var postDataArray = [SG_POST_DATA]()
    var notificationDataArray = [SG_NOTIFICATION_DATA]()
    var indexofLbl:Int?
    var cmntLblTag:Int?
    let userid:String = "\(Constant.USER_DEFAULT.value(forKey:Constant.USER_ID)!)"
    var videoIndex = IndexPath()
    var postText:String = ""
    let indicator = UIActivityIndicatorView()
    var postPage:Int = 0
    var postEmpty = false
    var post_Type:String = ""
    var isselectedIndex = 0
    var msgBtnSelected = 0
    let searchBar = UISearchBar()
    var mainContens = ["data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10", "data11", "data12", "data13", "data14", "data15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CTView.isHidden = true
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        CTableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        isselectedIndex = 0
        searchBar.sizeToFit()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        self.tableView.registerCellNib(PostdataCell.self)
        let cretepostNib = UINib(nibName: "SG_CreatePostCell", bundle: nil)
        self.tableView.register(cretepostNib, forCellReuseIdentifier: "CreatePostCell")
        
        let notificationtNib = UINib(nibName: "NotificationCell", bundle: nil)
        self.CTableView.register(notificationtNib, forCellReuseIdentifier: "NotificationCell")
        let tap = UITapGestureRecognizer(target: self, action: #selector(postdoubleTapped(gesture:)))
        tap.numberOfTapsRequired = 2
        postBtn.addGestureRecognizer(tap)
        //self.navigationController?.navigationBar.isTranslucent = false
        //UINavigationBar./TintColor = UIColor.red
        
        NotificationCenter.default.addObserver(self, selector: #selector(showNotification), name: NSNotification.Name(rawValue: "searchPost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchPost), name: NSNotification.Name(rawValue: "searchFilter"), object: nil)
        
    }
    @objc func  postdoubleTapped(gesture: UITapGestureRecognizer){
        
        self.performSegue(withIdentifier: "PostfilterVC", sender: nil)
    }
    @IBAction func postImage(_ sender:UIButton){
        //self.performSegue(withIdentifier: "FAImagepickerView", sender: nil)
        let test = self.storyboard?.instantiateViewController(withIdentifier: "FAImageCropperSB")as! FAImageCropperVC
        self.navigationController?.pushViewController(test, animated: true)
    }
    func searchPost(_ notification: NSNotification) {
        var dictPostParameter = NSDictionary()
        if let str = notification.userInfo?["search"] as? String {
            dictPostParameter = NSDictionary(dictionary: ["school_id":Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!,"id":Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!,"token":Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!,"keyword":searchBar.text as Any,"search_by":str])
            WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_SEARCH, WSParams: dictPostParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    let iDictPostData = iData as! NSDictionary
                    if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                    {
                        if iIntSuccess == 1 {
                            if let postDetail = iDictPostData.object(forKey: "search_result") as? NSDictionary {
                                if let record = postDetail.object(forKey: "records") as? NSArray{
                                    self.postDataArray.removeAll()
                                    for i in record {
                                        let postdataModel = SG_POST_DATA(fromDictionary: (i) as! [String : Any])
                                        self.postDataArray.append(postdataModel)
                                    }
                                }
                            }
                            self.tableView.reloadData()
                        }else {
                            let Alert = UIAlertController(title: "", message: iData?.object(forKey: Constant.MESSAGE) as? String, preferredStyle: UIAlertControllerStyle.alert)
                            
                            Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                            }))
                            
                            self.present(Alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    
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
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.postText = textField.text!
        
    }
    
    @IBAction func postBtnClicked(_ sender:UIButton){
        msgBtnSelected = 0
        self.postListAPICall(page:0,postType:post_Type)
        self.tableView.isHidden = false
        self.CTView.isHidden =  true
        postBtn.backgroundColor = UIColor.init(hex: "FF8400")
        notificationBtn.backgroundColor = UIColor.init(hex: "CBCBCB")
        messageBtn.backgroundColor = UIColor.init(hex: "CBCBCB")
        tableView.reloadData()
    }
    @IBAction func notificationBtnClicked(_ sender:UIButton){
        msgBtnSelected = 0
        self.tableView.isHidden = true
        self.CTView.isHidden =  false
        postBtn.backgroundColor = UIColor.init(hex: "CBCBCB")
        notificationBtn.backgroundColor = UIColor.init(hex: "FF8400")
        messageBtn.backgroundColor = UIColor.init(hex: "CBCBCB")
        CTableView.reloadData()
    }
    @IBAction func messageBtnClicked(_ sender:UIButton){
        msgBtnSelected = 1
        self.CTView.isHidden =  true
        self.tableView.isHidden = false
        self.postListAPICall(page:0,postType:post_Type)
        postBtn.backgroundColor = UIColor.init(hex: "CBCBCB")
        notificationBtn.backgroundColor = UIColor.init(hex: "CBCBCB")
        messageBtn.backgroundColor = UIColor.init(hex: "FF8400")
        tableView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.backgroundColor = UIColor.red
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        self.navigationController?.navigationBar.tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]

        self.setNavigationBarItem()
        self.postListAPICall(page:0,postType:post_Type)
        self.getnotification()
    }
    func postListAPICall(page:Int,postType:String){
//        let dict = [String:Any]()
//        dict["tag"] = "post_list"
//        dict[""]
        var dictPostParameter = NSDictionary()
        dictPostParameter = NSDictionary(dictionary: ["tag":"post_list","school_id":Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!,"user_id":Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!,"post_type":postType,"id":Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!,"token":Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!,"limit":"","page":page])
        
       let tempdect = ["tag" : "post_list",
                        "school_id" : Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID),
                        "id" : Constant.USER_DEFAULT.value(forKey: Constant.USER_ID),
                        "token":Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN),
                        "page":page,
                        "post_type":postType,
                        "limit":""
                        ]
        let param = msgBtnSelected == 1 ? (dictPostParameter as NSDictionary) as! [String : Any?] : tempdect
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams:param as NSDictionary, WSMethod: .post, isLoader: true) { (iData, iError) in
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
                        self.tableView.reloadData()
                        
                    }else {
                        let Alert = UIAlertController(title: "", message: iData?.object(forKey: Constant.MESSAGE) as? String, preferredStyle: UIAlertControllerStyle.alert)
                        
                        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        self.present(Alert, animated: true, completion: nil)
                    }
                }
            }
        }
        //http://imakedevelopment.com/ios/api/post.php
        
    }
    func getnotification(){
        
        let tempdect = ["tag" : "get_notification_list",
                        "school_id" : Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID),
                        "id" : Constant.USER_DEFAULT.value(forKey: Constant.USER_ID),
                        "token":Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN),
        ]
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_NOTIFICATION, WSParams: tempdect as NSDictionary, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictNotiData = iData as! NSDictionary
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        print(iData ?? "e")
                        if let notiDetail = iDictNotiData.object(forKey: "data") as? NSDictionary {
                            if let record = notiDetail.object(forKey: "records") as? NSArray{
                                //self.notificationDataArray.removeAll()
                                for i in record {
                                    let notidataModel = SG_NOTIFICATION_DATA(fromDictionary: (i) as! [String : Any])
                                    self.notificationDataArray.append(notidataModel)
                                }
                            }
                        }
                        self.CTableView.reloadData()
                        
                    }else {
                        let Alert = UIAlertController(title: "", message: iData?.object(forKey: Constant.MESSAGE) as? String, preferredStyle: UIAlertControllerStyle.alert)
                        
                        Alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            
                        }))
                        
                        self.present(Alert, animated: true, completion: nil)
                    }
                }
            }
        }
        //http://imakedevelopment.com/ios/api/post.php
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return DataTableViewCell.height()
        return CTView.isHidden == false ? 120:msgBtnSelected == 1 ? 280 : UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {

        }else {
            self.cmntLblTag = indexPath.row-1
            if self.postDataArray[indexPath.row-1].post_type == "video" {
                let cell = self.tableView.cellForRow(at: indexPath) as! PostdataCell
                cell.playImg.isHidden = true
                cell.player?.play()
                self.videoIndex = indexPath
                NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell.player!.currentItem)
            }
            else {
                self.performSegue(withIdentifier: "UserpostVC", sender:nil)
            }
        }
    }
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        print(videoIndex)
        let cell = tableView.cellForRow(at: videoIndex) as! PostdataCell
        if cell.player != nil {
            cell.player!.seek(to: kCMTimeZero)
            cell.player!.play()
        }
    }
}

extension MainViewController : UITableViewDataSource ,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,AddPhotoDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return CTView.isHidden == true ?  :
        return msgBtnSelected == 1 ? CTView.isHidden == true ? postDataArray.count+1:notificationDataArray.count:postDataArray.count+1
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if CTView.isHidden == false {
            
            let cell = self.CTableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
            if notificationDataArray.count>indexPath.row{
            if self.notificationDataArray[indexPath.row].photo == "" {
                
            }else {
                 cell.notificaionImage.imageURL = NSURL(string: (self.notificationDataArray[indexPath.row].photo)) as URL!
            }
            cell.userNameLbl.text = notificationDataArray[indexPath.row].notification_text
            cell.timeLbl.textColor = UIColor.init(hexString: "21409a")
            cell.timeLbl.text = notificationDataArray[indexPath.row].created_date
            }
            return cell
        }
        else{
        if indexPath.row == 0 {
            if msgBtnSelected == 1{
                    let cell = self.tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)   as! SG_CreatePostCell
                    let postDataUser = postDataArray[indexPath.row]
                    cell.myPostImageView.setCircleView(width: cell.myPostImageView.bounds.width)
                    cell.sendMsgBtn.layer.cornerRadius = 10.0
                    cell.sendMsgBtn.layer.masksToBounds = true
                    
                    if postDataUser.insight_user == "1" {
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
                        if postDataUser.photo == "" {
                            
                        }else {
                            cell.myPostImageView.imageURL = NSURL(string: (postDataUser.photo)) as URL!
                        }
                        
                    }
                    return cell
            }
            else{
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "CreatePostCell", for: indexPath) as! SG_CreatePostCell
                if let profUrl:String = Constant.USER_DEFAULT.value(forKey: Constant.USER_PHOTO) as? String {
                    cell.profileImage.imageURL = URL.init(string: profUrl)
                    //cell.profileImage.imageURL = NSURL(string: (profUrl)) as URL!
                }
                cell.txtfldSaySomething.tag = 1
                cell.txtfldSaySomething.delegate = self as! UITextFieldDelegate
                cell.txtfldSaySomething.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)
                cell.sendBtn.addTarget(self,action:#selector(sendBtnTaped),for:.touchUpInside)
                
                cell.selectPhotoBtn.addTarget(self,action:#selector(selectPhotoBtnTaped),for:.touchUpInside)
                cell.locationBtn.isHidden = true
                return cell
            }
            
            
        }else{
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostdataCell") as! PostdataCell
            cell.report_editBtn.isHidden = true
            if postDataArray[indexPath.row-1].post_type == "text" {
                cell.postDataView.isHidden = true
                cell.postDataImage.isHidden = true
                cell.cellViewHeight.constant = 0
                //cell.postDescTop.constant = -(UIScreen.main.bounds.width)
            }else if postDataArray[indexPath.row-1].post_type == "photo"{
                cell.cellViewHeight.constant = 320
                let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTaped(gesture:)))
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
                    cell.cellViewHeight.constant = 0
                   // cell.postDescTop.constant = -(UIScreen.main.bounds.width-20)
                }else {
                    cell.postDataView.isHidden = true
                    cell.postDataImage.isHidden = false
                    cell.cellViewHeight.constant = 320
                    //cell.postDescTop.constant = 10
                    cell.playImg.isHidden = true
                    let imageUrl = self.postDataArray[indexPath.row-1].attachements[0]
                    
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
            cell.userNameLbl.tag = indexPath.row
            //
            cell.userNameLbl.text = postDataArray[indexPath.row-1].created_by
            cell.timeLbl.text  = postDataArray[indexPath.row-1].created_date
            cell.discriptionLbl.text = postDataArray[indexPath.row-1].post_description
            cell.shareBtn.tag = indexPath.row
            cell.commentBtn.tag = indexPath.row
            
            cell.shareBtn.addTarget(self,action:#selector(shareBtnTaped),for:.touchUpInside)
        
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
            
            cell.cmntLbl.tag = indexPath.row
            //
            
            return cell
        }
        }
        }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return CTView.isHidden == false ? 120:msgBtnSelected == 1 ?120 : UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row != 0 {
        }
        print(postDataArray.count)
        if indexPath.row == postDataArray.count{
            if !postEmpty {
//                postPage = postPage + 1
//                self.postListAPICall(page: postPage,postType:post_Type)
            }
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
    @objc func cmntLblTaped(_ sender:UITapGestureRecognizer) {
        let lbl = sender.view
        self.cmntLblTag = lbl!.tag
        self.performSegue(withIdentifier: "Maincommentview", sender: nil)
    }
    
    @objc func shareBtnTaped(sender:UIButton){
        print(sender.tag)
        let index = IndexPath(row: sender.tag, section: 0)
        print(index)
        
        
        if postDataArray[sender.tag].user_id == "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "You can not share own post", iButtonTitle: "ok", iViewController: self)
        }else {
            let Alert = UIAlertController(title: "", message: "Are you sure to share this post?", preferredStyle: UIAlertControllerStyle.alert)
            
            Alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                let dictParameter = NSDictionary(dictionary: ["tag":"share_post","post_id":self.postDataArray[sender.tag].post_id,"school_id":self.postDataArray[sender.tag].school_id,
                                                              "shared_user_id":self.postDataArray[sender.tag].user_id,
                                                              "id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
                
                print(dictParameter)
                WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams: dictParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
                    
                    if iError != nil {
                        print(iError?.localizedDescription ?? "")
                    }else {
                        let iDictData = iData as! NSDictionary
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
                
            }))
            Alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                
                
            }))
            present(Alert, animated: true, completion: nil)
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
    
    @objc  func selectPhotoBtnTaped(sender:UIButton){
        self.view.endEditing(true)
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        let rightButton: UIBarButtonItem = UIBarButtonItem(title:"Send" , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.imageRightBtn))
        imagePickerController.navigationItem.leftBarButtonItem = rightButton
        self.present(imagePickerController, animated: true, completion: nil)
        
    }
    @IBAction func btnSeting(_ sender:UIButton){
        self.performSegue(withIdentifier: "myprofileEdit", sender: nil)
    }
    @IBAction func myClasses(_ sender:UIButton){
        self.performSegue(withIdentifier: "myprofileClasses", sender: nil)
    }
    @objc func sendBtnTaped(sender:UIButton){
        if Utility.trim(str: postText) != "" {
            let dictLoginParameter = NSDictionary(dictionary: ["tag":Constant.POST_CRETAE,"created_by":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_description":self.postText,"post_type":"text","tagged_person":"","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","iv_count":"0"])
            
            WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_POST, WSParams: dictLoginParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    let iDictUserData = iData as! NSDictionary
                    if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                    {
                        if iIntSuccess == 1 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"All"])
                        }else {
                            let alert1 = UIAlertController(title: "", message: "\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , preferredStyle: .alert)
                            alert1.addAction(UIAlertAction(title: "Ok", style: .default) { action in})
                            self.present(alert1, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
        }
        
    }
    
    @objc func commentBtnClicked(sender:UIButton)
    {
        self.cmntLblTag = sender.tag
        self.performSegue(withIdentifier: "Maincommentview", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "Maincommentview"{
            let  commentVC = segue.destination as! SG_CommentVC
            commentVC.postData = postDataArray[cmntLblTag!-1]
        }
        if segue.identifier == "UserpostVC" {
            let  commentVC = segue.destination as! SG_MypostVC
            commentVC.myPost = "\(postDataArray[cmntLblTag!].user_id)" == "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)"
            commentVC.postDataUser = postDataArray[cmntLblTag!]
        }
    }
    
    
    
    
    // MARK:ImagePicker Delegate methods
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let fileManager = FileManager.default
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            //  let format = DateFormatter()
            let currentFileName = "\("cnphoto\(1)").jpeg"//sank
            print("currentfilename===\(currentFileName)")
            
            // let currentFileName = "sank123.jpeg"
            let filePathtoWrite = "\(paths)/\(currentFileName)"
            print("while creating file:\(filePathtoWrite)")
            let imageData = UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!, 1.0)
            
            fileManager.createFile(atPath: filePathtoWrite as String, contents: imageData, attributes: nil)
            
            
            let newVC = SG_SelectPhotoVC(imageurl: image)
            newVC.delegate = self
            self.navigationController?.pushViewController(newVC, animated: true)
            self.dismiss(animated: true, completion: nil)
            
            
        }else {
            if let videoURL = info["UIImagePickerControllerReferenceURL"] as? NSURL {
                print(videoURL)
                do {
                    let attr = try? FileManager.default.attributesOfFileSystem(forPath: "\(videoURL)")
                    if let attr = attr {
                        let size: AnyObject? = attr[FileAttributeKey.size] as AnyObject?
                        print("File size = \(size)")
                    }
                }catch {
                    return
                }
                let asset : AVURLAsset = AVURLAsset(url: videoURL as URL) as AVURLAsset
                let duration : CMTime = asset.duration
                print(CMTimeGetSeconds(duration))
                if CMTimeGetSeconds(duration) < 30.0 {
                    
                }
                self.dismiss(animated: true, completion: nil)
                self.addVideo(videoURL)
                
            }
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func imageRightBtn() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
        
        let imgRef = imageSource.cgImage;
        
        let width = CGFloat(imgRef!.width);
        let height = CGFloat(imgRef!.height);
        
        //var bounds = CGRectMake(0,0,width,height)
        var bounds = CGRect(x:0,y:0,width:width,height:height)
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            
            //scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            print(scaleRatio)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        // let imageSize = CGSizeMake(CGFloat(imgRef!.width), CGFloat(imgRef!.height))
        let imageSize = CGSize(width: CGFloat(imgRef!.width), height: CGFloat(imgRef!.height))
        
        switch(imageSource.imageOrientation) {
        case .up :
            transform = CGAffineTransform.identity
            
        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            
        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height);
            transform = transform.rotated(by: CGFloat(M_PI));
            
        case .downMirrored :
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height);
            transform = transform.scaledBy(x: 1.0, y: -1.0);
            
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width);
            transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0);
            
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0);
            
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0);
            transform = transform.rotated(by: CGFloat(M_PI) / 2.0);
            
        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            transform = transform.rotated(by: CGFloat(M_PI) / 2.0);
            
        default : ()
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        
        if orient == .right || orient == .left {
            context!.scaleBy(x: -scaleRatio, y: scaleRatio);
            context!.translateBy(x: -height, y: 0);
        } else {
            context!.scaleBy(x: scaleRatio, y: -scaleRatio);
            context!.translateBy(x: 0, y: -height);
        }
        
        context!.concatenate(transform);
        
        // CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRect(x:0,y:0,width:width,height:height), imgRef);
        
        context?.draw(imageSource.cgImage!, in: CGRect(x:0,y:0,width:width,height:height))
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return imageCopy!
    }
    
    func addVideo(_ data: Any) {
        if let url = data as? URL {
            
            let dictLoginParameter = NSDictionary(dictionary: ["tag":Constant.POST_CRETAE,"created_by":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_description":"","post_type":"video","tagged_person":"","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","iv_count":"1"])
            print(dictLoginParameter)
            print(url)
            WebServiceManager.callVideoUploadWithParameterUsingMultipart(WSUrl: Constant.WS_POST, WSParams: dictLoginParameter, isLoader: true, iVdoName: "post_files_1", iVideo:url) { (iData, iError) in
                
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    let iDictUserData = iData as! NSDictionary
                    if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                    {
                        if iIntSuccess == 1 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"All"])
                        }else {
                            let alert1 = UIAlertController(title: "", message: "\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , preferredStyle: .alert)
                            alert1.addAction(UIAlertAction(title: "Ok", style: .default) { action in})
                            self.present(alert1, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
            
        }
        
    }
    func addPhoto(_ data: Any){
        if let img = data as? UIImage {
            let newImage = self.rotateCameraImageToProperOrientation(imageSource : img, maxResolution : 1000.0)
            
            let dictLoginParameter = NSDictionary(dictionary: ["tag":Constant.POST_CRETAE,"created_by":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_description":"\(self.postText)","post_type":"photo","tagged_person":"","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","iv_count":"1"])
            print(dictLoginParameter)
            WebServiceManager.callImageUploadWithParameterUsingMultipart(WSUrl: Constant.WS_POST, WSParams: dictLoginParameter, isLoader: true, iImgName:"post_files_",iImage:img) { (iData, iError) in
                
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    let iDictUserData = iData as! NSDictionary
                    if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                    {
                        if iIntSuccess == 1 {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"All"])
                        }else {
                            let alert1 = UIAlertController(title: "", message: "\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , preferredStyle: .alert)
                            alert1.addAction(UIAlertAction(title: "Ok", style: .default) { action in})
                            self.present(alert1, animated: true, completion: nil)
                        }
                    }
                }
            }
            
        }
        
    }
}
extension MainViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}

extension MainViewController:UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: .whitespaces).count>0{
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchFilter"), object: nil, userInfo: ["search":"Keyword"])
        }
    }
    
    
    
}
