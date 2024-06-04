//
//  AddIncomeViewController.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 28/02/2024.
//

import UIKit
import CoreData
enum section: Int, CaseIterable {

  
    case  Recentexpenses = 1
    case Categories = 0
}

class AddIncomeViewController: UIViewController, UITextViewDelegate {
    weak var delegate: AddIncomeViewControllerDelegate?
    private var tableView: UITableView = {
            let tableView = UITableView()
        tableView.separatorStyle = .none
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
        }()
        
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in return AddIncomeViewController.createSectionLayout(section: sectionIndex)
        
    })
    
   
    
    var  categories: [IncomeCategory] = [
            IncomeCategory(name: "Salary", icon: "briefcase"),
            IncomeCategory(name: "FreeLance", icon: "laptopcomputer"),
            IncomeCategory(name: "Business", icon: "building.columns"),
            IncomeCategory(name: "Gift", icon: "gift"),
            IncomeCategory(name: "Alimony", icon: "figure.2.and.child.holdinghands"),
            IncomeCategory(name: "Dividend", icon: "chart.line.uptrend.xyaxis"),
            IncomeCategory(name: "Royalties", icon: "music.note"),
            IncomeCategory(name: "Rental", icon: "house"),
            IncomeCategory(name: "Grants", icon: "graduationcap"),
            IncomeCategory(name: "Bonuses", icon: "dollarsign"),
           
            
            ]
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }()
   
    var AddedItems: [UserIncomeItem] = []
    var updateTransactionItems: (( [UserIncomeItem]) -> Void)?
    var selectedCategory: String? {
        didSet {
          
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
                       // or adjust its appearance
      tabBarController?.tabBar.isTranslucent = false
        
     
        view.backgroundColor = .systemBackground
        view .addSubview( tableView)
       
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        setupContraints()
       collectionView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(IncomeEntryTableViewCell.self, forCellReuseIdentifier: IncomeEntryTableViewCell.identifier)
        collectionView.register(IncomeCategoryCollectionViewCell.self, forCellWithReuseIdentifier: IncomeCategoryCollectionViewCell.identifier)
        collectionView.register(AddIncomeCollectionViewCell.self, forCellWithReuseIdentifier: AddIncomeCollectionViewCell.identifier)
        collectionView.register(IncomeAddedCollectionViewCell.self, forCellWithReuseIdentifier: IncomeAddedCollectionViewCell.identifier)
        collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "EmptyHeader")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
      
        
        
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


   
    public func navigateToItemList() {
        let itemListViewController = TotalIncomeViewController(categories: categories)
        presentPanModal(itemListViewController)
        
    }

    
  
            
         
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
        let supplementaryViews = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)]
        
        switch section {
            
       
            
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
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

extension AddIncomeViewController: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IncomeEntryTableViewCell.identifier, for: indexPath) as? IncomeEntryTableViewCell else {
            return UITableViewCell()
        }
        cell.updateTransactionItems = { [weak self] items in
            // Update the items in AddViewController
            self?.AddedItems = items
            
            // Call the updateTransactionItems closure to update TransactionViewController
            self?.updateTransactionItems?(items)
        }
        return cell
        
    }
    
}
extension AddIncomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddIncomeCollectionViewCell.identifier, for: indexPath) as? AddIncomeCollectionViewCell else {
                      return UICollectionViewCell()
                  }

                  // Here, set the incomeEntryCell property
                  if let incomeEntryCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? IncomeEntryTableViewCell {
                      cell.incomeEntryCell = incomeEntryCell
                  } else {
                      print("Error: Unable to set incomeEntryCell. IncomeEntryTableViewCell not found.")
                  }

                  cell.amountTextField.delegate = cell
                  cell.categoryTextField.delegate = cell
                  cell.itemTextField.delegate = cell
                  cell.dateTextField.delegate = cell

                  cell.updateTransactionItems = { [weak self] items in
                      self?.AddedItems = items
                      self?.updateTransactionItems?(items)
                  }

                  return cell
        default:
            return UICollectionViewCell()
        }
       
        
    }
    
  
}

        
