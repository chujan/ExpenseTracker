//
//  LineProgressView.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 15/04/2024.
//

import UIKit

class LineProgressView: UIView {

    private var percentageLabel: UILabel = {
              let label = UILabel()
              label.textColor = UIColor.black
              label.textAlignment = .right
              label.translatesAutoresizingMaskIntoConstraints = false
              return label
          }()


            
            var progress: CGFloat = 0.5 {
                didSet {
                    setNeedsDisplay()
                }
            }
            
            var progressColor: UIColor = UIColor.red {
                didSet {
                    setNeedsDisplay()
                }
            }
            
            var remainingColor: UIColor = UIColor.systemGray5 {
                didSet {
                    setNeedsDisplay()
                }
            }
            
            var lineWidth: CGFloat = 5.0 {
                didSet {
                    setNeedsDisplay()
                }
            }
            
            var cornerRadius: CGFloat = 5.0 {
                didSet {
                    setNeedsDisplay()
                }
            }
            
            override init(frame: CGRect) {
                super.init(frame: frame)
                commonInit()
            }

            required init?(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)
                commonInit()
            }

            private func commonInit() {
                backgroundColor = UIColor.clear
                addSubview(percentageLabel)
                setupConstraints()
                updatePercentageLabel()
            }
        
        private func setupConstraints() {
                NSLayoutConstraint.activate([
                    percentageLabel.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8),
                    //percentageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
                ])
            }

            private func updatePercentageLabel() {
                let percentage = Int(progress * 100)
                percentageLabel.text = "\(percentage)%"
            }

            override func draw(_ rect: CGRect) {
                super.draw(rect)
                
                guard let context = UIGraphicsGetCurrentContext() else { return }
                
                // Draw remaining space
                context.setStrokeColor(remainingColor.cgColor)
                context.setLineWidth(lineWidth)
                context.setLineCap(.round)
                context.move(to: CGPoint(x: cornerRadius, y: bounds.height / 2))
                context.addLine(to: CGPoint(x: bounds.width - cornerRadius, y: bounds.height / 2))
                context.strokePath()
                
                // Draw progress
                let progressWidth = (bounds.width - 2 * cornerRadius) * progress
                
                context.setStrokeColor(progressColor.cgColor)
                context.setLineWidth(lineWidth)
                context.setLineCap(.round)
                context.move(to: CGPoint(x: cornerRadius, y: bounds.height / 2))
                context.addLine(to: CGPoint(x: cornerRadius + progressWidth, y: bounds.height / 2))
                context.strokePath()
                
                // Add rounded corners
                layer.cornerRadius = cornerRadius
                layer.masksToBounds = true
            }
  

}
