//
//  AppDelegate.swift
//  fastgi
//
//  Created by Hegaro on 04/11/2020.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let storage = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //notifications
    func registerForPushNotifications() {
      //1
      UNUserNotificationCenter.current()
        //2
        .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
          }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        //registro APN
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
       
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let tokenDevice = tokenParts.joined()
      print("Device Token: \(tokenDevice)")
        storage.removeObject(forKey: "tokenDevice")
        storage.setValue(tokenDevice, forKey: "tokenDevice")
    
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }

   /* func application(
      _ application: UIApplication,
      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
      fetchCompletionHandler completionHandler:
      @escaping (UIBackgroundFetchResult) -> Void
    ) {
      guard let aps = userInfo["aps"] as? [String: AnyObject] else {
        completionHandler(.failed)
        return
      }
      NewsItem.makeNewsItem(aps)
    }*/
    
    /*extension AppDelegate: UNUserNotificationCenterDelegate {
      func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
      ) {
        // 1
        let userInfo = response.notification.request.content.userInfo
        
        // 2
        if
          let aps = userInfo["aps"] as? [String: AnyObject],
          let newsItem = NewsItem.makeNewsItem(aps) {
          (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
          
          // 3
          if response.actionIdentifier == Identifiers.viewAction,
            let url = URL(string: newsItem.link) {
            let safari = SFSafariViewController(url: url)
            window?.rootViewController?
              .present(safari, animated: true, completion: nil)
          }
        }
        
        // 4
        completionHandler()
      }
    }*/
    
}
