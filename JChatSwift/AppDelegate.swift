//
//  AppDelegate.swift
//  JChatSwift
//
//  Created by oshumini on 16/2/15.
//  Copyright © 2016年 HXHG. All rights reserved.
//

import UIKit

let JMSSAGE_APPKEY = "5621126402f950b3892e06ed"
let CHANNEL = ""

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    JMessage.setupJMessage(launchOptions, appKey: JMSSAGE_APPKEY, channel: CHANNEL, apsForProduction: false, category: nil)
    if #available(iOS 8, *) {
      // 可以自定义 categories
      JPUSHService.register(
        forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
        UIUserNotificationType.sound.rawValue |
        UIUserNotificationType.alert.rawValue,
        categories: nil)
    } else {
      // ios 8 以前 categories 必须为nil
      JPUSHService.register(
        forRemoteNotificationTypes: UIRemoteNotificationType.badge.rawValue |
        UIRemoteNotificationType.sound.rawValue |
        UIRemoteNotificationType.alert.rawValue,
        categories: nil)
    }
    self.registerJPushStatusNotification()
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.setupRootView()
    self.window?.makeKeyAndVisible()
    return true
  }
  
  func setupRootView() {
    if UserDefaults.standard.object(forKey: kuserName) != nil {
      self.window?.rootViewController = JChatMainTabViewController.sharedInstance
    } else {
      if UserDefaults.standard.object(forKey: klastLoginUserName) != nil {
        let rootVC = JChatAlreadyLoginViewController()
        let rootNV = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNV
      } else {
        let rootVC = JChatLoginViewController()
        let rootNV = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNV
      }
    }
    
    UINavigationBar.appearance().barTintColor = UIColor(netHex: 0x3f80de)
    
    UINavigationBar.appearance().isTranslucent = false  //TODO: ios8
  
    let shadow = NSShadow()
    UINavigationBar.appearance().titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.white,
      NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20),
      NSShadowAttributeName: shadow
    ]

    UINavigationBar.appearance().tintColor = UIColor.white
    
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    JPUSHService.registerDeviceToken(deviceToken)
  }
  
  func registerJPushStatusNotification() {
    let defaultCenter = NotificationCenter.default
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkDidSetup(_:)), name: NSNotification.Name.jpfNetworkDidSetup, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkIsConnecting(_:)), name: NSNotification.Name.jpfNetworkIsConnecting, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkDidClose(_:)), name: NSNotification.Name.jpfNetworkDidClose, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkDidRegister(_:)), name: NSNotification.Name.jpfNetworkDidRegister, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.networkDidLogin(_:)), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
    defaultCenter.addObserver(self, selector: #selector(AppDelegate.receivePushMessage(_:)), name: NSNotification.Name.jpfNetworkDidReceiveMessage, object: nil)
  }
  
  // notification from JPush
  func networkDidSetup(_ notification:Notification) {
    print("Action - networkDidSetup")
  }
  
  // notification from JPush
  func networkIsConnecting(_ notification:Notification) {
    print("Action - networkIsConnecting")
  }
  
  // notification from JPush
  func networkDidClose(_ notification:Notification) {
    print("Action - networkDidClose")
  }
  
  // notification from JPush
  func networkDidRegister(_ notification:Notification) {
    print("Action - networkDidRegister")
  }
  
  // notification from JPush
  func networkDidLogin(_ notification:Notification) {
    print("Action - networkDidLogin")
  }
  // notification from JPush

  func receivePushMessage(_ notification:Notification) {
    print("Action - receivePushMessage")
  }
  
  
  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    application.applicationIconBadgeNumber = 0
    application.cancelAllLocalNotifications()
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }
}

