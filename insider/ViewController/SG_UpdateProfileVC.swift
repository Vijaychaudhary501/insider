//
//  SG_UpdateProfileVC.swift
//  Student_GPA
//
//  Created by mac 2 on 14/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_UpdateProfileVC: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet var tblView: UITableView!
    
    @IBOutlet weak var userProfileimgView: RemoteImageView!
    
    @IBOutlet weak var txtFldFirstname: UITextField!
    
    @IBOutlet weak var txtFldLastname: UITextField!
    
    @IBOutlet weak var txtFldOldpassword: UITextField!
    
    @IBOutlet weak var txtFldNewpassword: UITextField!
    
    @IBOutlet weak var txtFldConfirmpassword: UITextField!
    
    @IBOutlet weak var yourmajorLbl: UILabel!
    
    @IBOutlet weak var txtMajor: UITextField!
    @IBOutlet weak var yearLbl: UILabel!
    
    @IBOutlet weak var schoolLbl: UILabel!
    
    @IBOutlet weak var txtCampus: UITextField!
    var defaultTableViewInset:UIEdgeInsets?
    var index:Int?
    
    let picker = UIImagePickerController()
    
    lazy var majorID = String()
    var majorDic = [String:String]()
    var schoolDic = [String:String]()
    lazy var schoolID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UPDATE PROFILE"
        
        self.tblView.backgroundColor = .clear
        let backgroundImage = UIImage(named: "UpdateProfileBG")
        let imageView = UIImageView(image: backgroundImage)
        self.tblView.backgroundView = imageView
        self.tblView.tableFooterView = UIView(frame: CGRect.zero)
        self.picker.delegate = self
        //Setup TextField
        self.defaultTableViewInset = self.tblView.contentInset
        self.txtFldFirstname.placeHolderCustomized("First Name*", strHexColor: "ffffff")
        self.txtFldFirstname.delegate = self
        self.txtFldLastname.placeHolderCustomized("Last Name*", strHexColor: "ffffff")
        self.txtFldLastname.delegate = self
        self.txtMajor.placeHolderCustomized("Your Major*", strHexColor: "ffffff")
        self.txtMajor.delegate = self
        self.txtCampus.placeHolderCustomized("Campus*", strHexColor: "ffffff")
        self.txtCampus.delegate = self
        self.txtFldOldpassword.placeHolderCustomized("Old Password*", strHexColor: "ffffff")
        self.txtFldOldpassword.delegate = self
        self.txtFldNewpassword.placeHolderCustomized("New Password*", strHexColor: "ffffff")
        self.txtFldNewpassword.delegate = self
        self.txtFldConfirmpassword.placeHolderCustomized("Confirm Password*", strHexColor: "ffffff")
        self.txtFldConfirmpassword.delegate = self
        //
        self.txtFldFirstname.text = Constant.USER_DEFAULT.value(forKey: "firstName") as! String?
        self.txtFldLastname.text = Constant.USER_DEFAULT.value(forKey: "lastName") as! String?
        
        if let profUrl:String = Constant.USER_DEFAULT.value(forKey: Constant.USER_PHOTO) as? String {
            //userProfileimgView.imageURL = NSURL(string: (profUrl)) as URL!
        }
        userProfileimgView.layer.cornerRadius = userProfileimgView.frame.size.width / 2
        userProfileimgView.clipsToBounds = true
        // Transperent NavigationBar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        txtMajor.text = Constant.USER_DEFAULT.value(forKey: "major") as! String?
        self.majorID = (Constant.USER_DEFAULT.value(forKey: "majorID") as! String?)!
        yearLbl.text = Constant.USER_DEFAULT.value(forKey: "year") as! String?
        txtCampus.text = Constant.USER_DEFAULT.value(forKey: "campus") as! String?
        self.schoolID = (Constant.USER_DEFAULT.value(forKey: "locationId") as! String?)!
        let button = UIButton()
        button.setTitle("Logout", for: UIControlState())
        button.backgroundColor = UIColor.red
        button.addTarget(self, action:#selector(self.toggleRigh), for: UIControlEvents.touchUpInside)
        button.frame = CGRect(x:0,y:0,width: 60,height: 30)
        let rightButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = rightButton
        

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        yourmajorLbl.text = ""
        schoolLbl.text = ""
    }
    //Calls this function when the tap is recognized.
     func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        // Transperent NavigationBar
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        Utility.sharedInstance().setstatusbarColorClear()
        self.majorServiceCall()
        self.schoolLocationgetServiceCall()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        self.navigationController?.view.backgroundColor = UIColor.red
        Utility.sharedInstance().setstatusbarColor()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
        self.navigationController?.view.backgroundColor = UIColor.red
        Utility.sharedInstance().setstatusbarColor()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.index = textField.tag
    }
    //MARK : TABLEVIEW DATASOURCE
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        if indexPath.row == 0 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 11 {
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        }
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
    //MARK : UIViewController Events
    
    @IBAction func yourMajorBtnClicked(_ sender: Any) {
        //print(majorDic)
        //print(Array(majorDic.values))
        let values = Array(majorDic.keys) as [String]
        if values.count <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Record not found.", iButtonTitle: "OK", iViewController: self)
            return
        }else {
            PickerView().show(title: "Your Major", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: values, selected:nil,iViewController:self) { (value) -> Void in
                print(value)
                self.yourmajorLbl.text = value
                print(self.majorDic)
                print(self.majorDic[value]!)
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
    
    @IBAction func schoolBtnTaped(_ sender: Any) {
        let svalues = Array(schoolDic.keys) as [String]
        if svalues.count <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Record not found.", iButtonTitle: "OK", iViewController: self)
            return
        }else {
            PickerView().showTableview(title: "Your Major", doneButtonTitle:"Done", cancelButtonTitle:"Cancel", options: svalues, selected:nil,iViewController:self) { (value) -> Void in
                print(value)
                self.schoolLbl.text = value
                print(self.schoolDic)
                print(self.schoolDic[value]!)
                self.schoolID = self.schoolDic[value]!
                print(self.schoolID)
            }
        }

    }
    
    @IBAction func updateBtnClicked(_ sender: Any) {
        //1mK0FC0o
        if (txtFldFirstname.text?.characters.count)! <= 0  {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter first name", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (txtFldLastname.text?.characters.count)! <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter last name", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (txtMajor.text?.characters.count)! <= 0  {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter your major.", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        if (yearLbl.text!) == "Year" {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please select year", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (txtCampus.text?.characters.count)! <= 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter campus", iButtonTitle: "OK", iViewController: self)
            return
        }

        
        
        //let dictLoginParameter = NSDictionary(dictionary:["tag":"updateprofile","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","first_name":self.txtFldFirstname.text!,"last_name":self.txtFldLastname.text!,"major_id":self.majorID,"year":self.yearLbl.text!,"location_id":self.schoolID,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
         let dictLoginParameter = NSDictionary(dictionary:["tag":"updateprofile","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","first_name":self.txtFldFirstname.text!,"last_name":self.txtFldLastname.text!,"major":self.txtMajor.text!,"year":self.yearLbl.text!,"campus":self.txtCampus.text!,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        if self.userProfileimgView.image != nil {
            let newImage = self.rotateCameraImageToProperOrientation(imageSource : self.userProfileimgView.image!, maxResolution : 200.0)
            WebServiceManager.callImageUploadWithParameterUsingMultipart(WSUrl: Constant.WS_USER_PROFILE, WSParams: dictLoginParameter, isLoader: true, iImgName:"profile_picture",iImage:newImage) { (iData, iError) in
                if iError != nil {
                    print(iError?.localizedDescription ?? "")
                }else {
                    let iDictUserData = iData as! NSDictionary
                    if let iIntSuccess = iDictUserData.object(forKey: Constant.SUCCESS) as? NSNumber{
                        if iIntSuccess == 0 {
                            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                        }else {
                        print(iData ?? "error")
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
                                Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:msg , iButtonTitle: "Ok", iViewController: self)
                            }
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
                            Constant.USER_DEFAULT.set(self.yearLbl.text!,forKey:"year")
                            Constant.USER_DEFAULT.set(self.schoolID,forKey:"locationId")
                            Constant.USER_DEFAULT.set(self.txtCampus.text!,forKey:"campus")

                            
                            var iDictUserProfile = userDetailModel.toDictionary()
                            let iDictProfile = (iDictUserProfile as Dictionary).nullKeyRemoval()
                            iDictUserProfile = (iDictProfile as NSDictionary)
                            iDictUserProfile.write(toFile: Constant.PLIST_USER_PROFILE_PATH, atomically: true)
                            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage:"\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , iButtonTitle: "Ok", iViewController: self)
                            //self.txtFldFirstname.placeHolderCustomized("First Name", strHexColor: "ffffff")
                            //self.txtFldLastname.placeHolderCustomized("Last Name", strHexColor: "ffffff")
                        }
                    }
                    
                }
            }
        }


    }
    
    @IBAction func selectImgBtn(_ sender: Any) {
        picker.allowsEditing = false
        
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
       // alert.popoverPresentationController?.sourceView = self.userProfileimgView
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
    
    @IBAction func saveBtnTaped(_ sender: Any) {
        if (txtFldOldpassword.text?.characters.count)! < 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter old password", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        if (txtFldNewpassword.text?.characters.count)! < 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter new password", iButtonTitle: "OK", iViewController: self)
            return
        }
        if (txtFldConfirmpassword.text?.characters.count)! < 0 {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Please enter confirm password", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        if txtFldNewpassword.text != txtFldConfirmpassword.text {
            Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: "Password is not matched", iButtonTitle: "OK", iViewController: self)
            return
        }
        
        
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"change_password","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","current_password":self.txtFldOldpassword.text!,"new_password":self.txtFldNewpassword.text!,"token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        
        
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_USER, WSParams: dictLoginParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
               Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                self.txtFldOldpassword.placeHolderCustomized("Old Password", strHexColor: "ffffff")
                self.txtFldNewpassword.placeHolderCustomized("New Password", strHexColor: "ffffff")
                self.txtFldConfirmpassword.placeHolderCustomized("Confirm Password", strHexColor: "ffffff")

            }
        }

    }
    @IBAction func backBarBtnClicked(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
        //Constant.appDelegate.createMenubar()
    }
    
    func toggleRigh() {
        let logoutAlert = UIAlertController(title: "Log out", message: "Are you sure to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        logoutAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action: UIAlertAction!) in
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
            
            let VC1 = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "Login") as! SG_LoginVC
            //let nav = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "InitialNav") as? UINavigationController
            let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
            VC1.modalTransitionStyle = .coverVertical
            VC1.modalPresentationStyle = .overFullScreen
            VC1.modalPresentationCapturesStatusBarAppearance = true
            self.present(navController, animated:true, completion: nil)
           // navController.pushViewController(VC1, animated: true)
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(logoutAlert, animated: true, completion: nil)
    }
    
    //MARK: - Image Picker Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage { //2
            userProfileimgView.contentMode = .scaleAspectFill //3
            userProfileimgView.image = chosenImage //4
        }
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
        
        let imgRef = imageSource.cgImage;
        
        let width = CGFloat(imgRef!.width);
        let height = CGFloat(imgRef!.height);
        
        //var bounds = CGRectMake(0,0,width,height)
        var bounds = CGRect(x:0,y:0,width:width,height:height)
        let scaleRatio : CGFloat = 1
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
            
        default :
            break
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
            if index == 8 || index == 9 || index == 10 {
            //print(index)
            let indexpath = NSIndexPath(row: index!, section: 0)
            
            self.tblView.scrollToRow(at: indexpath as IndexPath, at: UITableViewScrollPosition.top, animated: true)
            }
        }
        
    }
    
    
    // This method will adjust tableview inset when keyboard will disappear
    
    func keyboardWillHide(_ notification:Notification)
    {
        UIView.beginAnimations("tableViewAnimation", context: nil)
        UIView.setAnimationDuration(0.1)
        // change tableview inset to default
        if index == 8 || index == 9 || index == 10 {
            self.tblView.contentInset = self.defaultTableViewInset!
            UIView.commitAnimations()

        }

    }

    
    
}
