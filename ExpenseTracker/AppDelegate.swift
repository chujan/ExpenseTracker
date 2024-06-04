//
//  AppDelegate.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 08/02/2024.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseMessaging
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    var window: UIWindow?
  

    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "ExpenseTracker")
            container.loadPersistentStores(completionHandler: { (_, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           print("Starting Firebase configuration")
           FirebaseApp.configure()
           print("Firebase configured successfully")

           if let window = self.window {
               let savedStyle = UserDefaults.standard.integer(forKey: "userInterfaceStyle")
               window.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: savedStyle) ?? .unspecified
           }

        let center = UNUserNotificationCenter.current()
                center.delegate = self
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        DispatchQueue.main.async {
                            application.registerForRemoteNotifications()
                        }
                    }
                }
           return true
       }

    func applicationDidEnterBackground(_ application: UIApplication) {
           self.saveContext()
       }
       
       func applicationWillTerminate(_ application: UIApplication) {
           self.saveContext()
       }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.alert, .sound, .badge])
        }

    func applicationDidBecomeActive(_ application: UIApplication) {
           // Reset the badge number when the app becomes active
           application.applicationIconBadgeNumber = 0
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


}

