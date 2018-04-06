//
//  SG_CommentVC.swift
//  Student_GPA
//
//  Created by mac 2 on 23/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer
import IQKeyboardManagerSwift

class SG_CommentVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbarBottom: NSLayoutConstraint!
    @IBOutlet weak var textviewHeight: NSLayoutConstraint!
    @IBOutlet weak var placeholderText: UILabel!
    @IBOutlet weak var cmntTextView: UITextView!
    
    var lastTextViewHeight:CGFloat = 0.0
    
    var postData:SG_POST_DATA!
    var tap:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "COMMENTS"
        let postdataNib = UINib(nibName: "PostdataCell", bundle: nil)
        self.tableView.register(postdataNib, forCellReuseIdentifier: "PostdataCell")
        let commentNib = UINib(nibName: "CommentCell", bundle: nil)
        self.tableView.register(commentNib, forCellReuseIdentifier: "CommentCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        print(postData)
        cmntTextView.layer.borderColor = UIColor(hexString: "808080")?.cgColor
        cmntTextView.layer.borderWidth = 1.0;
        cmntTextView.delegate = self
        
        //IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Send"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        keyboardHeightRegisterNotifications()
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = false
        
        //print(postData.comments)
        
    }
    //Calls this function when the tap is recognized.
     func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.tap = true
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.backgroundColor = UIColor.red
        Utility.sharedInstance().setstatusbarColor()
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let iIndexPath = IndexPath(row:  self.postData.comments.count, section: 0)
        self.tableView.scrollToRow(at: iIndexPath, at: .bottom, animated: true)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:TEXTVIEW
    /*func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add your comment" {
        textView.text = ""
            //IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Done"
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.characters.count > 0 {
            //IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Send"
        }else {
            //IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = "Done"
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Add your comment"
            
        }
    }*/
    //MARK:TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postData.comments.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(self.postData.insight_user)
        print(self.postData.comments)
        if indexPath.row == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostdataCell", for: indexPath) as! PostdataCell
            cell.cellViewHeight.constant = 0
            cell.report_editBtn.isHidden = true
            //cell.cmntLblHeight.constant = 0
            if postData.post_type == "text" {
                cell.postDataView.isHidden = true
                //cell.postDataImage.isHidden = true
                cell.postDescTop.constant = -320
            }else if postData.post_type == "photo"{
                cell.postDataView.isHidden = true
//                cell.postDataImage.isHidden = false
//                cell.postDataImage.backgroundColor = UIColor.white
                print(self.postData.attachements)
                if self.postData.attachements.isEmpty {
//                    cell.postDataView.isHidden = true
//                    cell.postDataImage.isHidden = true
//                    cell.postDescTop.constant = -320
                }else {
                    cell.postDataView.isHidden = true
//                    cell.postDataImage.isHidden = false
                    cell.postDescTop.constant = 10
                    cell.playImg.isHidden = true
                    let imageUrl = self.postData.attachements[0]
                        //print(imageUrl["url"]!)
                        if let url = NSURL(string:imageUrl["url"]!) {
//                            cell.postDataImage.imageURL = url as URL!
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
            }else {
                cell.postDataView.isHidden = false
                cell.postDescTop.constant = 10
            }
            if self.postData.photo == "" {
                
            }else {
//                cell.profileImageview.imageURL = NSURL(string: (self.postData.photo)) as URL!
            }
            cell.userNameLbl.isUserInteractionEnabled = true
            //let tap = UITapGestureRecognizer(target: self, action: #selector(userNameLblTaped(_:)))
            //cell.userNameLbl.addGestureRecognizer(tap)
            //cell.commentBtn.addTarget(self,action:#selector(commentBtnClicked),for:.touchUpInside)
            cell.commentBtn.isHidden = true
            //cell.commentBtn.tag = indexPath.row - 1
            //cell.userNameLbl.tag = indexPath.row - 1
            //
            cell.userNameLbl.text = postData.created_by
            cell.timeLbl.text  = postData.created_date
            cell.discriptionLbl.text = postData.post_description
//            cell.descTextView.text = postData.post_description
//
//            cell.descTextView.addAttribute(.mention, attribute: .textColor(.blue))
//            cell.descTextView.addAttribute(.hashTag, attribute: .textColor(.blue), values: ["URL": ""])
            //cell.setCellText(postData.post_description)
            cell.shareBtn.isHidden = true
            cell.likeBtn.isHidden = true
            //cell.shareBtn.tag = indexPath.row
            //cell.shareBtn.addTarget(self,action:#selector(shareBtnTaped),for:.touchUpInside)
            //cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: .normal)
            //cell.likeBtn.addTarget(self,action:#selector(likeBtnClicked),for:.touchUpInside)
            //cell.likeBtn.tag = indexPath.row-1
            /*for i in postDataArray[indexPath.row-1].like {
                if userid == i["user_id"] {
                    cell.likeBtn.setImage(UIImage(named:"LikeSelectedIcone"), for: UIControlState())
                    break
                }else {
                    cell.likeBtn.setImage(UIImage(named:"LIkeNormalIcone"), for: UIControlState())
                }
            }*/
            //let dicAry:[[String:String]] = postData.comments
            //if dicAry.count > 0 {
            //cell.cmntLbl.isUserInteractionEnabled = true
            //let tap2 = UITapGestureRecognizer(target: self, action: #selector(CmntBtnTaped(_:)))
            //cell.cmntLbl.addGestureRecognizer(tap2)
            //cell.cmntLbl.text = "\(dicAry.count) comments"
            //}else {
            // cell.cmntLbl.text = ""
            //}
            cell.cmntLbl.isHidden = true
            cell.cmntLbl.tag = indexPath.row - 1
            //
            return cell
        }else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
            if self.postData.comments[indexPath.row-1]["photo"] == "" {
            
            }else {
//                cell.userProfImage.imageURL = NSURL(string: (self.postData.comments[indexPath.row-1]["photo"])!) as URL!
            }
            cell.commentLbl.text = self.postData.comments[indexPath.row-1]["comment_by"]
            cell.userName.text = self.postData.comments[indexPath.row-1]["comment"]
            cell.timeLbl.text = self.postData.comments[indexPath.row-1]["created_date"]
            cell.cmntBtn.tag = indexPath.row-1
            cell.cmntBtn.addTarget(self, action: #selector(btnCmntTaped(_:)), for: .touchUpInside)
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if self.postData.post_type == "video" {
                let cell = self.tableView.cellForRow(at: indexPath) as! PostdataCell
                cell.playImg.isHidden = true
                cell.player?.play()
                
                NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell.player!.currentItem)
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0 {
            return   UITableViewAutomaticDimension 
        }else {
            return   UITableViewAutomaticDimension

        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return   UITableViewAutomaticDimension
        }else {
            return   UITableViewAutomaticDimension
            
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        if indexPath.row == 0 {
            return false
        }else {
        if "\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)" == self.postData.comments[indexPath.row-1]["createdby"] {
            
            return true
        }else {
            return false
        }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let Alert = UIAlertController(title: "", message: "Are you sure to delete this comment?", preferredStyle: UIAlertControllerStyle.alert)
            
            Alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
               self.deletePostApiCAll(commentId:self.postData.comments[indexPath.row-1]["comment_id"]!,postId:self.postData.post_id,index:indexPath)
                
            }))
            Alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                
                
            }))
            present(Alert, animated: true, completion: nil)
        }
    }

    func btnCmntTaped(_ sender:UIButton){
        /*[["comment_id": "23", "comment": "Congrats 🎈 😊", "comment_by": "Maria", "photo": "http://ec2-52-15-252-77.us-east-2.compute.amazonaws.com/insidr/uploads/1504720542_6_post_files.jpeg", "createdby": "6", "created_date": "13 hours ago", "comment_insight_user": "1", "comment_type": "text", "school_id": "1"], ["comment_id": "24", "comment": "Pandjev lasenp zou! 🤓😼🤦🏾‍♂️", "comment_by": "Junior", "photo": "http://ec2-52-15-252-77.us-east-2.compute.amazonaws.com/insidr/uploads/1504626074_20_post_files.jpeg", "createdby": "20", "created_date": "13 hours ago", "comment_insight_user": "0", "comment_type": "text", "school_id": "1"]]
        [["url": "http://ec2-52-15-252-77.us-east-2.compute.amazonaws.com/insidr/uploads/1504797741_post_39_post_files.jpeg", "file_type": "image/jpeg"]]*/
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MypostVC") as! SG_MypostVC
        nextVC.title = self.postData.comments[sender.tag]["comment_by"]
        nextVC.myPost = false
        
        nextVC.suserid = self.postData.comments[sender.tag]["createdby"]!
        nextVC.sSchoolid = self.postData.comments[sender.tag]["school_id"]!
        let dataAry = ["attachements":[],"comments":[],"created_by":self.postData.comments[sender.tag]["createdby"]!,"created_date":"48 minutes ago","like":[],"photo":self.postData.comments[sender.tag]["photo"]!,"post_description":"Hiii","post_id":"460","post_type":"text","school_id":self.postData.comments[sender.tag]["school_id"]!,"tagged":[],"user_id":self.postData.comments[sender.tag]["createdby"]!,"insight_user":self.postData.comments[sender.tag]["comment_insight_user"]!] as [String : Any]
        let postdataModel = SG_POST_DATA(fromDictionary: (dataAry))
        nextVC.postDataUser = postdataModel
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    //MARK:WEB SERVICES
    func deletePostApiCAll(commentId:String,postId:String, index:IndexPath){
        let dictParameter = NSDictionary(dictionary: ["tag":"delete_comment","post_id":postId,"user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","comment_id":commentId,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        
        print(dictParameter)
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams: dictParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                print(iData ?? "nhi")
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        
                            self.postData.comments.remove(at: index.row-1)
                        
                        //self.tableView.deleteRows(at: [index], with: .fade)
                        self.tableView.reloadData()
                        //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
            }
        }
    }

    // MARK:Events
    

    @IBAction func sendBtn(_ sender: Any) {
        cmntTextView.endEditing(true)
        
        // clear the text
        
        // and manually trigger the delegate method
        self.textViewDidChange(cmntTextView)
        self.sendCommentService()
    }
        @IBAction func CmntBtnTaped(_ sender: Any) {
        self.sendCommentService()
    }
    func sendCommentService() {
        if Utility.trim(str: cmntTextView.text) == "" {
             Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please Add your comment", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"comment_create",
                                                           "created_by":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","post_id":postData.post_id!,"comment_description":Utility.trim(str: self.cmntTextView.text!),"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
//"comment_id":"\(iDictUserData.object(forKey:"comment_id") as! String)",
                        let dic = NSDictionary(dictionary: ["comment":self.cmntTextView.text!,"comment_by":"\(Constant.USER_DEFAULT.value(forKey: "firstName")!)","comment_type":"text","created_date":"1 second ago","createdby":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","photo":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_PHOTO)!)","school_id": "\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","comment_insight_user": "1"])
                        self.postData.comments.append(dic as! [String : String])
                        self.cmntTextView.text = ""
                        self.placeholderText.isHidden = false
                        self.cmntTextView.resignFirstResponder()
                        //self.constraintTextHeight.constant =  51
                        // self.tblVwChat.reloadData()
                        print(self.postData.comments.count)
                        let indexpath = IndexPath(row:  self.postData.comments.count, section: 0)
                        self.tableView.insertRows(at: [indexpath], with: .bottom)
                        self.tableView.scrollToRow(at: indexpath, at: .bottom, animated: true)
                       
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "comment_refresh"), object: nil, userInfo: ["comment":"refresh"])
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }

        
    }

   /* func keyboardWillHide(_ notification:Notification)
    {
        if !tap {
            if cmntTextView.text == "" || cmntTextView.text == "Add your comment" {
        
            }else {
                self.sendCommentService()
            }
        }else {
            tap = false
        }
    }*/
    
    func playerItemDidReachEnd(_ notification: Notification) {
    let videoIndex = IndexPath(item: 0, section: 0)
    let cell = tableView.cellForRow(at: videoIndex) as! PostdataCell
    if cell.player != nil {
    cell.player!.seek(to: kCMTimeZero)
    cell.player!.play()
    }
    }
   
    


