//
//  YearlyChartCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 07/03/2024.
//

import UIKit
import Charts

class YearlyChartCollectionViewCell: UICollectionViewCell {
    static let identifier = "YearlyChartCollectionViewCell"
    var stackedChartView: BarChartView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChartView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateStackedChartData() {
            // Implement the logic to update the stacked chart data for yearly view
            // Example:
            let entries = (0..<12).map { ChartDataEntry(x: Double($0), y: Double.random(in: 0...50)) }
            let dataSet = LineChartDataSet(entries: entries, label: "Yearly Chart Data")
            let data = LineChartData(dataSet: dataSet)
            stackedChartView.data = data
        }

    private func setupChartView() {
        stackedChartView = BarChartView()
        addSubview(stackedChartView)

        stackedChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackedChartView.topAnchor.constraint(equalTo: topAnchor),
            stackedChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackedChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackedChartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
}
