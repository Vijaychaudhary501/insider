//
//  SG_SelectPhotoVC.swift
//  Student_GPA
//
//  Created by mac 2 on 08/06/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit
protocol AddPhotoDelegate {
    func addPhoto(_:Any)
    func addVideo(_:Any)
}

class SG_SelectPhotoVC: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var delegate : AddPhotoDelegate?
    private var backgroundImage: UIImage
    private var imageUrl:String?
    
    init(imageurl: UIImage) {
        backgroundImage = imageurl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = RemoteImageView(frame: view.frame)
        backgroundImageView.contentMode = UIViewContentMode.scaleToFill
        backgroundImageView.image = self.backgroundImage
        view.addSubview(backgroundImageView)
        // Buttons
        let button = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height-54, width: UIScreen.main.bounds.width-40, height: 44))
        button.backgroundColor = UIColor(hexString: "ff8400")
        button.setTitle("ADD", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(addBtn), for: .touchUpInside)
        view.addSubview(button)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 20.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                self.dismiss(animated: true, completion: nil)
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Button Action
    
    func addBtn(){
        print("Button pressed")
        
        self.delegate?.addPhoto(backgroundImage)
        
        _ = self.navigationController?.popToRootViewController(animated: true)
}
}
