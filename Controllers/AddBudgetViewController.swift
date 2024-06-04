//
//  AddBudgetViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 08/04/2024.
//

import UIKit
import PanModal


class AddBudgetViewController: UIViewController {
    var userAdded: [budgetAddedItem] = []
    var updateTransactionItems: (([budgetAddedItem]) -> Void)?
    weak var delegate: AddBudgetControllerDelegate?
    var selectedCategories: [String] = []
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
        tableView.register(BudgetTableViewCell.self, forCellReuseIdentifier: BudgetTableViewCell.identifier)
        
        view.backgroundColor = .systemBackground

       
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        }
   
    

}

extension AddBudgetViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BudgetTableViewCell.identifier, for: indexPath) as! BudgetTableViewCell
        
        cell.updateTransactionItems = { [weak self] items, selectedCategory in
            guard let self = self else { return }
            // Check if the selected category is not nil and update UI accordingly
            if let selectedCategory = selectedCategory {
                // Update UI based on the selected category
            }
            self.userAdded = items
            // Call the updateTransactionItems closure to update TransactionViewController
            self.updateTransactionItems?(items)
        }
        return cell

    }
    
    
}

extension AddBudgetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
}
extension AddBudgetViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Check if the shown view controller is the expected type
        if let homeDetailViewController = viewController as?  BudgetViewController {
            // Do something with the shown view controller if needed
            print("Did show HomeDetailViewController")
        }
    }
}
