//
//  DailyChartCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 07/03/2024.
//

import UIKit
import Charts

class DailyChartCollectionViewCell: UICollectionViewCell {
    static let identifier = "DailyChartCollectionViewCell"
    var lineChartView: LineChartView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChartView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLineChartData() {
          // Implement the logic to update the line chart data for daily view
          // Example:
          let entries = (0..<5).map { ChartDataEntry(x: Double($0), y: Double.random(in: 0...50)) }
          let dataSet = LineChartDataSet(entries: entries, label: "Daily Chart Data")
          let data = LineChartData(dataSet: dataSet)
          lineChartView.data = data
      }

    private func setupChartView() {
        lineChartView = LineChartView()
        addSubview(lineChartView)

        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: topAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
