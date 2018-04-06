//
//  EditPostVC.swift
//  Student_GPA
//
//  Created by mac 2 on 26/06/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class EditPostVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate {

    @IBOutlet weak var subtableView: UITableView!
    @IBOutlet weak var subView: UIView!
  //  @IBOutlet weak var imageView: RemoteImageView!
    
    @IBOutlet weak var subViewWidth: NSLayoutConstraint!
    @IBOutlet weak var posttextView: UITextView!
    //@IBOutlet weak var postTextBottom: NSLayoutConstraint!
    
    var postData:SG_POST_DATA!
    
    var favouriteList = [String]()
    var favListId = [String]()
    var favListschulid = [String]()
    var postUser:Bool = true
    var searchFavlist = [String]()
    var postText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EDIT POST"
        self.subtableView.delegate = self
        self.subtableView.dataSource = self
        self.subtableView.isHidden = true
        self.posttextView.layer.borderWidth = 1.0
        self.posttextView.layer.borderColor = UIColor.lightGray.cgColor
        self.posttextView.layer.masksToBounds = false
        self.posttextView.delegate = self
        self.subView.layer.borderWidth = 1.0
        self.subView.layer.borderColor = UIColor.lightGray.cgColor
        self.subView.layer.masksToBounds = false
        
        if postData.post_type == "text" {
            subView.isHidden = true
            subViewWidth.constant = 0.0
            //postTextBottom.constant = -(UIScreen.main.bounds.width)
            posttextView.text = postData.post_description
        }else if postData.post_type == "photo"{
            
            print(self.postData.attachements)
            if self.postData.attachements.isEmpty {
                
            }else {
                
                let imageUrl = self.postData.attachements[0]
                //print(imageUrl["url"]!)
                if let url = NSURL(string:imageUrl["url"]!) {
                    //imageView.imageURL = url as URL!
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
            posttextView.text = postData.post_description
        }else if postData.post_type == "video" {
            //imageView.isHidden = true
            print(self.postData.attachements)
            if self.postData.attachements.isEmpty {
                
            }else {
                var player: AVPlayer?
                var playerController : AVPlayerViewController?
                playerController = AVPlayerViewController()
               subView.addSubview(playerController!.view)
                //playerController!.view.backgroundColor = .white
                playerController!.view.frame = CGRect(x:0, y: 0, width: subView.bounds.width, height: subView.bounds.height)

                let vdoUrl = self.postData.attachements[0]
                
                print(vdoUrl["url"]!)
                //if vdoUrl["file_type"] == "video/mp4" {
                if let url = NSURL(string:vdoUrl["url"]!) {
                    
                    player = AVPlayer(url: url as URL)
                    playerController!.videoGravity =  AVLayerVideoGravityResizeAspectFill
                    
                    playerController!.showsPlaybackControls = false
                    
                    playerController!.player = player!
                
                    player?.play()
                    
                }
                
                               
            }
        }
        getFavouriteListServiceCall()
        self.postText = self.posttextView.text
        let rightButton: UIBarButtonItem = UIBarButtonItem(title:"Save" , style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.toggleRigh))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if postData.post_type == "text" {
            subView.isHidden = true
            subViewWidth.constant = 0.0
            //postTextBottom.constant = -(UIScreen.main.bounds.width)
        }
        
        if postData.post_description == "" {
            posttextView.text = "Add post..."
        }
        self.posttextView.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.view.backgroundColor = UIColor.red
        Utility.sharedInstance().setstatusbarColor()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillHide(_ notification: Notification) {
            //self.subtableView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toggleRigh() {
        /*
         tag:update_post
         post_id:1
         updated_by:21
         school_id:2
         post_description:Test 03/05/2017 #testhash #my #@saa #123 #my12
         token:QzUJzJJ90vw4hEdhquc5Ttf7a0UxJkAq
 */
        if posttextView.text == "Add post..." {
            posttextView.text = ""
        }
        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"update_post","post_id":postData.post_id,"school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_description":posttextView.text,"updated_by":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_POST, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                       // Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
//                       Constant.appDelegate.createMenubar()
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add post..." {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Add post..."
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text?.characters.count)! >= 1 {
            
            if textView.text?.characters.last! == "@" {
                self.subtableView.isHidden = false
                
                //self.subtableView.frame = CGRect(x:0, y: 160, width: textView.bounds.width, height: 120)
            }else {
                if textView.text.lowercased().characters.contains("@"){
                    
                }else {
                self.subtableView.isHidden = true
                }
            }
            if let comma = textView.text?.components(separatedBy: "@").last! {
                print(comma)
                if !self.subtableView.isHidden {
                    let searchedArray = favouriteList.filter { (string) -> Bool in
                        return string.range(of: comma, options: .caseInsensitive) != nil
                    }
                    print(searchedArray)
                    
                    if searchedArray == [] {
                        self.searchFavlist = self.favouriteList
                        self.subtableView.reloadData()
                    }else {
                        self.searchFavlist = searchedArray
                        self.subtableView.reloadData()
                    }
                    if comma.characters.count >= 1 {
                        if comma.characters.last! == " " {
                            self.subtableView.isHidden = true
                        }
                    }
                }
            }
            self.postText = textView.text!
        }
        
        

    }
    //MARK:TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchFavlist.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.subtableView.dequeueReusableCell(withIdentifier: "sayCell", for: indexPath)
            print(searchFavlist)
            cell.textLabel?.text = searchFavlist[indexPath.row]
            cell.textLabel?.textColor = UIColor.blue
            return cell
        
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
       
            return 60
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
                    return 60
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.postText = postText + self.searchFavlist[indexPath.row]
            //let path = IndexPath(row: 0, section: 0)
            //self.tableView.reloadRows(at: [path], with: .top)
            //self.tableView.reloadData()
        
            posttextView.text = postText
        
        self.subtableView.isHidden = true
        
        
    }


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
                    self.favouriteList.removeAll()
                    if iIntSuccess == 1 {
                        print(iData ?? "e")
                        if let details = iDictNotiData.object(forKey: "favorite_list") as? [[String:String]] {
                            for i in details{
                                
                                self.favouriteList.append(i["favorite_name"]!)
                                
                            }
                        }
                        self.searchFavlist = self.favouriteList
                        self.subtableView.reloadData()
                    }else {
                        //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
            }
            
        }
    }


}
