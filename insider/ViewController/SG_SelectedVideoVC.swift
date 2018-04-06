//
//  SG_SelectedVideoVC.swift
//  Student_GPA
//
//  Created by mac 2 on 08/06/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//



import UIKit
import AVFoundation
import AVKit
import  Photos


class SG_SelectedVideoVC: UIViewController {
    
   // var delegate : AddVideoDelegate?
    
        override var prefersStatusBarHidden: Bool {
            return true
        }
        //fileprivate let textField = SNTextField(y: SNUtils.screenSize.height/2, width: SNUtils.screenSize.width, heightOfScreen: SNUtils.screenSize.height)
        private var videoURL: URL
        var player: AVPlayer?
        var playerController : AVPlayerViewController?
        //fileprivate let buttonSave = SNButton(frame: CGRect(x: 20, y: SNUtils.screenSize.height - 35, width: 33, height: 30), withImageNamed: "saveButton")
        init(videoURL: URL) {
            self.videoURL = videoURL
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = UIColor.gray
            player = AVPlayer(url: videoURL)
            playerController = AVPlayerViewController()
            
            guard player != nil && playerController != nil else {
                return
            }
            playerController!.showsPlaybackControls = false
            
            playerController!.player = player!
            self.addChildViewController(playerController!)
            self.view.addSubview(playerController!.view)
            playerController!.view.frame = view.frame
            NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
            
            let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 25.0, width: 30.0, height: 30.0))
            cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
            cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            view.addSubview(cancelButton)
            let button = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.height-54, width: UIScreen.main.bounds.width-40, height: 44))
            button.backgroundColor = UIColor(hexString: "ff8400")
            button.setTitle("ADD", for: .normal)
            button.tintColor = .white
            button.addTarget(self, action: #selector(addBtn), for: .touchUpInside)
            view.addSubview(button)
            
            
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            player?.play()
        }
                func cancel() {
            dismiss(animated: true, completion: nil)
        }
        
        @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
            if self.player != nil {
                self.player!.seek(to: kCMTimeZero)
                self.player!.play()
            }
        }
    
    func addBtn(){
        print("Button pressed")
        
        //self.delegate?.addVideo(videoURL)
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

}
