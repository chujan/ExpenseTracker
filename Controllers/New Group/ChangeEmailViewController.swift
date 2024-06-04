//
//  ChangeEmailViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 15/05/2024.
//

import UIKit

class ChangeEmailViewController: UIViewController {
    
    private var tableView: UITableView = {
            let tableView = UITableView()
        tableView.separatorStyle = .none
       
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()


    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmailTableViewCell.self, forCellReuseIdentifier: EmailTableViewCell.identifier)
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
   
    

}

extension ChangeEmailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EmailTableViewCell.identifier, for: indexPath) as? EmailTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    
    
   
    
    
}