// MARK: - Keyboard helper methods

// all this just to move the keyboard up and down.

    
    /// register keyboard notifications to shift the scrollview content insets
    func keyboardHeightRegisterNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// just pass true or false if you're shifting the keyboard up or down
    func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    /// consolidate the keyboard movement logic into one method, and just pass a boolean for up or down.
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        // some implementations out there use -1 and 1 to move it up or down.
        // debugging is a little easier if you use -1 and 0 instead.
        toolbarBottom.constant = getKeyboardHeight(notification) * (show ? 1 : 0)
        // normally, the constraint change is updated immediately.
        // by simply added UIView.animateWithDuration along with a layoutIfNeeded(),
        // the constraint change will happen in the animation.
        // the animation settings below sort of match the keyboard animation
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: UIViewAnimationOptions(),
                       animations: {
                        // animate the constraint change
                        self.view.layoutIfNeeded()
        },
                       completion: nil
        )
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat{
        // == userInfo || {}
        let userInfo = notification.userInfo ?? [:]
        // CGRect wrapped in a NSValue
        // Make sure you use UIKeyboardFrameEndUserInfoKey, NOT UIKeyboardFrameBeginUserInfoKey
        // "End" is good.  "Begin" is bad.
        // To test, switch keyboards and make sure the heights are correct.
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        return keyboardFrame.height
    }
    

    
    // increase the height of the textview as the user types
    func textViewDidChange(_ textView: UITextView){
        // hide placeholder text
        placeholderText.isHidden = !textView.text.isEmpty
        // create a hypothetical tall box that contains the text.
        // then shrink down the height based on the content.
        let newSize:CGSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: 1600.0))
        // remember that new height
        let newHeight = newSize.height
        // change the height constraint only if it's different.
        // otherwise, it get set on every single character the user types.
        if lastTextViewHeight != newHeight {
            lastTextViewHeight = newHeight
            // the 7.0 is to account for the top of the text getting scrolled up slightly
            // to account for a potential new line
            //textviewHeight.constant = newSize.height + 7.0
        }
    }
    
       
}

