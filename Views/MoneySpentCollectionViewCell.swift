//
//  MoneySpentCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 09/02/2024.
//

import UIKit

class MoneySpentCollectionViewCell: UICollectionViewCell {
    static let identifier = "MoneySpentCollectionViewCell"
    private let buttonSize: CGFloat = 25.0
    private var totalIncome: Double = 0.0
    
    private let spentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ofLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "Income"
        label.textColor = .yellow
        label.textAlignment = .left
        return label
    }()
    
    private let expenseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "Expense"
        label.textColor = .yellow
        label.textAlignment = .left
        return label
    }()
    
    private let incomeButton: UIButton = {
        let button = UIButton()
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
       // button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.setTitleColor(.systemGreen, for: .normal)
        button.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        // Set upward arrow character (↑) as the button title
        button.setTitle("↑", for: .normal)
        button.layer.cornerRadius = 15
        
        button.addTarget(self, action: #selector(viewButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    private let expenseButton: UIButton = {
        let button = UIButton()
       
      
        button.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.cornerRadius = 15
        
        // Set upward arrow character (↑) as the button title
        button.setTitle("↓",  for: .normal)
        
        button.addTarget(self, action: #selector(expenseButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    @objc private func expenseButtonTapped() {
       
    }
    
    
    


    // Add a property to specify the button size


    @objc private func viewButtonTapped() {
        
         
      }
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private let amountRemainingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let progressView: CircularProgressView = {
        var progressView = CircularProgressView()
        progressView = CircularProgressView(frame: CGRect(x: 50, y: 50, width: 80, height: 90))
        progressView.translatesAutoresizingMaskIntoConstraints = false
       // progressView.progress = 0.55
        return progressView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        progressView.addSubview(progressLabel)
        contentView.addSubview(spentLabel)
        contentView.addSubview(ofLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(incomeButton)
        contentView.addSubview(expenseButton)
        contentView.addSubview(expenseLabel)
        contentView.addSubview(amountRemainingLabel)
        contentView.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.9)
        contentView.layer.cornerRadius = 20
       // contentView.layer.borderWidth = 1.0
        //contentView.layer.borderColor = UIColor.systemBackground.cgColor
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalToConstant: 60),
            progressView.heightAnchor.constraint(equalToConstant: 90),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            progressLabel.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor, constant: -5),
            
            spentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            spentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            spentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -150),
            spentLabel.heightAnchor.constraint(equalToConstant: 20),
            
            amountLabel.topAnchor.constraint(equalTo: ofLabel.bottomAnchor),
            amountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            
            incomeButton.topAnchor.constraint(equalTo: spentLabel.bottomAnchor, constant: 60),
            incomeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            incomeButton.heightAnchor.constraint(equalToConstant: 30),
            incomeButton.widthAnchor.constraint(equalToConstant: 30),
            
            expenseButton.topAnchor.constraint(equalTo: spentLabel.bottomAnchor, constant: 60),
            expenseButton.leadingAnchor.constraint(equalTo: incomeButton.trailingAnchor, constant: 200),
            expenseButton.heightAnchor.constraint(equalToConstant: 30),
            expenseButton.widthAnchor.constraint(equalToConstant: 30),
            
            
            expenseLabel.topAnchor.constraint(equalTo: spentLabel.bottomAnchor, constant: 60),
            expenseLabel.leadingAnchor.constraint(equalTo: expenseButton.trailingAnchor, constant: 10),
          
            amountRemainingLabel.topAnchor.constraint(equalTo: spentLabel.bottomAnchor, constant: 10),
            amountRemainingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
           amountRemainingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -150),
            amountRemainingLabel.heightAnchor.constraint(equalToConstant: 20),
             
           
            ofLabel.topAnchor.constraint(equalTo: spentLabel.bottomAnchor, constant: 60),
            ofLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            ofLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -150),
            ofLabel.heightAnchor.constraint(equalToConstant: 20),
            
            balanceLabel.topAnchor.constraint(equalTo: expenseLabel.bottomAnchor),
            balanceLabel.leadingAnchor.constraint(equalTo: expenseButton.trailingAnchor, constant: 10),
            balanceLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    public func configure(progress: Int, spentTitle: String, ofTitle: String, totalIncome: Double, totalExpense: Double, expense: String, remainingBalance: Double) {
        progressView.progress = CGFloat(progress) / 100

          
           progressLabel.text = "\(progress)%"
        spentLabel.text = spentTitle
        ofLabel.text = ofTitle
        let totalAmount = totalIncome - totalExpense
   
        let nairaAmount = "₦" + String(format: "%.2f", totalIncome)
        amountLabel.text = nairaAmount

        let NairaAmount = "₦" + String(format: "%.2f", totalExpense)
        balanceLabel.text = NairaAmount

        let bairaAmount = "₦" + String(format: "%.2f", totalIncome - totalExpense)
        amountRemainingLabel.text = bairaAmount
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
