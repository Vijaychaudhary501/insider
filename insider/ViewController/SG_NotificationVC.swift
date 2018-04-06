//
//  SG_NotificationVC.swift
//  Student_GPA
//
//  Created by mac 2 on 18/04/17.
//  Copyright © 2017 KalpCorporate. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class SG_NotificationVC:  UITableViewController, IndicatorInfoProvider {
    
    let cellIdentifier = "postCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    var notificationDataArray = [SG_NOTIFICATION_DATA]()
    var notiPage:Int = 0
    var notiEmpty = false
    //var refreshControl = UIRefreshControl()
    let indicator = UIActivityIndicatorView()
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        indicator.frame = CGRect(x: self.view.frame.width / 2 - 45, y: self.view.frame.height-120, width: 90, height: 90)
        indicator.color = UIColor.darkGray
    }
    

    
    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 140.0;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorStyle = .singleLine
        if blackTheme {
            tableView.backgroundColor = UIColor(red: 15/255.0, green: 16/255.0, blue: 16/255.0, alpha: 1.0)
        }
//        let notificationNib = UINib(nibName: Constant.NOTIFICATION_NIBNAME, bundle: nil)
//        self.tableView.register(notificationNib, forCellReuseIdentifier: Constant.NOTIFICATION_CELLID)
        self.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        //self.tableView?.addSubview(refreshControl!)
        self.view.addSubview(indicator)
        self.notificationServiceCall(page: 0)
    }
    @objc func refresh(_ sender:AnyObject)
    {
        self.notificationServiceCall(page:0)
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        
    }
    // handle notification
    func showNotification(_ notification: NSNotification) {
        
        
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationDataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        if self.notificationDataArray[indexPath.row].photo == "" {
            
        }else {
           // cell.notificaionImage.imageURL = NSURL(string: (self.notificationDataArray[indexPath.row].photo)) as URL!
        }
        cell.userNameLbl.text = notificationDataArray[indexPath.row].notification_text
        cell.timeLbl.textColor = UIColor.init(hexString: "21409a")
        cell.timeLbl.text = notificationDataArray[indexPath.row].created_date
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if indexPath.row == notificationDataArray.count {
            if !notiEmpty {
                indicator.startAnimating()
                notiPage = notiPage + 1
                self.notificationServiceCall(page: notiPage)
            }
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    //MARK:WEB SERVICES
    func notificationServiceCall(page:Int){
        /*
         "tag":"get_notification_list",
         "id":3,
         "school_id":1,
         "page":1,
         "token":"2076095124"
         
         */
        
        let dictNotiParameter = NSDictionary.init()
            /*NSDictionary(dictionary: ["tag":"get_notification_list","school_id":"\(Constant.USER_DEFAULT.value(forKey: Constant.SCHOOL_ID)!)","id":"\(Constant.USER_DEFAULT.value(forKey: Constant.USER_ID)!)","token":"\(Constant.USER_DEFAULT.value(forKey: Constant.ACCESS_TOKEN)!)","page":"\(page)"])*/
        
        print(dictNotiParameter)
        WebServiceManager.callGeneralWebService(WSUrl: Constant.WS_NOTIFICATION, WSParams: dictNotiParameter, WSMethod: .post, isLoader: true) { (iData, iError) in
            
            if iError != nil {
                print(iError?.localizedDescription ?? "")
            }else {
                let iDictNotiData = iData as! NSDictionary
                if let iIntSuccess = iData?.object(forKey: Constant.SUCCESS) as? NSNumber
                {
                    if iIntSuccess == 1 {
                        print(iData ?? "e")
                        
                        if let notiDetail = iDictNotiData.object(forKey: "data") as? NSDictionary {
                            if let record = notiDetail.object(forKey: "records") as? NSArray{
                                //self.notificationDataArray.removeAll()
                                for i in record {
                                    let notidataModel = SG_NOTIFICATION_DATA(fromDictionary: (i) as! [String : Any])
                                    self.notificationDataArray.append(notidataModel)
                                }
                            }
                        }
                        self.indicator.stopAnimating()
                        self.tableView.reloadData()
                        
                    }else {
                        self.notiEmpty = true
                        self.indicator.stopAnimating()
                        //Utility.sharedInstance().showAlert(iTitleMessage: "", iMessage: iData?.object(forKey: Constant.MESSAGE) as! String, iButtonTitle: "ok", iViewController: self)
                    }
                }
            }
            
        }
    }

    
}
