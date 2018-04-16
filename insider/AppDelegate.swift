
//
//  AppDelegate.swift
//  insider
//
//  Created by VIJAY on 04/04/18.
//  Copyright © 2018 com.insidrapp.insidr. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var appDeviceToken = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        //print(deviceID)
        UserDefaults.standard.setValue(deviceID, forKey: Constant.DEVICE_TOKEN )
        UserDefaults.standard.synchronize()
        if let loginIN = Constant.USER_DEFAULT.value(forKey: Constant.IS_LOGGED_IN) as? String {
            if loginIN == "0"{
                
            }else if loginIN == "1"{
                createMenubar()
            }
        }
        return true
    }
    func registerForRemoteNotification() {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        appDeviceToken = deviceTokenString
        
        
        
        if (Constant.USER_DEFAULT.value(forKey: Constant.USER_ID) != nil && Constant.USER_DEFAULT.value(forKey:Constant.IS_LOGGED_IN) != nil) {
            if Constant.USER_DEFAULT.object(forKey: Constant.DEVICE_TOKEN) == nil {
                Constant.USER_DEFAULT.set(appDeviceToken, forKey: Constant.DEVICE_TOKEN)
            }else {
                let iStrDeviceToken = Constant.USER_DEFAULT.object(forKey: Constant.DEVICE_TOKEN) as! String
                if iStrDeviceToken != appDeviceToken {
                    // updateDeviceToken()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Device token for push notifications: FAIL -- ")
        print(error.localizedDescription)
    }
    
    /*func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     
     print(userInfo)
     }*/
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let iDictAny:NSDictionary = notification.request.content.userInfo as NSDictionary as! [String: NSObject] as NSDictionary
        print(iDictAny)
        
        completionHandler([.alert, .badge, .sound])
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    func startUp(){
        if let loginIN = Constant.USER_DEFAULT.value(forKey: Constant.IS_LOGGED_IN) as? String {
            
            if loginIN == "0"{
                //
                let navigationController:UINavigationController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "Create_Profile_Nav") as! UINavigationController
                let rootViewController:UITableViewController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "Create_profileVC") as! SG_CreateProfileVC
                navigationController.viewControllers = [rootViewController]
                self.window?.rootViewController = navigationController
                
                
            }else if loginIN == "1"{
                
                /*if (Constant.USER_DEFAULT.value(forKey: Constant.CREATE_CLASS)) as? String == "1" {
                 let navigationController:UINavigationController = Constant.SG_StoryBoard.instantiateInitialViewController() as! UINavigationController
                 let rootViewController:UITableViewController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "Create_profileVC") as! SG_CreateProfileVC
                 let vc = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "ClassVC") as? SG_ClassesVC
                 navigationController.viewControllers = [rootViewController,vc!]
                 
                 navigationController.pushViewController(vc!, animated: true)
                 //self.window?.rootViewController = navigationController
                 
                 }else {
                 let navigationController:UINavigationController = UINavigationController.init()// Constant.SG_StoryBoard.instantiateInitialViewController() as! UINavigationController
                 let rootViewController:UITableViewController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "Create_profileVC") as! SG_CreateProfileVC
                 navigationController.viewControllers = [rootViewController]
                 self.window?.rootViewController = navigationController
                 }*/
                
                self.createMenubar()
                
            }
        }else {
            let navigationController:UINavigationController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "InitialNav") as! UINavigationController
            // let rootViewController:UIViewController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "Login") as! SG_LoginVC
            //navigationController.viewControllers = [rootViewController]
            self.window?.rootViewController = navigationController
        }
    }
    func createMenubar(){
        let mainViewController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let leftViewController = Constant.SG_StoryBoard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController:nvc, rightMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
        
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

