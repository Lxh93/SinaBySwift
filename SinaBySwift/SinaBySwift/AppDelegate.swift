//
//  AppDelegate.swift
//  SinaBySwift
//
//  Created by JinShiJinSheng on 2017/12/15.
//  Copyright © 2017年 JinShiJinSheng. All rights reserved.
//

import UIKit

let LXHSwitchRootViewControllerKey = "LXHSwitchRootViewControllerKey"
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenBounds = UIScreen.main.bounds
let screenSize = UIScreen.main.bounds.size
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(NSHomeDirectory())
        NotificationCenter.default.addObserver(self, selector: #selector(switchRootViewController(notification:)), name: NSNotification.Name(rawValue: LXHSwitchRootViewControllerKey), object: nil)
        window = UIWindow(frame:(UIScreen.main.bounds))
        window?.backgroundColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        window?.rootViewController = defaultController()
        window?.makeKeyAndVisible()
        
        return true
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func switchRootViewController(notification:Notification) {
        if notification.object as! Bool {//登陆过但未进入欢迎界面
            window?.rootViewController = LXHWelcomeViewController()
        }else{//未登录
            window?.rootViewController = LXHMainViewController()
        }
    }
    func defaultController()->UIViewController{
       let isLogin = LXHLoginAccount.userLogin()
        if isLogin {
            return hasNewVersion() ? LXHNewfeatureViewController():LXHWelcomeViewController()
        }else{
            return hasNewVersion() ? LXHNewfeatureViewController():LXHMainViewController()
        }
        
    }
    func hasNewVersion()->Bool{
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        let sanboxVersion = UserDefaults.standard.object(forKey: "CFBundleShortVersionString") as? String
//        guard let sanboxVersion = sanboxVersions  else {
//            return true
//        }
        if sanboxVersion == nil {
            
            UserDefaults.standard.set(currentVersion, forKey: "CFBundleShortVersionString")
            
            return true
        }else{
            
            if currentVersion.compare(sanboxVersion!) == ComparisonResult.orderedDescending{//有新版本
                
                UserDefaults.standard.set(currentVersion, forKey: "CFBundleShortVersionString")
                return true
            }else{//没有新版本
                return false
            }
        }

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

