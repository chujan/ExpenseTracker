//
//  SceneDelegate.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 08/02/2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let db = Firestore.firestore()
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }

            window = UIWindow(windowScene: windowScene)
            
            if Auth.auth().currentUser != nil {
                saveLoginTimestamp()
                // User is logged in, navigate to main app
                let mainTabBarController = TabBarViewController()
                window?.rootViewController = mainTabBarController
            } else {
                // User is not logged in, show login screen
                let loginVC = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginVC)
                navigationController.isNavigationBarHidden = true
                window?.rootViewController = navigationController
            }
            
            window?.makeKeyAndVisible()
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.ExpenseTracker.updateTimestamp", using: nil) { task in
                    self.handleAppRefresh(task: task as! BGAppRefreshTask)
                }
                
                scheduleAppRefresh()
        }
    
    func saveLoginTimestamp() {
            guard let userID = Auth.auth().currentUser?.uid else { return }

            let timestamp = Timestamp(date: Date())
            let userRef = db.collection("users").document(userID)

            userRef.updateData([
                "lastLogin": timestamp
            ]) { error in
                if let error = error {
                    print("Error updating login timestamp: \(error.localizedDescription)")
                } else {
                    print("Login timestamp successfully updated.")
                }
            }
        }
    
    func scheduleAppRefresh() {
            let request = BGAppRefreshTaskRequest(identifier: "com.ExpenseTracker.updateTimestamp")
            request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 minutes
            
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Unable to submit task: \(error.localizedDescription)")
            }
        }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
            // Schedule the next refresh
            scheduleAppRefresh()
            
            // Perform the actual background refresh
            saveLoginTimestamp()
            
            task.setTaskCompleted(success: true)
        }
        

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

