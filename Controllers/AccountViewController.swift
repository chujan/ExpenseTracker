//
//  AccountViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 09/02/2024.
//

import UIKit
import CoreData
import FirebaseAuth

class AccountViewController: UIViewController {
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return AccountViewController.createSectionLayout(section: sectionIndex)
        
    })
    var currentUser: User?
    private var cell: ProfileCollectionViewCell?
    
    private let tableView: UITableView = {
            let table = UITableView(frame: .zero, style: .insetGrouped)
           table.separatorStyle = .none
            table.translatesAutoresizingMaskIntoConstraints = false
            
            return table
        }()
      
      override func viewDidLoad() {
          super.viewDidLoad()
          tabBarController?.tabBar.isHidden = false
                         // or adjust its appearance
        tabBarController?.tabBar.isTranslucent = false
          
          view.backgroundColor = .systemBackground
        NotificationCenter.default.post(name: .profileImageChanged, object: nil)
               
          view.addSubview(collectionView)
          view.addSubview(tableView)
          setupContraints()
          
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
          collectionView.dataSource =  self
          collectionView.delegate = self
          tableView.dataSource = self
          tableView.delegate = self
          collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
          tableView.register(personTableViewCell.self, forCellReuseIdentifier: personTableViewCell.identifier)
          tableView.register(ChangePasswordTableViewCell.self, forCellReuseIdentifier: ChangePasswordTableViewCell.identifier)
          tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
          tableView.register(LogoutTableViewCell.self, forCellReuseIdentifier: LogoutTableViewCell.identifier)
          tableView.register(DataTableViewCell.self, forCellReuseIdentifier: DataTableViewCell.identifier)
          tableView.register(BackupTableViewCell.self, forCellReuseIdentifier: BackupTableViewCell.identifier)
         
          
         
      }
    
    private func messageButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        let cameraImage = UIImage(systemName: "camera")
        button.setImage(cameraImage, for: .normal)
        button.tintColor = .systemIndigo
        button.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        //button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        return button
    }
    
    private func saveLoginTimestamp() {
            let userDefaults = UserDefaults.standard
            userDefaults.set(Date(), forKey: "loginTimestamp")
            userDefaults.synchronize()
        }
    
    
    private func isSessionValid() -> Bool {
            let userDefaults = UserDefaults.standard
            guard let loginTimestamp = userDefaults.object(forKey: "loginTimestamp") as? Date else {
                return false
            }

            let sessionDuration: TimeInterval = 30 * 60 // 30 minutes
            return Date().timeIntervalSince(loginTimestamp) < sessionDuration
        }

    
    
    
    private func performLogout() {
             
              let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
              
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
              let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { [weak self] (_) in
                 
                  self?.logout()
              }

              alertController.addAction(cancelAction)
              alertController.addAction(logoutAction)

              present(alertController, animated: true, completion: nil)
          }
    
    private func logout() {
        let userDefaults = UserDefaults.standard
               if let appDomain = Bundle.main.bundleIdentifier {
                   userDefaults.removePersistentDomain(forName: appDomain)
               }
               userDefaults.synchronize()

               // Step 2: Clear any cached data (e.g., URL cache)
               URLCache.shared.removeAllCachedResponses()

               // Step 3: Clear Core Data if you are using Core Data
               clearCoreData()
        
           

               // Step 4: Clear any other stored data (like Keychain if used)
               clearKeychainData()

               // Step 5: Securely log out from any backend services (e.g., Firebase)
               secureLogout()

               // Step 6: Navigate to the login screen
               navigateToLoginScreen()
       
    }
    
   

    func clearCoreData() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext

            // Fetch all entities
            let entities = appDelegate.persistentContainer.managedObjectModel.entities
            entities.compactMap({ $0.name }).forEach(clearEntity)
        }
    
    func clearEntity(_ entityName: String) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch let error as NSError {
                print("Could not delete Core Data for entity \(entityName). \(error), \(error.userInfo)")
            }
        }
    
    func clearKeychainData() {
            let secItemClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
            for secItemClass in secItemClasses {
                let dictionary = [kSecClass as String: secItemClass]
                SecItemDelete(dictionary as CFDictionary)
            }
        }

    
    func secureLogout() {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
            }
        }

        func navigateToLoginScreen() {
           
            let loginVC = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginVC)
                   navigationController.isNavigationBarHidden = true
                   UIApplication.shared.windows.first?.rootViewController = navigationController
                   UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    
    
    
    private func setupContraints() {
        
       
        

        NSLayoutConstraint.activate([
            // Table View Constraints
           collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -3),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40), // Adjust the multiplier as needed

            // Collection View Constraints
          tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 5),
           tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
      
    @objc func messageButtonTapped() {
        print("all")
        cell?.showImagePickerOption()
    }
    
    
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
      
        switch section {
            
             case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
       item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
          
            return section
       
       

            
            
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), repeatingSubitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            
            
            return section
        }
    }
    
    
    
    
      
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else {
                return UICollectionViewCell()
            }
            self.cell = cell
            let cameraImage = UIImage(systemName: "camera")
            cell.configure(buttonImage: cameraImage ?? UIImage(), buttonTappedAction: messageButtonTapped)
          
            return cell
            
            
        default:
            return UICollectionViewCell()
        }
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          switch section {
          case 0:
              return 2
          case 1:
              return 3
          default:
              return 0
          }
      }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                switch section {
                case 0:
                    return "Account"
                case 1:
                    return "General"
               
                default:
                    return nil
                }
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: personTableViewCell.identifier, for: indexPath) as? personTableViewCell else {
                    return UITableViewCell()
                   
                }
                cell.accessoryType = .disclosureIndicator
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChangePasswordTableViewCell.identifier, for: indexPath) as? ChangePasswordTableViewCell else {
                    return UITableViewCell()
                   
                }
                cell.accessoryType = .disclosureIndicator
                return cell
                
            }
        case 1:
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else {
                    return UITableViewCell()
                   
                }
                cell.accessoryType = .disclosureIndicator
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier, for: indexPath) as? DataTableViewCell else {
                    return UITableViewCell()
                    
                }
                cell.accessoryType = .disclosureIndicator
                return cell
                
          
                
            } else if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: LogoutTableViewCell.identifier, for: indexPath) as? LogoutTableViewCell else {
                    return UITableViewCell()
                }
                cell.accessoryType = .disclosureIndicator
                return cell
              
            } else {
                return UITableViewCell()
            }
           
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let accountVC = AccountInfoViewController()
                presentPanModal(accountVC)
            } else if indexPath.row == 1 {
                let changeVC = ChangePasswordViewController()
                navigationController?.pushViewController(changeVC, animated: true)
            }
        case 1:
            if indexPath.row == 0 {
                let settingsVC = SettingsViewController()
                navigationController?.pushViewController(settingsVC, animated: true)
            } else if indexPath.row == 1 {
                let dataVC = DataViewController()
                presentPanModal(dataVC)
            } else if indexPath.row == 2 {
                
                performLogout()
            }
            
            
        default:
            break
        }
    }
    
    
}
