//
//  FADetailVC.swift
//  FAImageCropper
//
//  Created by Fahid Attique on 14/02/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//

import UIKit

class FADetailVC: UIViewController {

    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postTxtView:UITextView!
    
    // MARK: Public Properties
    
    var croppedImage:UIImage!
    var mainVC:MainViewController!
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewConfigurations()
        addNavigation()
        
    }
    func addNavigation(){
        let btnPost = UIBarButtonItem.init(title: "post", style: .plain, target: self, action: #selector(addPhoto))
        self.navigationItem.rightBarButtonItem = btnPost
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Private Functions
    
    private func viewConfigurations(){
        imageView.image = croppedImage
    }
    func addPhoto(){
        if let img = imageView.image {
            let dictLoginParameter = NSDictionary(dictionary: ["tag":Constant.POST_CRETAE,"created_by":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","post_description":"\(self.postTxtView.text!)","post_type":"photo","tagged_person":"","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","iv_count":"1"])
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
                             self.navigationController?.popToRootViewController(animated: true)
                            
                        }else {
                            let alert1 = UIAlertController(title: "", message: "\(iDictUserData.object(forKey: Constant.MESSAGE) as! String)" , preferredStyle: .alert)
                            alert1.addAction(UIAlertAction(title: "ok", style: .default, handler: { (okAction) in
                            }))
                            self.present(alert1, animated: true, completion: nil)
                        }
                    }
                }
            }
            
        }
        
    }
}
