//
//  SearchCell.swift
//  Student_GPA
//
//  Created by mac 2 on 20/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

   
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var addpersonNameLbl: UILabel!
    
    @IBOutlet weak var selectImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
