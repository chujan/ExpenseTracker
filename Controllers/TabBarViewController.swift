//
//  TabBarViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 08/02/2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemIndigo
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25 // Half of the button's height and width
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.96)
        
        setUpTabs()
        setupFloatingButton()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustTabBarItemPositions()
    }
    
    private func setUpTabs() {
        let homeVC = HomeViewController()
        let transactionVC = TransactionViewController()
        let budgetVC = BudgetViewController()
        let statisticsVC = StatisticsViewController()
        homeVC.navigationItem.largeTitleDisplayMode = .automatic
        transactionVC.navigationItem.largeTitleDisplayMode = .automatic
        budgetVC.navigationItem.largeTitleDisplayMode = .automatic
        statisticsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: transactionVC)
        let nav3 = UINavigationController(rootViewController: budgetVC)
        let nav4 = UINavigationController(rootViewController: statisticsVC)
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Transaction", image: UIImage(systemName: "arrow.left.arrow.right"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Budget", image: UIImage(systemName: "wallet.pass"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(systemName: "chart.bar"), tag: 4)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
            
        }
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
    }
    
    private func setupFloatingButton() {
        view.addSubview(floatingButton)
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            floatingButton.heightAnchor.constraint(equalToConstant: 50),
            floatingButton.widthAnchor.constraint(equalToConstant: 50),
            floatingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
    }
    
    @objc private func didTapFloatingButton() {
        let notificationVC = FloatingViewController()
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
        
//        let floatingVC = FloatingViewController()
//        floatingVC.modalPresentationStyle = .fullScreen
//        present(floatingVC, animated: true, completion: nil)
//        let backButton = UIBarButtonItem(
//            image: UIImage(systemName: "chevron.left"),
//            style: .plain,
//            target: self,
//            action: #selector(dismissDetailViewController)
//        )
//        floatingVC.navigationItem.leftBarButtonItem = backButton
    }
    @objc private func dismissDetailViewController() {
        dismiss(animated: true, completion: nil)
    }

    private func adjustTabBarItemPositions() {
        guard let tabBarItems = tabBar.items else { return }
        
        // Adjust the position of the second tab bar item to the left
        tabBarItems[1].titlePositionAdjustment = UIOffset(horizontal: -20, vertical: 0)
        
        // Adjust the position of the third tab bar item to the right
        tabBarItems[2].titlePositionAdjustment = UIOffset(horizontal: 20, vertical: 0)
    }
}
