//
//  AccountInfoViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 13/05/2024.
//

import UIKit
import PanModal

class AccountInfoViewController: UIViewController {
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
        tableView.register(AccountInfoTableViewCell.self, forCellReuseIdentifier: AccountInfoTableViewCell.identifier)
        tableView.register(EmailInfoTableViewCell.self, forCellReuseIdentifier: EmailInfoTableViewCell.identifier)

       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
            tableView.frame = view.bounds
        
    }
    
   

   

}
extension AccountInfoViewController: UITableViewDelegate, UITableViewDataSource {
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
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountInfoTableViewCell.identifier, for: indexPath) as?  AccountInfoTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier:EmailInfoTableViewCell.identifier, for: indexPath) as? EmailInfoTableViewCell else {
                return UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}


extension AccountInfoViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
}
extension AccountInfoViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Check if the shown view controller is the expected type
        if let homeDetailViewController = viewController as? AccountViewController {
            // Do something with the shown view controller if needed
            print("Did show HomeDetailViewController")
        }
    }
    
    
}



class ChangePasswordViewController: UIViewController {

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
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        setUpConstraints()
        tableView.register(ChangeTableViewCell.self, forCellReuseIdentifier: ChangeTableViewCell.identifier)
           

       
    }
    
 
    
    public func  navigateAnotherItemList() {
        let SignInVC  = SignInViewController()
        navigationController?.pushViewController(SignInVC, animated: true)
    }
    
    private func setUpConstraints() {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    
    
   

   

}
extension ChangePasswordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChangeTableViewCell.identifier, for: indexPath) as? ChangeTableViewCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}


