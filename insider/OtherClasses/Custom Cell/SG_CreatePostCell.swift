//
//  SG_CreatePostCell.swift
//  Student_GPA
//
//  Created by mac 2 on 04/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_CreatePostCell: UITableViewCell {
    @IBOutlet weak var profileImage: RemoteImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var myPostImageView: RemoteImageView!
    
    @IBOutlet weak var txtfldSaySomething: UITextField!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    
    @IBOutlet weak var selectPhotoBtn: UIButton!
    
    
    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var sendMsgBtn: UIButton!
    
    @IBOutlet weak var addFavouriteBtn: UIButton!
    
    @IBOutlet weak var viewGrpStudyBtn: UIButton!
    
    @IBOutlet weak var classBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //profileImage.setCircleView(width: profileImage.bounds.width)
        // Initialization code
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
