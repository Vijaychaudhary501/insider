//
//  InsightCell.swift
//  Student_GPA
//
//  Created by mac 2 on 20/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class InsightCell: UITableViewCell {

   // @IBOutlet weak var profileImgView: RemoteImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var removeFavBtn: UIButton!
    
    @IBOutlet weak var msgBtn: UIButton!
    
    @IBOutlet weak var msgCntLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // profileImgView.setCircleView(width: profileImgView.bounds.width)
    }

    @IBOutlet weak var imgBtn: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
