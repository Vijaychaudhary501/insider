//  TableChildExampleViewController.swift
//  XLPagerTabStrip ( https://github.com/xmartlabs/XLPagerTabStrip )
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import XLPagerTabStrip

class TableChildExampleViewController: UITableViewController, IndicatorInfoProvider {
    
    let cellIdentifier = "postCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    var groupStudyArray = [[String:Any]]()
    
    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 140.0;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorStyle = .singleLine
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
        groupStudyAPICall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNotification(_:)), name: NSNotification.Name(rawValue: "createGroup"), object: nil)
        
    }
    // handle notification
    func showNotification(_ notification: NSNotification) {
        
        if let str = notification.userInfo?["group"] as? String {
            if str == "refresh"{
                groupStudyAPICall()
            }
        }
    }

    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupStudyArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PostCell
        cell.lblDate.text = "Date : \(groupStudyArray[indexPath.row]["date"] as! String)"
        cell.lblTime.text = "Time : \(groupStudyArray[indexPath.row]["time"] as! String)"
        cell.lblTitle.text = "\(groupStudyArray[indexPath.row]["title"] as! String)"
        //cell.lblTotalUser.text = "Total User : \(groupStudyArray[indexPath.row]["total_user"] as! Int)"
        if let total:Int = groupStudyArray[indexPath.row]["total_user"] as? Int {
            cell.lblTotalUser.text = "Total User : \(total)"
        }else {
            cell.lblTotalUser.text = "Total User : \(groupStudyArray[indexPath.row]["total_user"] as! String)"
        }
        cell.locationLbl.text = "Location : \(groupStudyArray[indexPath.row]["location"]!)"
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
        
    }
    // MARK: - IndicatorInfoProvider

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func groupStudyAPICall(){
        /*
         "tag":"my_group_study",
         "id":3,
         "token":"2076095124"
         */
        //var dictPostParameter = NSDictionary()
        
        let dictPostParameter = NSDictionary(dictionary:["tag":"my_group_study","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","user_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)"])
        
        print(dictPostParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_GROUPSTUDY, WSParams: dictPostParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictPostData = iData as! NSDictionary
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        print(iData ?? "e")
                        if let grpDetail = iDictPostData.object(forKey: "gs_details") as? NSArray {
                            print(grpDetail)
                            self.groupStudyArray.removeAll()
                            for i in grpDetail{
                                self.groupStudyArray.append(i as! [String : Any])
                            }
                        }
                        //self.grptableView.frame = CGRect(x: 40, y: self.groupStudyView.frame.origin.y, width: self.groupStudyView.frame.size.width, height: self.grptableView.contentSize.height)
                    }else {
                        Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
            
        }
    }

}
