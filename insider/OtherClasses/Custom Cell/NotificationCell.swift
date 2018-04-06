//
//  NotificationCell.swift
//  Student_GPA
//
//  Created by mac 2 on 19/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var notificaionImage: RemoteImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
