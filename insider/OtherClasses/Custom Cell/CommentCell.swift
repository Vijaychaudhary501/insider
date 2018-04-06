//
//  CommentCell.swift
//  Student_GPA
//
//  Created by mac 2 on 23/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    
   @IBOutlet weak var userProfImage: RemoteImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var commentLbl: UILabel!
    
    @IBOutlet weak var cmntBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        //userProfImage.setCircleView(width: userProfImage.bounds.width)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
