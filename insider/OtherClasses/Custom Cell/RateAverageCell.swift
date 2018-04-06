//
//  RateAverageCell.swift
//  Student_GPA
//
//  Created by mac 2 on 16/08/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class RateAverageCell: UITableViewCell {
    
   // @IBOutlet weak var userProfImage: RemoteImageView!

     @IBOutlet weak var lblTeacherName: UILabel!
    
    @IBOutlet weak var rOneBtn: UIButton!
    
    @IBOutlet weak var rtwoBtn: UIButton!
    
    @IBOutlet weak var rthreeBtn: UIButton!
    
    @IBOutlet weak var rfourBtn: UIButton!
    
    
    @IBOutlet weak var rfiveBtn: UIButton!
    
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var lblNoRate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
