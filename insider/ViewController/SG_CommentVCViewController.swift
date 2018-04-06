//
//  SG_CommentVCViewController.swift
//  Student_GPA
//
//  Created by mac 2 on 22/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

//AddVideoDelegate,AddPhotoDelegate,
class SG_CommentVCViewController: UIViewController,UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var tblView: UIView!
    
    @IBOutlet weak var collectionViewForImages: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var viewComment: UIView!
    
    
    @IBOutlet weak var viewAddPhoto: UIView!
    
    @IBOutlet weak var txtViewComment: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addpersonView: UIView!
    
    @IBOutlet weak var addPhotoView: UIView!
    
    var userList = [UserList]()
    var searchuserList = [UserList]()
    var userID = [String]()
    var aryImages = [[String:Any]]()
    var imageNumber:Int = 0
    var addPerson:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.txtViewComment.layer.borderColor = UIColor.init(hexString: "cbcbcb")?.cgColor
        self.txtViewComment.layer.borderWidth = 1.0
        
        collectionViewForImages.delegate = self
        self.tblView.isHidden = true
        
        addpersonView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(addpersonViewTaped(_:)))
        addpersonView.addGestureRecognizer(tap)
        searchTxtFld.setLeftViewIcon(UIImage(named:"SearchIconBlack")!)
        searchTxtFld.placeHolderCustomized("Search", strHexColor: "000000")
        searchTxtFld.delegate = self
        searchTxtFld.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: UIControlEvents.editingChanged)
        //Looks for single or multiple taps.
        //let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //view.addGestureRecognizer(tap1)
        
        self.addPhotoView.layer.borderWidth = 1
        self.addPhotoView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.red
        self.navigationController?.view.backgroundColor = UIColor.red
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        
    }
    
    func addVideo(_ data: Any) {
        if let img = data as? UIImage {
            let dic:[String:UIImage] = ["photo":img]
            aryImages.append(dic)
            
            
        }else if let url = data as? URL {
            let dic:[String:URL] = ["video":url]
            aryImages.append(dic)
        }
        collectionViewForImages.reloadData()
    }
    func addPhoto(_ data: Any){
        if let img = data as? UIImage {
            aryImages.removeAll()
            let dic:[String:UIImage] = ["photo":img]
            aryImages.append(dic)
        }
        collectionViewForImages.reloadData()
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
        
        let searchedArray = userList.filter { (UserList) -> Bool in
            return UserList.name.range(of: str, options: .caseInsensitive) != nil
        }
            print(searchedArray)
        self.searchuserList = searchedArray
        
        if str == "" {
            self.searchuserList = self.userList
        }else if searchuserList.isEmpty{
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "No contact found", iButtonTitle: "ok", iViewController: self)
        }
        self.tableView.reloadData()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Comment"{
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Comment"
        }
    }
        
    //MARK:COLLECTIONVIEW
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.aryImages.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath as IndexPath) as! ImageCollectionCell
        collCell.layer.borderWidth = 1.0
        collCell.layer.borderColor = UIColor(hexString: "acacac")?.cgColor
        collCell.layer.masksToBounds = true
        if let img = self.aryImages[indexPath.row]["photo"] as? UIImage {
            //collCell.imageSelected.image = img
        }else if let url = self.aryImages[indexPath.row]["video"] as? URL{
            let videoURL: URL = url
            var player: AVPlayer?
            var playerController : AVPlayerViewController?
            player = AVPlayer(url: videoURL)
            playerController = AVPlayerViewController()
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = collCell.frame
            //playerController!.showsPlaybackControls = false
             //playerController!.view.frame = collCell.frame
            //playerController!.player = player!
            collCell.layer.addSublayer(playerLayer)
            
            player?.play()
            //self.view.addSubview(playerController!.view)
           
            
        }
        collCell.contentView.bringSubview(toFront: collCell.deleteBtn)
        collCell.deleteBtn.tag = indexPath.row
        collCell.deleteBtn.addTarget(self, action:#selector(deleteFile), for: .touchUpInside)
        return collCell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 95.0, height: 95.0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let url = self.aryImages[indexPath.row]["video"] as? URL {
                let newVC = SG_VideoVC(videoURL: url)
                self.present(newVC, animated: true, completion: nil)
        }else if let img = self.aryImages[indexPath.row]["photo"] as? UIImage{
//            let newVC = SG_ImageVC(imageurl: img)
//            newVC.delegate = self
//            self.present(newVC, animated: true, completion: nil)
            
        }

    }
    
    //MARK:TABLEVIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchuserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "addPerson", for: indexPath) as!  SearchCell
        cell.addpersonNameLbl.text = searchuserList[indexPath.row].name
        print(userID)
        for i in userID {
            if i == searchuserList[indexPath.row].id {
                cell.setSelected(true, animated: true)
                cell.selectImgView.image = #imageLiteral(resourceName: "ContactSelected")
                break
            }else {
                cell.setSelected(false, animated: true)
                cell.selectImgView.image = #imageLiteral(resourceName: "ContactNormal")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("s==",indexPath.row)
        userID.append(searchuserList[indexPath.row].id!)
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        cell.selectImgView.image = #imageLiteral(resourceName: "ContactSelected")
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //print("d==",indexPath.row)
        //print("id====",userID)
        if let index = userID.index(of:searchuserList[indexPath.row].id!) {
            userID.remove(at: index)
        }
        let cell = tableView.cellForRow(at: indexPath) as! SearchCell
        cell.selectImgView.image = #imageLiteral(resourceName: "ContactNormal")
        
        //print("userID",userID)
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

    
    //MARK : WEB SERVICES
    func createPostServiceCall(){
        var idString = ""
        for i in userID{
            idString = idString+"\(i),"
        }
        print(idString)
        
        
        if aryImages.count > 0 {
            if let img = self.aryImages[0]["photo"] as? UIImage {
                let newImage = self.rotateCameraImageToProperOrientation(imageSource : img, maxResolution : 1000.0)
                if self.txtViewComment.text == "Comment" {
                    self.txtViewComment.text = ""
                }
//                let dictLoginParameter = NSDictionary()
                let dictLoginParameter = NSDictionary(dictionary: ["tag":Constant.POST_CRETAE,"created_by":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_description":Utility.trim(str: self.txtViewComment.text),"post_type":"photo","tagged_person":"\(idString)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","iv_count":"1"])
                print(dictLoginParameter)
                WebServiceManager.callImageUploadWithParameterUsingMultipart(WSUrl: Constant.WS_POST, WSParams: dictLoginParameter, isLoader: true, iImgName:"post_files_1",iImage:newImage) { (iData, iError) in
                    self.txtViewComment.text = "Comment"
                    if iError != nil {
                    print(iError?.localizedDescription ?? "")
                    }else {
                        let iDictUserData = iData as! NSDictionary
                        
                        let alert1 = UIAlertController(title: "", message: "\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , preferredStyle: .alert)
                            alert1.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"All"])
                                self.navigationController!.popViewController(animated: true)
                        
                            })
                        self.present(alert1, animated: true, completion: nil)
                }
            }
            }else if let vdo = self.aryImages[0]["video"] as? URL {
                if self.txtViewComment.text == "Comment" {
                    self.txtViewComment.text = ""
                }
                let dictLoginParameter = NSDictionary(dictionary: ["tag":Constant.POST_CRETAE,"created_by":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_description":self.txtViewComment.text,"post_type":"video","tagged_person":"\(idString)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","iv_count":"1"])
                print(dictLoginParameter)
                print(vdo)
                WebServiceManager.callVideoUploadWithParameterUsingMultipart(WSUrl: Constant.WS_POST, WSParams: dictLoginParameter, isLoader: true, iVdoName: "post_files_1", iVideo:vdo) { (iData, iError) in
                    self.txtViewComment.text = "Comment"
                    if iError != nil {
                        print(iError?.localizedDescription ?? "")
                    }else {
                        let iDictUserData = iData as! NSDictionary
                        
                        let alert1 = UIAlertController(title: "", message: "\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , preferredStyle: .alert)
                        alert1.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"All"])
                            self.navigationController!.popViewController(animated: true)
                            
                        })
                        self.present(alert1, animated: true, completion: nil)
                    }
                }

            }else {
                return
            }
            
            
        }else if Utility.trim(str: txtViewComment.text) == "Comment" || Utility.trim(str: txtViewComment.text) == ""{
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter comment" ,iButtonTitle: "ok", iViewController: self)
            return
        }else {
            let dictLoginParameter = NSDictionary(dictionary: ["tag":Constant.POST_CRETAE,"created_by":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_description":self.txtViewComment.text,"post_type":"text","tagged_person":"\(idString)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","iv_count":"0"])
            
            WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_POST, WSParams: dictLoginParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    let iDictUserData = iData as! NSDictionary
                    self.txtViewComment.text = "Comment"
                    let alert1 = UIAlertController(title: "", message: "\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , preferredStyle: .alert)
                    alert1.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"All"])
                        self.navigationController!.popViewController(animated: true)
                        
                    })
                    self.present(alert1, animated: true, completion: nil)
                    
                }
            }

        }
    
    }
    //MARK : EVENTS
    func deleteFile(sender:UIButton){
        
        self.aryImages.remove(at: sender.tag)
        self.collectionViewForImages.reloadData()
    }
    @IBAction func postBtnClicked(_ sender: Any) {
        createPostServiceCall()
    }
    @IBAction func btn_Back_clicked(_ sender: Any) {
        Constant.appDelegate.createMenubar()
    }
    
    func addpersonViewTaped(_ sender:UITapGestureRecognizer) {
        
        if addPerson {
             self.tblView.isHidden = false
        }else {
            
            let dictPostParameter = NSDictionary(dictionary: ["tag":"search_user","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
            print(dictPostParameter)
            WebServiceManager.callParameterUsingMultipartImageUploadWithOut(WSUrl: Constant.WS_USER, WSParams: dictPostParameter, isLoader: true, iImgName:#imageLiteral(resourceName: "LikeSelectedIcone")) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber{
                        if iIntSuccess == 1 {
                            if let users = iData?.object(forKey:"user_list") as? NSArray{
                                self.userList.removeAll()
                                for i in users{
                                    print(i)
                                    let user = UserList(id: (i as! NSDictionary).value(forKey: "id") as! String,first_name:(i as! NSDictionary).value(forKey: "first_name") as! String,last_name:(i as! NSDictionary).value(forKey: "last_name") as! String,name:(i as! NSDictionary).value(forKey: "name") as! String,photo:(i as! NSDictionary).value(forKey: "photo") as! String)
                                    
                                    self.userList.append(user)

                                }
                            }
                            self.searchuserList = self.userList
                            self.tableView.reloadData()
                            self.addPerson = true
                            
                        }else {
                        
                            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                        }
                        self.tblView.isHidden = false
                    }
                }
            }
        }
    }
        ///////////
    
    // MARK:ImagePicker Delegate methods
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let dic:[String:UIImage] = ["photo":image]
            aryImages.append(dic)
            collectionViewForImages.reloadData()
            imageNumber = imageNumber + 1
            //let editImageVC = self.storyboard?.instantiateViewController(withIdentifier: "EditImageViewController") as! EditImageViewController
            // editImageVC.passedImage = image
            
            //  let files = DMSUtility().getFilesListFromDocDir()
            let fileManager = FileManager.default
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            //  let format = DateFormatter()
            let currentFileName = "\("cnphoto\(imageNumber)").jpeg"//sank
            print("currentfilename===\(currentFileName)")
            
            // let currentFileName = "sank123.jpeg"
            let filePathtoWrite = "\(paths)/\(currentFileName)"
            print("while creating file:\(filePathtoWrite)")
            let imageData = UIImageJPEGRepresentation((info[UIImagePickerControllerOriginalImage] as? UIImage)!, 1.0)
            
            fileManager.createFile(atPath: filePathtoWrite as String, contents: imageData, attributes: nil)
            
            // self.navigationController?.pushViewController(editImageVC, animated: true)
            self.dismiss(animated: true, completion: nil)
