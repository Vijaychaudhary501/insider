//
//  Utility.swift
//  Student_GPA
//
//  Created by VIJAY on 14/03/18.
//  Copyright © 2018 TestDemo. All rights reserved.
//

import UIKit

class Utility{
    
    class func sharedInstance()->Utility {
        struct Static {
            static let instance = Utility()
        }
        return Static.instance
    }
    func showAlert(iTitleMessage:String,iMessage:String,iButtonTitle:String,iViewController:UIViewController){
            let alert = UIAlertController.init(title: iTitleMessage, message: iMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "ok", style: .cancel, handler: nil))
        iViewController.present(alert, animated: true, completion: nil)
    }
    func setstatusbarColorClear(){
        
    }
    class func trim(str:String)->String{
        return str.trimmingCharacters(in: .whitespaces)
    }
    func setstatusbarColor(){
        
    }
    
    
}
