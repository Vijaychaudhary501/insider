//
//  SG_CreateProfileVC.swift
//  Student_GPA
//
//  Created by mac 2 on 14/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_CreateProfileVC: UITableViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate {

    
    @IBOutlet var tblView: UITableView!
    
    @IBOutlet weak var txtFild_Firstname: UITextField!
    
    @IBOutlet weak var txtFld_Lastname: UITextField!
    
    @IBOutlet weak var yourmajorLbl: UILabel!
    
    @IBOutlet weak var txtMajor: UITextField!
    @IBOutlet weak var yearLbl: UILabel!
    
    @IBOutlet weak var schoolLbl: UILabel!
    
    @IBOutlet weak var txtCampus: UITextField!
    @IBOutlet weak var userProfileImgview: UIImageView!
    
    let picker = UIImagePickerController()
    
    var majorDic = [String:String]()
    
    lazy var majorID = String()
    
    var schoolDic = [String:String]()
    lazy var schoolID = String()
    
    var defaultTableViewInset:UIEdgeInsets?
    var index:Int?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CREATE PROFILE"
        
        self.tblView.backgroundColor = .clear
        let backgroundImage = UIImage(named: "CreateProfileBG")
        let imageView = UIImageView(image: backgroundImage)
        self.tblView.backgroundView = imageView
        self.tblView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.picker.delegate = self
        
        //Setup TextField
        self.txtFild_Firstname.placeHolderCustomized("First Name*", strHexColor: "ffffff")
        self.txtFild_Firstname.delegate = self
        self.txtFld_Lastname.placeHolderCustomized("Last Name*", strHexColor: "ffffff")
        self.txtFld_Lastname.delegate = self
        self.txtMajor.placeHolderCustomized("Your Major*", strHexColor: "ffffff")
        self.txtMajor.delegate = self
        self.txtCampus.placeHolderCustomized("Campus*", strHexColor: "ffffff")
        self.txtCampus.delegate = self
        self.userProfileImgview.layer.cornerRadius = 65
        self.userProfileImgview.layer.masksToBounds = true
        
        // Transperent NavigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        //Looks for single or multiple taps.
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.majorServiceCall()
        //self.schoolLocationgetServiceCall()
        
        self.defaultTableViewInset = self.tblView.contentInset
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : TABLEVIEW
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        if indexPath.row == 0 || indexPath.row == 6 {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*if indexPath.row == 3 {
            let values = Array(majorDic.keys) as [String]
            if values.count <= 0 {
                Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Record not found.", iButtonTitle: "OK", iViewController: self)
                return
            }else {
                PickerView().show(title: "Your Major", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: values, selected:nil) { (value) -> Void in
                    self.yourmajorLbl.text = value
                    self.majorID = self.majorDic[value]!
                    print(self.majorID)
                }
            }

        }
        
        if indexPath.row == 4 {
            PickerView().show(title: "Year", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: ["Senior","Junior","Freshman","Sophmore","Grade Student"], selected:nil) { (value) -> Void in
                self.yearLbl.text = value
            }
        }*/
    }
    
    
    //MARK : WEB SERVICECALL
    func majorServiceCall(){
        let dictLoginParameter = NSDictionary(dictionary: ["tag": "get_all_major","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_MAJOR, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        print(iDictUserData)
                        print(Constant.MAJOR_LIST)
                        if let majorData = iDictUserData.object(forKey: Constant.MAJOR_LIST) as? [NSDictionary] {
                            for i in majorData {
                                self.majorDic["\(i.object(forKey: "major_name")!)"] = "\(i.object(forKey: "id")!)"
                            }
                        }
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }

            }
        }
    }
    //MARK : UIViewController Events
    
    @IBAction func yourMajorBtnClicked(_ sender: Any) {
        //print(majorDic)
        //print(Array(majorDic.values))
        print(majorDic)
        let values = Array(majorDic.keys) as [String]
        if values.count <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Record not found.", iButtonTitle: "OK", iViewController: self)
            return
        }else {
            PickerView().showTableview(title: "Your Major", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: values, selected:nil,iViewController:self) { (value) -> Void in
                self.yourmajorLbl.text = value
                self.majorID = self.majorDic[value]!
                print(self.majorID)
            }
        }
    }
    
    
    @IBAction func yearBtnClicked(_ sender: Any) {
        PickerView().showTableview(title: "Year", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: ["freshman","Sophomore", "Junior", "Senior","Grad"], selected:nil,iViewController:self) { (value) -> Void in
            self.yearLbl.text = value
        }
    }
    
    
    
    @IBAction func saveAndnextBtnClicked(_ sender: Any) {
    //self.performSegue(withIdentifier: "Classes", sender: nil)
       if (txtFild_Firstname.text?.characters.count)! <= 0  {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter first name", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (txtFld_Lastname.text?.characters.count)! <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter last name", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (txtMajor.text?.characters.count)! <= 0  {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter your major.", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (yearLbl.text!) == "Year*" {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please select year", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (txtCampus.text?.characters.count)! <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter campus", iButtonTitle: "OK", iViewController: self)
            return
        }

        let dictLoginParameter = NSDictionary(dictionary:["tag":"updateprofile","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","first_name":self.txtFild_Firstname.text!,"last_name":self.txtFld_Lastname.text!,"major":self.txtMajor.text!,"year":self.yearLbl.text!,"campus":self.txtCampus.text!,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        print(dictLoginParameter)
        if let img = self.userProfileImgview.image {
            let newImage = self.rotateCameraImageToProperOrientation(imageSource : self.userProfileImgview.image!, maxResolution : 200.0)
            WebServiceManager.callImageUploadWithParameterUsingMultipart(WSUrl: Constant.WS_USER_PROFILE, WSParams: dictLoginParameter, isLoader: true, iImgName:"profile_picture",iImage:newImage) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    let iDictUserData = iData as! NSDictionary
                    if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber{
                        if iIntSuccess == 0 {
                            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                        }else {
                    print(iData ?? "")
                        if let userDetail = iDictUserData.object(forKey: "user_details") as? [String : Any] {
                            let userDetailModel = SG_USER_DETAIL(fromDictionary: (userDetail))
                            Constant.USER_DEFAULT.set(userDetailModel.id, forKey: Constant.USER_ID)
                            Constant.USER_DEFAULT.set(userDetailModel.loginFlag, forKey: Constant.IS_LOGGED_IN)
                            Constant.USER_DEFAULT.set(userDetailModel.firstName, forKey: "firstName")
                            Constant.USER_DEFAULT.set(userDetailModel.lastName, forKey: "lastName")
                            Constant.USER_DEFAULT.set(userDetailModel.accessToken, forKey: Constant.ACCESS_TOKEN)
                            Constant.USER_DEFAULT.set(userDetailModel.schoolId, forKey: Constant.SCHOOL_ID)
                            Constant.USER_DEFAULT.set(userDetailModel.userRole, forKey: Constant.USER_ROLE)
                            Constant.USER_DEFAULT.set(userDetailModel.photo,forKey:Constant.USER_PHOTO)
                        Constant.USER_DEFAULT.set(self.majorID,forKey:"majorID")
                            Constant.USER_DEFAULT.set(self.txtMajor.text!,forKey:"major")
                            Constant.USER_DEFAULT.set(self.yearLbl.text!,forKey:"year")
                            Constant.USER_DEFAULT.set(self.schoolID,forKey:"locationId")
                            Constant.USER_DEFAULT.set(self.txtCampus.text!,forKey:"campus")
                            
                            var iDictUserProfile = userDetailModel.toDictionary()
                            let iDictProfile = (iDictUserProfile as Dictionary).nullKeyRemoval()
                            iDictUserProfile = (iDictProfile as NSDictionary)
                            
                            iDictUserProfile.write(toFile: Constant.PLIST_USER_PROFILE_PATH, atomically: true)
                            if let msg = iDictUserData.object(forKey: Constant.MESSAGE) as? String {
                                let logoutAlert = UIAlertController(title: "", message: msg as! String, preferredStyle: UIAlertControllerStyle.alert)
                                
                                logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    self.performSegue(withIdentifier: "Classes", sender: nil)
                                }))
                                
                                self.present(logoutAlert, animated: true, completion: nil)
                            }
                            //let vc = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "ClassVC") as? SG_ClassesVC
                            //self.navigationController?.pushViewController(vc!, animated: true)
                            
                        }
                    }
                    }
                }
            }
        }else {
        
            WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_USER_PROFILE, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    let iDictUserData = iData as! NSDictionary
                    if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber{
                        if iIntSuccess == 0 {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                        }
                    }else {
                    
                        if let userDetail = iDictUserData.object(forKey: "user_details") as? [String : Any] {
                            let userDetailModel =    SG_USER_DETAIL(fromDictionary: (userDetail))
                            Constant.USER_DEFAULT.set(userDetailModel.id, forKey: Constant.USER_ID)
                            Constant.USER_DEFAULT.set(userDetailModel.loginFlag, forKey: Constant.IS_LOGGED_IN)
                            Constant.USER_DEFAULT.set(userDetailModel.firstName, forKey: "firstName")
                            Constant.USER_DEFAULT.set(userDetailModel.lastName, forKey: "lastName")
                            Constant.USER_DEFAULT.set(userDetailModel.accessToken, forKey: Constant.ACCESS_TOKEN)
                            Constant.USER_DEFAULT.set(userDetailModel.schoolId, forKey: Constant.SCHOOL_ID)
                            Constant.USER_DEFAULT.set(userDetailModel.userRole, forKey: Constant.USER_ROLE)
                            Constant.USER_DEFAULT.set(userDetailModel.photo,forKey:Constant.USER_PHOTO)
                            
                            Constant.USER_DEFAULT.set(self.majorID,forKey:"majorID")
                            Constant.USER_DEFAULT.set(self.txtMajor.text!,forKey:"major")
                            Constant.USER_DEFAULT.set(self.txtCampus.text!,forKey:"campus")
                            Constant.USER_DEFAULT.set(self.yearLbl.text!,forKey:"year")
                            Constant.USER_DEFAULT.set(self.schoolID,forKey:"locationId")
                            
                            
                            var iDictUserProfile = userDetailModel.toDictionary()
                            let iDictProfile = (iDictUserProfile as Dictionary).nullKeyRemoval()
                            iDictUserProfile = (iDictProfile as NSDictionary)
                            iDictUserProfile.write(toFile: Constant.PLIST_USER_PROFILE_PATH, atomically: true)
                            if let msg = iDictUserData.object(forKey: Constant.MESSAGE) as? String {
                                let logoutAlert = UIAlertController(title: "", message: iData?.object(forKey: Constant.MESSAGE) as! String, preferredStyle: UIAlertControllerStyle.alert)
                                
                                logoutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                    self.performSegue(withIdentifier: "Classes", sender: nil)
                                }))
                                self.present(logoutAlert, animated: true, completion: nil)
                                
                            }                        }
                    }

                }
            }
        }
    }
    
    @IBAction func backBarBtnClicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imgPickerBtnClicked(_ sender: Any) {
        picker.allowsEditing = false
        
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = self.userProfileImgview
        alert.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction)in
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default , handler:{ (UIAlertAction)in
            //self.picker.sourceType = .photoLibrary
            //self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.mediaTypes = ["public.image"]
            self.present(self.picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
        present(picker, animated: true, completion: nil)
    }
    //
    func schoolLocationgetServiceCall(){
        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"location_list","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        print(dictLoginParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_USER, WSParams: dictLoginParameter, WSMethod: .post, isLoader: false) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictUserData = iData as! NSDictionary
                
                if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber {
                    if iIntSuccess == 1 {
                        print(iDictUserData)
                        
                        if let majorData = iDictUserData.object(forKey: "location_list") as? [NSDictionary] {
                            for i in majorData {
                                
                                self.schoolDic["\(i.object(forKey: "city")!),\(i.object(forKey: "country_name")!)"] = "\(i.object(forKey: "id")!)"
                            }
                        }
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func schoolBtnTaped(_ sender: Any) {
            let svalues = Array(schoolDic.keys) as [String]
        if svalues.count <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Record not found.", iButtonTitle: "OK", iViewController: self)
            return
        }else {
            PickerView().showTableview(title: "Your Location", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: svalues, selected:nil,iViewController:self) { (value) -> Void in
                print(value)
                self.schoolLbl.text = value
                print(self.schoolDic)
                print(self.schoolDic[value]!)
                self.schoolID = self.schoolDic[value]!
                print(self.schoolID)
            }
        }
        
    }

    
    //MARK: - Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage { //2
            userProfileImgview.contentMode = .scaleAspectFill //3
            userProfileImgview.image = chosenImage //4
        }
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.index = textField.tag
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

    
    func keyboardWillShow(_ notification:Notification)
    {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            //self.view.frame.origin.y -= keyboardSize.height
            var userInfo = notification.userInfo!
            var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            var contentInset:UIEdgeInsets = self.tblView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            self.tblView.contentInset = contentInset
            
            //get indexpath
            print(index)
            let indexpath = NSIndexPath(row: index!, section: 0)
            
            self.tblView.scrollToRow(at: indexpath as IndexPath, at: UITableViewScrollPosition.top, animated: true)
        }
        
    }
    
    
    // This method will adjust tableview inset when keyboard will disappear
    
    func keyboardWillHide(_ notification:Notification)
    {
        UIView.beginAnimations("tableViewAnimation", context: nil)
        UIView.setAnimationDuration(0.1)
        // change tableview inset to default
        self.tblView.contentInset = self.defaultTableViewInset!
        UIView.commitAnimations()
    }

}