//            let newVC = SG_ImageVC(imageurl: image)
//            newVC.delegate = self
//            self.present(newVC, animated: true, completion: nil)
        }else {
            if let videoURL = info["UIImagePickerControllerReferenceURL"] as? NSURL {
            print(videoURL)
            let asset : AVURLAsset = AVURLAsset(url: videoURL as URL) as AVURLAsset
            let duration : CMTime = asset.duration
            print(CMTimeGetSeconds(duration))
            if CMTimeGetSeconds(duration) < 30.0 {
                let dic:[String:URL] = ["video":videoURL as URL]
                aryImages.append(dic)
                collectionViewForImages.reloadData()
            }
            self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_AddFile_clicked(_ sender: Any) {
        
        self.view.endEditing(true)
        if aryImages.count >= 1 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "You can select only one media", iButtonTitle: "ok", iViewController: self)
        }else {
            showActionsheetOption(sender as! UIButton)
        }
        
    }
    @IBAction func showActionsheetOption(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Insider", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            print("User click Camera button")
            
            /*let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)*/
            //let newVC = SG_ImageVC(imageurl: #imageLiteral(resourceName: "SG_Background"))
            //newVC.delegate = self
//            let vc = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "CameraVC") as! SG_CameraVC
//            vc.delegate = self
//            self.navigationController?.pushViewController(vc,animated: true)
            //let VC1 = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "filtercamareVC") as! ViewController
            //self.navigationController?.pushViewController(VC1, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            print("User click Gallery button")
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .photoLibrary
            
            imagePickerController.delegate = self
            imagePickerController.mediaTypes = ["public.image", "public.movie"]
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "DISMISS", style: UIAlertActionStyle.destructive, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }

    
    @IBAction func closeBtnTaped(_ sender: Any) {
        self.tblView.isHidden = true
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


}




