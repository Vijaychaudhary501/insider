//
//  MyProfileCell.swift
//  Student_GPA
//
//  Created by mac 2 on 09/06/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class MyProfileCell: UITableViewCell {

    @IBOutlet weak var selectView: UIView!
   // @IBOutlet weak var profileImageView: RemoteImageView!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var classesBtn: UIButton!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var groupStudiesBtn: UIButton!
    
    @IBOutlet weak var ratemyteacherBtn: UIButton!
    
    @IBOutlet weak var insitsBtn: UIButton!
    
    //@IBOutlet weak var logoutBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // profileImageView.setCircleView(width: profileImageView.bounds.width)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
