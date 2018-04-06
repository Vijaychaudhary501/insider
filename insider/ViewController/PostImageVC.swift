//
//  PostImageVC.swift
//  Student_GPA
//
//  Created by mac 2 on 08/07/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class PostImageVC: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    //var scrollView = FAScrollView()
    //var backgroundImageView = RemoteImageView()
    //private var backgroundImage: UIImage
    private var imageUrl:String?
    private var indexID:Int?
    var no:Int = 0
    var storyDataArray = [StoryDataModal]()
    var myTimer  = Timer()
    var userName = UILabel()
   // var userImg = RemoteImageView()
    
    
    init(imageurl: String) {
        imageUrl = imageurl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(storyDataArray)
        self.view.backgroundColor = UIColor.gray
//        backgroundImageView = RemoteImageView(frame: view.frame)
//        backgroundImageView.contentMode = UIViewContentMode.scaleToFill
//        backgroundImageView.imageURL = NSURL(string: imageUrl!) as URL!
//        view.addSubview(backgroundImageView)
        // Buttons
        //scrollView.frame = backgroundImageView.frame
        //self.scrollView.imageToDisplay = backgroundImageView.image
        //view.addSubview(scrollView)
        let cancelButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.width - 55.0, y: 30.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        //self.userImg = RemoteImageView(frame: CGRect(x: 30.0, y: 40.0, width: 40.0, height: 40.0))
        //self.userImg.setCircleView(width: 20.0)
        //self.userImg.imageURL = NSURL(string: self.storyDataArray[indexID!].photo) as URL!
        //self.view.addSubview(self.userImg)
        self.userName = UILabel(frame: CGRect(x: 80.0, y: 40.0, width: 200.0, height: 40.0))
        self.userName.font = UIFont(name: "Trebuchet MS", size: 20.0)
        self.userName.textColor = UIColor(hexString: "ff8400")
        //self.userName.text = self.storyDataArray[indexID!].first_name
        //self.view.addSubview(userName)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeDown))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    @objc func respondToSwipeDown(){
        self.dismiss(animated: true, completion: {
            return
        })
    }
        
    @objc func cancel() {
        
        self.dismiss(animated: true, completion: {
            return
        })
    }
    
    // MARK: Button Action
   
    func addBtn(){
        print("Button pressed")
        
        //let  vc =  self.navigationController?.viewControllers[1]
        //self.navigationController?.popToViewController(vc!, animated: true)
    }

}
