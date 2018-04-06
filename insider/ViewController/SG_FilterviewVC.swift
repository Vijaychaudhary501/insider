//
//  SG_FilterviewVC.swift
//  Student_GPA
//
//  Created by mac 2 on 18/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import UIKit

class SG_FilterviewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var menus = ["Keyword","Class","Major","Book","CRN#","Group Study"]
    var type:String = "Keyword"
    
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
        
        return menus.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 6 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "SearchbtnCell", for: indexPath)
            return cell

        }else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
            cell.textLabel?.text = menus[indexPath.row]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.type = menus[indexPath.row]
        case 1:
            self.type = menus[indexPath.row]
        case 2:
            self.type = menus[indexPath.row]
        case 3:
            self.type = menus[indexPath.row]
        case 4:
            self.type = menus[indexPath.row]
        case 5:
            self.type = menus[indexPath.row]
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        if indexPath.row != 6 {
        let thickness = CGFloat(1)
        let Separator = UIView(frame: CGRect(x:15,y:cell.frame.size.height-thickness,width:cell.frame.size.width-30,height:thickness))
        Separator.backgroundColor = UIColor.white
        cell.addSubview(Separator)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 6 {
            return 60
        }else {
            return 47
        }
    }

    @IBAction func searchBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "searchFilter"), object: nil, userInfo: ["search":self.type])
        self.dismiss(animated: true, completion: nil)
    }
    }
