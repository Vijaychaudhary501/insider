//
//  CC_ChatCell.swift
//  CoCarrier
//
//  Created by Priyank Gandhi on 12/7/16.
//  Copyright © 2016 Priyank Gandhi. All rights reserved.
//

import UIKit


class CC_ChatCell: UITableViewCell {
    
    @IBOutlet weak var vWReciver:UIView!
    @IBOutlet weak var vWSender:UIView!
    
  //  @IBOutlet weak var imgVwReciverChatBg:RemoteImageView!
    @IBOutlet weak var txtVwReciverChat:UITextView!
    @IBOutlet weak var lblReciverTime:UILabel!
    
    @IBOutlet weak var constraintImgVwReciver:NSLayoutConstraint!
    @IBOutlet weak var constraintImgVwHeightReciver:NSLayoutConstraint!
    
   // @IBOutlet weak var imgVwSenderChatBg:RemoteImageView!
    @IBOutlet weak var txtVwSenderChat:UITextView!
    @IBOutlet weak var lblSenderTime:UILabel!
    
    @IBOutlet weak var constraintImgVwWidthSender:NSLayoutConstraint!
    @IBOutlet weak var constraintImgVwHeightSender:NSLayoutConstraint!

   
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
