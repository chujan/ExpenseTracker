//
//  CustomCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 24/04/2024.
//

import UIKit
protocol CustomCollectionViewCellDelegate: AnyObject {
    func searchBarDidChange(text: String?)
}


class CustomCollectionViewCell: UICollectionViewCell {
    weak var delegate: CustomCollectionViewCellDelegate?

    static let identifier = "CustomCollectionViewCell"
    let searchBar: UISearchBar = {
           let searchBar = UISearchBar()
           // Customize search bar properties if needed
           return searchBar
       }()
       
       let button: UIButton = {
           let button = UIButton()
           // Customize button properties if needed
          button.setImage(UIImage(systemName: "lines.measurement.horizontal"), for: .normal)
          button.setTitleColor(.systemIndigo, for: .normal)
           button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
           return button
       }()
       
       // Add subviews and layout constraints
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupViews()
           searchBar.delegate = self
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       private func setupViews() {
           addSubview(searchBar)
           
           addSubview(button)
           searchBar.backgroundImage = UIImage()
           
           // Add constraints for search bar and button
           searchBar.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
               searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 8),
               searchBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
               searchBar.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10),
               searchBar.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 10),
               
           ])
           
           button.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
               button.topAnchor.constraint(equalTo: topAnchor, constant: 8),
               button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
               button.widthAnchor.constraint(equalToConstant: 300)
              
           ])
       }
       
       @objc private func buttonTapped(_ sender: UIButton) {
           if let parentViewController = findParentViewController() as? TransactionViewController {
               parentViewController.navigateToItemList()
           } else {
               
           }
       }
    
    
    private func findParentViewController() -> UIViewController? {
           var responder: UIResponder? = self
           while let nextResponder = responder?.next {
               responder = nextResponder
               if let viewController = responder as? UIViewController {
                   return viewController
               }
           }
           return nil
       }
    
}
extension CustomCollectionViewCell: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.searchBarDidChange(text: searchText)
    }
}
