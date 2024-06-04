//
//  FloatingCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 19/05/2024.
//

import UIKit

class FloatingCollectionViewCell: UICollectionViewCell {
    static let idenrifier = "FloatingCollectionViewCell"
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemMint.withAlphaComponent(0.1)
        return view
    }()
    
    let floatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
      
        return imageView
    }()
    

    
    let selectLabel : UILabel = {
        let label = UILabel()
        label.text = "Select Transaction Type"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
        
    }()
    
    let incomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Income"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(selectLabel)
        contentView.addSubview(backgroundViewContainer)
        contentView.addSubview(incomeLabel)
        floatingImageView.tintColor = .systemIndigo
        floatingImageView.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        backgroundViewContainer.addSubview(floatingImageView)
        backgroundViewContainer.layer.cornerRadius = 15
        setUpContraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContraint() {
        NSLayoutConstraint.activate([
            selectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            selectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            selectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            backgroundViewContainer.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 30),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
            
           floatingImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
            floatingImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
           floatingImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
            floatingImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
            
            incomeLabel.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 40),
           incomeLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 20),
            
           
            
        ])
    }
    
    
    
}


class ExpenseFloCollectionViewCell: UICollectionViewCell {
    static let idenrifier = "ExpenseFloCollectionViewCell"
    
    private let backgroundViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemIndigo
        return view
    }()
    
    let floatingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
      
        return imageView
    }()
    

    
    
    
    let incomeLabel : UILabel = {
        let label = UILabel()
        label.text = "Expense"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        contentView.addSubview(backgroundViewContainer)
        contentView.addSubview(incomeLabel)
        floatingImageView.tintColor = .white
        floatingImageView.image = UIImage(systemName: "chart.line.downtrend.xyaxis")
        backgroundViewContainer.addSubview(floatingImageView)
        backgroundViewContainer.layer.cornerRadius = 15
        setUpContraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContraint() {
        NSLayoutConstraint.activate([
            
            
            backgroundViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backgroundViewContainer.heightAnchor.constraint(equalToConstant: 50),
            backgroundViewContainer.widthAnchor.constraint(equalToConstant: 50),
            
           floatingImageView.centerXAnchor.constraint(equalTo: backgroundViewContainer.centerXAnchor),
            floatingImageView.centerYAnchor.constraint(equalTo: backgroundViewContainer.centerYAnchor),
           floatingImageView.widthAnchor.constraint(equalTo: backgroundViewContainer.widthAnchor, multiplier: 0.4),
            floatingImageView.heightAnchor.constraint(equalTo: backgroundViewContainer.heightAnchor, multiplier: 0.4),
            
            incomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
           incomeLabel.leadingAnchor.constraint(equalTo: backgroundViewContainer.trailingAnchor, constant: 20),
            
           
            
        ])
    }
    
    
    
}
