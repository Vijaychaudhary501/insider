//
//  ClassesCell.swift
//  Student_GPA
//
//  Created by mac 2 on 19/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class ClassesCell: UITableViewCell {

    @IBOutlet weak var crnTextFld: UITextField!
    
    @IBOutlet weak var lblCourse: UILabel!
    
    @IBOutlet weak var txtCourse: UITextField!
    @IBOutlet weak var titleTxtFld: UITextField!
    
    @IBOutlet weak var lblTeacher: UILabel!
    
    @IBOutlet weak var bookSeg: UISegmentedControl!
    
    @IBOutlet weak var currentSegment: UISegmentedControl!
    
    @IBOutlet weak var noteSeg: UISegmentedControl!
    
    
    @IBOutlet weak var saveAndMoreBtn: UIButton!
    
    @IBOutlet weak var txtfldTeacher: UITextField!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
