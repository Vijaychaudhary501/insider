//
//  GroupstudyviewCell.swift
//  Student_GPA
//
//  Created by mac 2 on 24/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class GroupstudyviewCell: UITableViewCell {

    
    @IBOutlet weak var lblInviterName: UILabel!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var rejectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
