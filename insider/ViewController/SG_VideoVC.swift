//
//  SG_VideoVC.swift
//  Student_GPA
//
//  Created by mac 2 on 10/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import  Photos
class SG_VideoVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //fileprivate let textField = SNTextField(y: SNUtils.screenSize.height/2, width: SNUtils.screenSize.width, heightOfScreen: SNUtils.screenSize.height)
    private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
//    fileprivate let buttonSave = SNButton(frame: CGRect(x: 20, y: SNUtils.screenSize.height - 35, width: (UIScreen.main.bounds.width)-220, height: 20), withImageNamed: "saveButton")
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
        //let textButton = UIButton(frame: CGRect(x:UIScreen.main.bounds.width - 55.0, y: 30.0, width: 30.0, height: 30.0))
        //textButton.setImage(#imageLiteral(resourceName: "Pencil"), for: UIControlState())
        //textButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        //view.addSubview(textButton)
        //setupTextField()
        setupButtonSave()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                self.dismiss(animated: false, completion: nil)
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    /*fileprivate func setupTextField() {
        self.view.addSubview(textField)
        
        //self.tapGesture.delegate = self
        //self.view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self.textField, selector: #selector(SNTextField.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self.textField, selector: #selector(SNTextField.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self.textField, selector: #selector(SNTextField.keyboardTypeChanged(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    fileprivate func setupButtonSave() {
        self.buttonSave.setAction {
            [weak weakSelf = self] in
            self.player?.pause()
            //let picture = SNUtils.screenShot(weakSelf?.view)
            let composition = AVMutableComposition()
            var vidAsset = AVURLAsset(url: self.videoURL, options: nil)
            
            // get video track
            let vtrack =  vidAsset.tracks(withMediaType: AVMediaTypeVideo)
            let videoTrack:AVAssetTrack = vtrack[0] 
            let vid_duration = videoTrack.timeRange.duration
            let vid_timerange = CMTimeRangeMake(kCMTimeZero, vidAsset.duration)
            
            var error: NSError?
            let compositionvideoTrack:AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
            do {
                try compositionvideoTrack.insertTimeRange(vid_timerange, of: videoTrack, at: kCMTimeZero)
            } catch _ {
                print("ERRORRRRRRRRRRRRRRRR")
            }
            
            //compositionvideoTrack.insertTimeRange(vid_timerange, ofTrack: videoTrack, atTime: kCMTimeZero, error: &error)
            
            compositionvideoTrack.preferredTransform = videoTrack.preferredTransform
            
            // Watermark Effect
            let size = videoTrack.naturalSize
            
            let imglogo = #imageLiteral(resourceName: "SG_Logo")
            let imglayer = CALayer()
            imglayer.contents = imglogo.cgImage
            imglayer.frame = CGRect(x:5,y: 5,width: 100,height: 100)
            imglayer.opacity = 0.6
            
            // create text Layer
            let titleLayer = CATextLayer()
            titleLayer.backgroundColor = UIColor.white.cgColor
            titleLayer.string = "Dummy text"
            titleLayer.font = UIFont(name: "Helvetica", size: 28)
            titleLayer.shadowOpacity = 0.5
            titleLayer.alignmentMode = kCAAlignmentCenter
            titleLayer.frame = CGRect(x:0,y: 50,width: size.width,height: size.height / 6)
            
            let videolayer = CALayer()
            videolayer.frame = CGRect(x:0,y: 0,width: size.width,height: size.height)
            
            let parentlayer = CALayer()
            parentlayer.frame = CGRect(x:0,y: 0,width: size.width,height: size.height)
            parentlayer.addSublayer(videolayer)
            parentlayer.addSublayer(imglayer)
            parentlayer.addSublayer(titleLayer)
            
            let layercomposition = AVMutableVideoComposition()
            layercomposition.frameDuration = CMTimeMake(1, 30)
            layercomposition.renderSize = size
            layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)
            
            // instruction for watermark
            let instruction = AVMutableVideoCompositionInstruction()
            instruction.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
            let videotrack = composition.tracks(withMediaType: AVMediaTypeVideo)[0] as AVAssetTrack
            let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
            instruction.layerInstructions = NSArray(object: layerinstruction) as [AnyObject] as [AnyObject] as! [AVVideoCompositionLayerInstruction]
            layercomposition.instructions = NSArray(object: instruction) as [AnyObject] as [AnyObject] as! [AVVideoCompositionInstructionProtocol]
            
            //  create new file to receive data
            //let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            //let docsDir: String = (dirPaths[0] as AnyObject) as! String
            //let movieFilePath = docsDir.appending("result.mov")
            //let movieDestinationUrl = NSURL(fileURLWithPath: movieFilePath)
            
            // use AVAssetExportSession to export video
            let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
            assetExport?.outputFileType = AVFileTypeQuickTimeMovie
            assetExport?.outputURL = self.videoURL
            assetExport?.exportAsynchronously(completionHandler: {
                //switch assetExport?.status{
                //case  AVAssetExportSessionStatus.failed:
                    print("failed \(assetExport?.error)")
                //case AVAssetExportSessionStatus.cancelled:
                    print("cancelled \(assetExport?.error)")
                //default:
                    print("Movie complete")
                
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
                }) { saved, error in
                    if saved {
                        let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                    
                    // play video
                    //OperationQueue.main.addOperation({ () -> Void in
               
                        //self.player = AVPlayer(url: movieDestinationUrl as URL)
                        //self.player?.play()
                   // })
                //}
            })    

            //self.dismiss(animated: true, completion: nil)
            
        }
        
        self.view.addSubview(self.buttonSave)
    }
    func handleTap() {
        self.view.bringSubview(toFront: textField)
        self.textField.handleTap()
        
    }*/
    
    fileprivate func setupButtonSave() {
        /*self.buttonSave.setAction {
            [weak weakSelf = self] in
            

            self.creatStoryServiceCall(self.videoURL)
        }
        
        self.view.addSubview(self.buttonSave)*/
    }
    func creatStoryServiceCall(_ videourl:URL){
        /*
         URL: http://kalpcorp.in/insight/api/story.php
         Parameters:
         tag:create_story
         school_id:2
         user_id:21
         token:RsvguEmaSNYAb7f8HqCeBTdOZaHxfajK
         type:photo or video
         */
        //let asset : AVURLAsset = AVURLAsset(url: videourl) as AVURLAsset
        //let duration : CMTime = asset.duration
        //let second = CMTimeGetSeconds(duration)
        let dictLoginParameter = NSDictionary(dictionary: ["tag":"create_story","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","time":"2","type":"video","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)"])
        print(dictLoginParameter)
        WebServiceManager.callVideoUploadWithParameterUsingMultipart(WSUrl: Constant.WS_CREAT_STORY, WSParams: dictLoginParameter, isLoader: true, iVdoName: "story_file", iVideo:videourl) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        self.player?.isMuted = true
                        self.player?.pause()
                        //Constant.appDelegate.createMenubar()
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
                
            }
        }
        
        
    }

    @objc func cancel() {
        self.player?.isMuted = true
        self.player?.pause()
        dismiss(animated: false, completion: nil)
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}
