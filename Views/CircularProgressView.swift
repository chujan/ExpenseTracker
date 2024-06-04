//
//  CircularProgressView.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 09/02/2024.
//

import Foundation
import UIKit

class CircularProgressView: UIView {
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        createTrackLayer()
        createProgressLayer()
        updateColors()
    }
    
    private func createTrackLayer() {
        trackLayer.lineWidth = 6
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)
    }
    
    private func createProgressLayer() {
        progressLayer.lineWidth = 8
        progressLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(progressLayer)
    }
    
    private func updateColors() {
        progressLayer.strokeColor = UIColor.yellow.cgColor
        trackLayer.strokeColor = UIColor.systemGray.cgColor
    }
    
    private func updateProgress() {
        let startAngle: CGFloat = -CGFloat.pi / 2
        let endAngle = startAngle + (2 * CGFloat.pi * progress)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = (min(bounds.width, bounds.height) - progressLayer.lineWidth) / 2
        
        // Create a full circle path for the track
        let trackPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.path = trackPath.cgPath
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = progressPath.cgPath
    }
}

            
