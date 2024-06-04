//
//  AddExpenseViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 05/03/2024.
//

import UIKit

class AddExpenseViewController: UIViewController, UITableViewDelegate {
    weak var delegate: AddExpenseViewControllerDelegate?
    var userAddedItems: [UserExpenseItem] = []
    var updateTransactionItems: (([UserExpenseItem]) -> Void)?
    var selectedCategory: String?
    
    private var tableView: UITableView = {
            let tableView = UITableView()
        tableView.separatorStyle = .none
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return AddExpenseViewController.createSectionLayout(section: sectionIndex)
        
    })
    
    var  categories: [ExpenseCategory] = [
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
    
    
    
            

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.backgroundColor = .systemBackground
        view .addSubview( tableView)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        setupContraints()
        tableView.register(ExpenseEntryTableViewCell.self, forCellReuseIdentifier: ExpenseEntryTableViewCell.identifier)
        collectionView.register(ExpenseCategoryCollectionViewCell.self, forCellWithReuseIdentifier: ExpenseCategoryCollectionViewCell.identifier)
        collectionView.register(AddExpenseCollectionViewCell.self, forCellWithReuseIdentifier: AddExpenseCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeader")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
      

       
    }
    
    func setCategory(_ category: String) {
          selectedCategory = category
      }
    public func navigateToItemList() {
        let itemListViewController = TotalExpenseViewController(categories: categories)
        presentPanModal(itemListViewController)
        
    }
    
    private func setupContraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            // Table View Constraints
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.60), // Adjust the multiplier as needed
            
            // Collection View Constraints
            collectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }

    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        
        switch section {
        
            
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.8)))
            item.contentInsets = NSDirectionalEdgeInsets(top: -12, leading: 15, bottom: 0, trailing: 15)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120)), repeatingSubitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            
          
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

extension AddExpenseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddExpenseCollectionViewCell.identifier, for: indexPath) as? AddExpenseCollectionViewCell else {
                      return UICollectionViewCell()
                  }

                  // Here, set the incomeEntryCell property
                  if let incomeEntryCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ExpenseEntryTableViewCell {
                      cell.expenseEntryCell = incomeEntryCell
                  } else {
                      print("Error: Unable to set incomeEntryCell. IncomeEntryTableViewCell not found.")
                  }

                  cell.amountTextField.delegate = cell
                  cell.categoryTextField.delegate = cell
                  cell.itemTextField.delegate = cell
                  cell.dateTextField.delegate = cell

                  cell.updateTransactionItems = { [weak self] items in
                      self?.userAddedItems = items
                      self?.updateTransactionItems?(items)
                  }

                  return cell
        default:
            return UICollectionViewCell()
        }
       
    }
    
    
    
    
}

extension AddExpenseViewController: UITextViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 
    }
    
   
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseEntryTableViewCell.identifier, for: indexPath) as? ExpenseEntryTableViewCell else {
                return UITableViewCell()
            }
            cell.selectedCategories = ["Category"]
            cell.updateTransactionItems = { [weak self] items in
                // Update the items in AddViewController
                self?.userAddedItems = items
                cell.amountTextField.delegate = cell
                cell.categoryTextField.delegate = cell
                cell.itemTextField.delegate = cell
                cell.dateTextField.delegate = cell

               
                
                // Call the updateTransactionItems closure to update TransactionViewController
                self?.updateTransactionItems?(items)
            }
            return cell
            
        }
   
    }
    
    

