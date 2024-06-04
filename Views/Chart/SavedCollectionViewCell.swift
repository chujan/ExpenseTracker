//
//  SavedCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 03/05/2024.
//

import UIKit



class SavedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SavedCollectionViewCell"
    
    let statisticsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    let savedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(statisticsImage)
        statisticsImage.addSubview(savedLabel)
        
        // Layout constraints
        statisticsImage.translatesAutoresizingMaskIntoConstraints = false
        savedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statisticsImage.topAnchor.constraint(equalTo: topAnchor),
            statisticsImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            statisticsImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            statisticsImage.heightAnchor.constraint(equalToConstant: 90),
            
            savedLabel.centerXAnchor.constraint(equalTo: statisticsImage.centerXAnchor),
            savedLabel.centerYAnchor.constraint(equalTo: statisticsImage.centerYAnchor),
            savedLabel.leadingAnchor.constraint(equalTo: statisticsImage.leadingAnchor, constant: 8),
            savedLabel.trailingAnchor.constraint(equalTo: statisticsImage.trailingAnchor, constant: -8)
        ])
    }

    func configure(with image: UIImage?, savedAmount: String?) {
        statisticsImage.image = applyMask(to: image)
        savedLabel.text = savedAmount
    }
    
    private func applyMask(to image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        guard let mask = UIImage(named: "maskImage") else { return nil }
        
        let maskRef = mask.cgImage
        let maskCG = CGImage(maskWidth: maskRef!.width,
                             height: maskRef!.height,
                             bitsPerComponent: maskRef!.bitsPerComponent,
                             bitsPerPixel: maskRef!.bitsPerPixel,
                             bytesPerRow: maskRef!.bytesPerRow,
                             provider: maskRef!.dataProvider!,
                             decode: nil,
                             shouldInterpolate: true)
        
        if let maskedCGImage = image.cgImage?.masking(maskCG!) {
            return UIImage(cgImage: maskedCGImage)
        }
        
        return nil
    }
}
