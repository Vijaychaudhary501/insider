//
//  ContactCell.swift
//  Student_GPA
//
//  Created by mac 2 on 20/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    
    
    @IBOutlet weak var selectImgView: UIImageView!
    
    //@IBOutlet weak var profileImageView: RemoteImageView!
    
    @IBOutlet weak var userLbl: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // profileImageView.setCircleView(width: profileImageView.bounds.width)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
