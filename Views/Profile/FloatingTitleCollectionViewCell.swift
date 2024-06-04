//
//  FloatingTitleCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 19/05/2024.
//

import UIKit

class FloatingTitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "FloatingTitleCollectionViewCell"
    
    
    let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Categories"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
        
    }()
    
    private let viewButton: UIButton = {
        let button = UIButton()
       
        
        
        button.setTitleColor(.systemGray, for: .normal)
       
        button.setTitle("View All", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
       
        button.addTarget(self, action: #selector(viewButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    @objc private func viewButtonTapped() {
        if let parentViewController = findParentViewController() as? FloatingViewController {
            parentViewController.navigateToItemList()
        
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        contentView.addSubview(viewButton)
        setUpConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setUpConstraint() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            viewButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            viewButton.trailingAnchor.constraint(equalTo: title.trailingAnchor)
            
        ])
       
    }
    
}
