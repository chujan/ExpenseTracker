//
//  WeeklyChartCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 07/03/2024.
//

import UIKit
import Charts

class WeeklyChartCollectionViewCell: UICollectionViewCell {
    static let identifier = "WeeklyChartCollectionViewCell"
    var areaChartView: LineChartView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChartView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAreaChartData() {
           // Implement the logic to update the area chart data for weekly view
           // Example:
           let entries = (0..<7).map { ChartDataEntry(x: Double($0), y: Double.random(in: 0...50)) }
           let dataSet = LineChartDataSet(entries: entries, label: "Weekly Chart Data")
           let data = LineChartData(dataSet: dataSet)
           areaChartView.data = data
       }

    private func setupChartView() {
        areaChartView = LineChartView()
        addSubview(areaChartView)

        areaChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            areaChartView.topAnchor.constraint(equalTo: topAnchor),
            areaChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            areaChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            areaChartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    
}
