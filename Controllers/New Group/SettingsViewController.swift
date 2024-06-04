//
//  SettingsViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 13/05/2024.
//

import UIKit
import PanModal
class SettingsViewController: UIViewController {
    private var tableView: UITableView = {
            let tableView = UITableView()
        tableView.separatorStyle = .none
       
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SetUpTableViewCell.self, forCellReuseIdentifier: SetUpTableViewCell.identifier)
        tableView.register(AppearanceTableViewCell.self, forCellReuseIdentifier: AppearanceTableViewCell.identifier)
        tableView.register(AboutTableViewCell.self, forCellReuseIdentifier: AboutTableViewCell.identifier)

       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            tableView.frame = view.bounds
        
    }
    
   

   

}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SetUpTableViewCell.identifier, for: indexPath) as?  SetUpTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AppearanceTableViewCell.identifier, for: indexPath) as?  AppearanceTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AboutTableViewCell.identifier, for: indexPath) as?  AboutTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            return cell
            
        default:
            return UITableViewCell()
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let notificationVC = SettingNoteViewController()
                   let navigationController = UINavigationController(rootViewController: notificationVC)
                   navigationController.modalPresentationStyle = .fullScreen
                   present(navigationController, animated: true, completion: nil)

                   // Optionally, you can set a back button
                   let backButton = UIBarButtonItem(
                       image: UIImage(systemName: "chevron.left"),
                       style: .plain,
                       target: self,
                       action: #selector(dismissDetailViewController)
                   )
                   notificationVC.navigationItem.leftBarButtonItem = backButton
        case 1:
          
                let notificationVC = AppearanceViewController()
            presentPanModal(notificationVC)
             
        case 2:
            
                let VC = AboutViewController()
                navigationController?.pushViewController(VC, animated: true)
            
            
        default:
            break
        }
    }

    @objc private func dismissDetailViewController() {
        dismiss(animated: true, completion: nil)
    }


}

extension SettingsViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(500)
    }
}
extension SettingsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Check if the shown view controller is the expected type
        if let homeDetailViewController = viewController as? AccountViewController {
            // Do something with the shown view controller if needed
            print("Did show HomeDetailViewController")
        }
    }
    
    
}



class DataViewController: UIViewController {

    private var tableView: UITableView = {
            let tableView = UITableView()
        tableView.separatorStyle = .none
       
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PrivacyTableViewCell.self, forCellReuseIdentifier: PrivacyTableViewCell.identifier)
        tableView.register(PolicyTableViewCell.self, forCellReuseIdentifier: PolicyTableViewCell.identifier)
       

       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            tableView.frame = view.bounds
        
    }
    
   

   

}
extension DataViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PrivacyTableViewCell.identifier, for: indexPath) as? PrivacyTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PolicyTableViewCell.identifier, for: indexPath) as? PolicyTableViewCell else {
                return UITableViewCell()
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            return UITableViewCell()
        }
       
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc =  ChangeEmailViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)

            // Optionally, you can set a back button
            let backButton = UIBarButtonItem(
                image: UIImage(systemName: "chevron.left"),
                style: .plain,
                target: self,
                action: #selector(dismissDetailViewController)
            )
            vc.navigationItem.leftBarButtonItem = backButton
            
            
        default:
            break
        }
    }
    @objc private func dismissDetailViewController() {
        dismiss(animated: true, completion: nil)
    }
   
   

}

extension DataViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
}
extension DataViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Check if the shown view controller is the expected type
        if let homeDetailViewController = viewController as? AccountViewController {
            // Do something with the shown view controller if needed
            print("Did show HomeDetailViewController")
        }
    }
    
    
}
    


