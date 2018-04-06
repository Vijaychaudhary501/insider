//
//  SG_PostfilterVC.swift
//  Student_GPA
//
//  Created by mac 2 on 19/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_PostfilterVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["All Posts","Photos","Texts"]
    var icon = ["Allpost","Onlyphoto","Onlytext"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK : TABLEVIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostfilterCell", for: indexPath) as! Menubar_Cell
            cell.postfiltericone.image = UIImage(named: icon[indexPath.row])
            cell.postfilterLbl.text = menus[indexPath.row]
            return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"All"])
            self.dismiss(animated: true, completion: nil)
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"photo"])
            self.dismiss(animated: true, completion: nil)
        /*case 2:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"video"])
            self.dismiss(animated: true, completion: nil)*/
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"text"])
            self.dismiss(animated: true, completion: nil)
        default:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchPost"), object: nil, userInfo: ["post":"All"])
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        if indexPath.row == 3{
            cell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
        
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
