//
//  MessageCell.swift
//  Student_GPA
//
//  Created by mac 2 on 20/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
   // @IBOutlet weak var userProfileImage: RemoteImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var detailMessageLbl: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //userProfileImage.setCircleView(width: userProfileImage.bounds.width)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
