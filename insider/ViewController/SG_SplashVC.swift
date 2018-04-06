//
//  SG_SplashVC.swift
//  Student_GPA
//
//  Created by mac 2 on 30/05/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_SplashVC: UIViewController {

    @IBOutlet weak var splashImageView: UIImageView!
    
    @IBOutlet weak var insider: UILabel!
    @IBOutlet weak var school: UILabel!
    
    @IBOutlet weak var classmate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let jeremyGif = UIImage.
        //splashImageView.image = jeremyGif
        //imageView.frame = CGRect(x: 20.0, y: 50.0, width: self.view.frame.size.width - 40, height: 150.0)
        
        // Do any additional setup after loading the view.
        
        //UIView.animate(withDuration:0.0, animations: { () -> Void in
            self.classmate.alpha = 0.0
            self.school.alpha = 0.0
            self.insider.alpha = 0.0
        //})
        /*UIView.animate(withDuration:5.0, animations: { () -> Void in
            self.classmate.alpha = 0.0
            self.school.alpha = 1.0
            self.insider.alpha = 0.0
        })
        UIView.animate(withDuration:10.0, animations: { () -> Void in
            self.classmate.alpha = 0.0
            self.school.alpha = 0.0
            self.insider.alpha = 1.0
        })*/
        self.callFunction()
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(SG_SplashVC.classmatelbl), userInfo: nil, repeats: false)
         _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(SG_SplashVC.schoollbl), userInfo: nil, repeats: false)
         _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(SG_SplashVC.insiderlbl), userInfo: nil, repeats: false)
         _ = Timer.scheduledTimer(timeInterval: 8.0, target: self, selector: #selector(SG_SplashVC.callFunction), userInfo: nil, repeats: false)
    }
    func classmatelbl(){
        self.classmate.alpha = 1.0
    }
    func schoollbl(){
        
        self.classmate.text = "My Schoolmates?"
        //self.school.alpha = 1.0
        //self.insider.alpha = 0.0
    }
    func insiderlbl(){
        self.classmate.text = "I’m IN"
        //self.school.alpha = 0.0
        //self.insider.alpha = 1.0
    }
    
    func callFunction(){
        Constant.appDelegate.startUp()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
