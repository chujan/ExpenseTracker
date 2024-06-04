//
//  BudgetCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 07/04/2024.
//

import UIKit
import CoreData

class BudgetCollectionViewCell: UICollectionViewCell {
    public let lineProgressView: LineProgressView = {
           let  progressView = LineProgressView()
           progressView.frame = CGRect(x: 10, y: 50, width: 280, height: 120)
           progressView.progress = 0.7
           
           return progressView
       }()
       
       private var progress: Int = 0 {
           didSet {
               // Update the progress bar when the progress value changes
               lineProgressView.progress = CGFloat(progress) / 100.0
           }
       }
   
    static let identifer = "BudgetCollectionViewCell"
  
    var userAddedItems: [UserExpenseItem] = []
    var savedAmount: Double = 0.0
    
   
    
    private let backgroundViewContainer: UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           
           view.layer.cornerRadius = 30
           view.layer.borderWidth = 2.0
           view.layer.borderColor = UIColor.systemGray4.cgColor
           return view
       }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
           imageView.contentMode = .scaleAspectFit
           imageView.tintColor = UIColor.systemIndigo.withAlphaComponent(0.9)
           imageView.layer.masksToBounds = true // Ensure the image stays within the circular boundary

           return imageView
    }()

        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 1
            label.font = .systemFont(ofSize: 17, weight: .light)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let savedAmountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let savedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "Saved"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let budgetLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "budget"
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public  let progressLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    func updateProgress(progress: Int) {
            progressLabel.text = "\(progress)%"
        lineProgressView.progress = CGFloat(progress) / 100.0
        }
        
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }()

        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
          
            contentView.addSubview(backgroundViewContainer)
            contentView.addSubview(lineProgressView)
            contentView.addSubview(progressLabel)
            addSubview(iconImageView)
            addSubview(nameLabel)
            addSubview(savedLabel)
            addSubview(budgetLabel)
            addSubview(amountLabel)
            addSubview(savedAmountLabel)
            contentView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.9)
            contentView.layer.cornerRadius = 20
            //contentView.layer.borderWidth = 1.0
            //contentView.layer.borderColor = UIColor.white.cgColor
            
           
            
            NSLayoutConstraint.activate([
                // Positioning backgroundViewContainer at the top-left corner
                backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                
                // Setting fixed width and height for backgroundViewContainer
                backgroundViewContainer.widthAnchor.constraint(equalToConstant: 60),
                backgroundViewContainer.heightAnchor.constraint(equalToConstant: 60),
                
                // Centering iconImageView within backgroundViewContainer
                iconImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
                iconImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.7),
                iconImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.7),
               
                    progressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
                  progressLabel.trailingAnchor.constraint(equalTo: lineProgressView.trailingAnchor, constant: +50),
                           
                
                nameLabel.topAnchor.constraint(equalTo: backgroundViewContainer.bottomAnchor, constant: 2),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                
                savedLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                savedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -200),
                
                budgetLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
              budgetLabel.leadingAnchor.constraint(equalTo: savedLabel.leadingAnchor, constant: +150),
                
                savedAmountLabel.topAnchor.constraint(equalTo: savedLabel.bottomAnchor),
               savedAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -200),
                
               
                amountLabel.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor),
               amountLabel.leadingAnchor.constraint(equalTo: savedAmountLabel.leadingAnchor, constant: +150),
                
            ])

        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
   
    
 
    
    
    
   
    
        
    func configure(with recent: budgetAddedItem, progress: Int) {
        nameLabel.text = recent.category
        savedLabel.text = "Saved"
        let nairaAmount = "₦" + recent.amount
        amountLabel.text = nairaAmount
        let (iconImage, backgroundColor) = iconImageAndColor(for: recent.category)
        iconImageView.image = iconImage
        iconImageView.tintColor = .systemYellow
        updateProgress(progress: progress)
        backgroundViewContainer.backgroundColor = backgroundColor

        
    }


}


extension BudgetCollectionViewCell {
    func iconImageAndColor(for category: String) -> (UIImage?, UIColor) {
        switch category {
        case "Recurring":
            return (UIImage(systemName: "arrow.triangle.2.circlepath"), UIColor.white)
        case "Grocery":
            return (UIImage(systemName: "cart"), UIColor.white)
        case "Food":
            return (UIImage(systemName: "fork.knife"), UIColor.white)
        case "Shopping":
            return (UIImage(systemName: "bag"), UIColor.white)
        case "Fuel":
            return (UIImage(systemName: "fuelpump"), UIColor.white)
        case "Online":
            return (UIImage(systemName: "globe"), UIColor.white)
        case "Net Banking":
            return (UIImage(systemName: "building.columns"), UIColor.white)
        case "Travels":
            return (UIImage(systemName: "airplane"), UIColor.white)
        case "Sport":
            return (UIImage(systemName: "figure.run"), UIColor.white)
        case "Kids":
            return (UIImage(systemName: "figure.and.child.holdinghands"), UIColor.white)
        case "Cinema":
            return (UIImage(systemName: "film"), UIColor.white)
       
       
       
        default:
            return (UIImage(systemName: "questionmark"), UIColor.white)
        }
    }
}

