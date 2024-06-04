//
//  BudgetHeaderCollectionReusableView.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 08/04/2024.
//

import UIKit

class BudgetHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "BudgetHeaderCollectionReusableView"
   
    
    private let label: UILabel = {
              let label = UILabel()
              label.numberOfLines = 1
              label.font = .systemFont(ofSize: 18, weight: .semibold)
              //label.textColor = .black
              return label
          }()
       
       private let viewButton: UIButton = {
           let button = UIButton()
          
           
           
           button.setTitleColor(.systemGray, for: .normal)
          
           button.setTitle("Add New", for: .normal)
          
           button.addTarget(self, action: #selector(viewButtonTapped), for: .touchUpInside)
           button.setContentHuggingPriority(.required, for: .horizontal)
           button.setContentCompressionResistancePriority(.required, for: .horizontal)
           return button
       }()
    
    @objc private func viewButtonTapped() {
         
          if let  parentViewController = findParentViewController() as? BudgetViewController {
            parentViewController.navigateToItemList()
            
            } else {
                
            }
    }

         override init(frame: CGRect) {
             super.init(frame: frame)
             backgroundColor = .systemBackground
             addSubview(label)
             addSubview(viewButton)
         }
    
    required init?(coder: NSCoder) {
              fatalError("init(coder:) has not been implemented")
          }
          
       override func layoutSubviews() {
           super.layoutSubviews()

           label.frame = CGRect(x: 15, y: 0, width: self.frame.width - 30, height: self.frame.height)

           let viewButtonWidth = viewButton.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height)).width
           viewButton.frame = CGRect(
               x: self.frame.width - viewButtonWidth - 15,
               y: 0,
               width: viewButtonWidth,
               height: self.frame.height
           )
       }
    
    func configure(with title: String) {
             label.text = title
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
