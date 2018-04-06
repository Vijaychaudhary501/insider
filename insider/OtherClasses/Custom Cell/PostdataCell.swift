//
//  PostdataCell.swift
//  Student_GPA
//
//  Created by mac 2 on 19/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit
import  AVKit
import  AVFoundation
import MediaPlayer

class PostdataCell: UITableViewCell {

    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userNameLbl: UILabel!
    
   @IBOutlet weak var profileImageview: RemoteImageView!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var postDataView: UIView!
    
    @IBOutlet weak var discriptionLbl: UILabel!
    
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBOutlet weak var report_editBtn: UIButton!
    
    @IBOutlet weak var postDescTop: NSLayoutConstraint!
    
    @IBOutlet weak var postDataImage: RemoteImageView!
    
    @IBOutlet weak var cmntLbl: UILabel!
    
    
    @IBOutlet weak var cellViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var cmntLblHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var descTextView: UITextView?//RegeributedTextView!
    
    
    
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    var playImg = UIImageView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // profileImageview.setCircleView(width: profileImageview.bounds.width)
        
        playerController = AVPlayerViewController()
        postDataView.addSubview(playerController!.view)
        //playerController!.view.backgroundColor = .white
        playerController!.view.frame = CGRect(x:0, y: 0, width: postDataView.bounds.width, height: postDataView.bounds.height)
        self.playImg = UIImageView(frame: CGRect(x: (postDataView.bounds.width/2)-100, y: 125, width: 70, height: 70))
        playImg.image = #imageLiteral(resourceName: "PlayBtn")
        postDataView.addSubview(playImg)
        playImg.isHidden = true
        
    }
//MARK:TEXTVIEW
    
    func setCellText(_ text:String){
//        descTextView.text = text
//        descTextView.resolveHashTags()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
