//
//  Menubar_Cell.swift
//  Student_GPA
//
//  Created by mac 2 on 18/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class Menubar_Cell: UITableViewCell {

    @IBOutlet weak var lblMenudataName: UILabel!
    
    @IBOutlet weak var postfiltericone: UIImageView!
    
    @IBOutlet weak var postfilterLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
