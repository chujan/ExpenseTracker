//
//  AddedDetailsViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 25/02/2024.
//

import UIKit

class AddedDetailsViewController: UIViewController {
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return AddedDetailsViewController.createSectionLayout(section: sectionIndex)
        
    })
    var selectedCategory: String?
   
   
    private func messageButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        
        
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.tintColor = .systemGray2
        button.setTitle("Message", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(messageButtonTapped), for: .touchUpInside)
        return button
    }
    
   


       init(userAddedItems: [UserExpenseItem], categories: [ExpenseCategory]) {
           self.userAddedItems = userAddedItems
           self.categories = categories
           super.init(nibName: nil, bundle: nil)
       }

    var categories: [ExpenseCategory] = [
        ExpenseCategory(name: "Recurring", icon: "arrow.triangle.2.circlepath"),
        ExpenseCategory(name: "Grocery", icon: "house"),
        ExpenseCategory(name: "Gadgets", icon: "oven"),
        ExpenseCategory(name: "Fuel", icon: "fuelpump"),
        ExpenseCategory(name: "Online", icon: "globe"),
        ExpenseCategory(name: "Shopping", icon: "bag"),
        ExpenseCategory(name: "Net Banking", icon: "building.columns"),
        ExpenseCategory(name: "Food", icon: "fork.knife"),
        ExpenseCategory(name: "Travels", icon: "airplane"),
        ExpenseCategory(name: "Sport", icon: "figure.run"),
        ExpenseCategory(name: "Kids", icon: "figure.and.child.holdinghands"),
        ExpenseCategory(name: "Cinema", icon: "film")
    ]

    func totalAmount(for category: String) -> Double {
        let filteredItems = userAddedItems.filter { $0.category == category }
        let totalAmount = filteredItems.reduce(0.0) { $0 + Double($1.amount)! }
        return totalAmount
    }

    lazy var totalAmountForSection0: Double = {
        let totalAmount = categories.reduce(0.0) { (total, category) in
            let amount = self.totalAmount(for: category.name)
            print("Category: \(category.name), Amount: \(amount)")
            return total + amount
        }
        print("Total Amount for Section 0: \(totalAmount)")
        return totalAmount
    }()

    
    
  
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
      
        switch section {
            
             case 0:
                 let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
                 let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90)), repeatingSubitem: item, count: 1)
                 let section = NSCollectionLayoutSection(group: group)
               
                 return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(0.7))
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 2, trailing: 2)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            return section
            
       
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
            item.contentInsets = NSDirectionalEdgeInsets(top: +5, leading: 15, bottom: 0, trailing: 15)
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
    
    
    
    
    
   
    var userAddedItems: [UserExpenseItem] = []
    init(userAddedItems: [UserExpenseItem]) {
            self.userAddedItems = userAddedItems
            super.init(nibName: nil, bundle: nil)
           
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(AddedCategoryCollectionViewCell.self, forCellWithReuseIdentifier: AddedCategoryCollectionViewCell.identifier)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collectionView.register(CategoryAddedCollectionViewCell.self, forCellWithReuseIdentifier: CategoryAddedCollectionViewCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
       
       
      
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
          collectionView.frame = view.bounds
        }
    
 
    @objc func messageButtonTapped() {
        guard let selectedCategory = selectedCategory else {
            // Handle the case where no category is selected
            return
        }

        // Filter userAddedItems for the selected category
        let userAddedItemsForSelectedCategory = userAddedItems.filter { $0.category == selectedCategory }

        // Create a dictionary to hold only the selected category and its total amount
        var categoryTotalAmounts: [String: Double] = [:]
        let totalAmount = self.totalAmount(for: selectedCategory)
        categoryTotalAmounts[selectedCategory] = totalAmount

        // Create an instance of MessageViewController
        let vc = MessageViewController(categoryTotalAmounts: categoryTotalAmounts, userAddedItems: userAddedItemsForSelectedCategory)

        // Pass the selected category to the MessageViewController
        vc.selectedCategory = selectedCategory

        // Push the MessageViewController onto the navigation stack
        navigationController?.pushViewController(vc, animated: true)
    }


   

}
extension AddedDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return userAddedItems.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
      
      
       
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddedCategoryCollectionViewCell.identifier, for: indexPath) as? AddedCategoryCollectionViewCell else {
                return UICollectionViewCell()
            }

            // Use the selectedCategory property to get the correct category
            if let selectedCategory = selectedCategory {
                cell.configure(categoryTotalAmount: totalAmountForSection0, categoryName: selectedCategory, categories: categories)
            }
            return cell


            
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as! TitleCollectionViewCell
            cell.configure(buttonTitle: "Messages", buttonTappedAction: (messageButtonTapped))
                        return cell
        case 2:
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryAddedCollectionViewCell.identifier, for: indexPath) as? CategoryAddedCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = userAddedItems[indexPath.item]
            cell.configure(with: viewModel)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Assuming indexPath.section corresponds to category selection
        if indexPath.section == 0 {
            // Retrieve the selected category from your categories array
            selectedCategory = categories[indexPath.item].name
            // Reload the collection view to reflect the updated selected category
            collectionView.reloadData()
        }
    }
    
    
}

