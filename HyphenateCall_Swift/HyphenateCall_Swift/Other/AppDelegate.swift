//
//  AppDelegate.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/4.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let info = FZInfo()
        let options = EMOptions.init(appkey: info.appkey)
        options?.apnsCertName = info.apnsCertName
        options?.usingHttpsOnly = true
        options?.enableConsoleLog = true
        EMClient.shared().initializeSDK(with: options)
        registerRemoteNotification()

        login(username: info.loginUsername, password: info.loginPassword)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let menu = FZMenuController.init(chatter: info.remotrUsername)
        FZHelper.helper.menuVC = menu
        window?.rootViewController = menu
        window?.makeKeyAndVisible()
        
        return true
    }
    
    private func login(username usr: String!, password pwd: String!) {
        EMClient.shared().login(withUsername: usr, password: pwd) { (loginUser, error) in
            if error == nil {
                print("Debug__\(loginUser!)~登录成功")
            } else {
                print("Debug__\(usr)~登录失败，error：\(error?.code)")
            }
        }
    }
    
    func registerRemoteNotification() {
        let application = UIApplication.shared
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
                if granted && (error == nil) {
                    application.registerForRemoteNotifications()
                }
            })
        }
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            application.registerForRemoteNotifications()
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let settings = UIUserNotificationSettings.init(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if EMClient.shared().isLoggedIn {
            EMClient.shared().registerForRemoteNotifications(withDeviceToken: deviceToken, completion: { (error) in
                if error == nil {
                    print("先登录后返回的token，已经绑定成功")
                }
            })
        }
        
        DispatchQueue.global().async {
            EMClient.shared().bindDeviceToken(deviceToken)
        }
        
        print("Debug__\(deviceToken)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        EMClient.shared().application(application, didReceiveRemoteNotification: userInfo)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        EMClient.shared().application(UIApplication.shared, didReceiveRemoteNotification: userInfo)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        EMClient.shared().applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        EMClient.shared().applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

