//
//  RateofteacherCell.swift
//  Student_GPA
//
//  Created by mac 2 on 22/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class RateofteacherCell: UITableViewCell {
//
    @IBOutlet weak var courseLbl: UILabel!
    
    @IBOutlet weak var crnTxtFld: UITextField!
    @IBOutlet weak var rOneBtn: UIButton!
    
    @IBOutlet weak var rtwoBtn: UIButton!
    
    @IBOutlet weak var rthreeBtn: UIButton!
    
    @IBOutlet weak var rfourBtn: UIButton!
    
    
    @IBOutlet weak var rfiveBtn: UIButton!
    
    
    @IBOutlet weak var hdOneBtn: UIButton!
    
    @IBOutlet weak var hdtwoBtn: UIButton!
    
    @IBOutlet weak var hdthreeBtn: UIButton!
    
    @IBOutlet weak var hdfourBtn: UIButton!
    
    
    @IBOutlet weak var hdfiveBtn: UIButton!

    
    @IBOutlet weak var lblRating: UILabel!
       
    @IBOutlet weak var lblAttendance: UILabel!
    
    @IBOutlet weak var lblHomework: UILabel!
    
    /*@IBOutlet weak var textBook: UISwitch!
    @IBOutlet weak var grpPrj: UISwitch!
    @IBOutlet weak var cellPhone: UISwitch!
    @IBOutlet weak var curving: UISwitch!
    @IBOutlet weak var takeAgain: UISwitch!*/
 
    @IBOutlet weak var textBookSegment: UISegmentedControl!
    
    
    @IBOutlet weak var grpSegment: UISegmentedControl!
    
    @IBOutlet weak var cellphoneSegment: UISegmentedControl!
    
    @IBOutlet weak var curvingSegment: UISegmentedControl!
    
    
    @IBOutlet weak var takeagainSegment: UISegmentedControl!
    
    
    
    
    
    //
    
    @IBOutlet weak var commentTxtview: UITextView!
    
    
    
    
    @IBOutlet weak var lblBook: UILabel!
    
    @IBOutlet weak var lblGrp: UILabel!
    
    @IBOutlet weak var lblCellphone: UILabel!
    
    @IBOutlet weak var lblCurving: UILabel!
    
    
    @IBOutlet weak var lblTakeagain: UILabel!
    
    @IBOutlet weak var lblCmnt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.commentTxtview.layer.borderColor = UIColor.init(hexString: "cbcbcb")?.cgColor
        //self.commentTxtview.layer.borderWidth = 1.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
