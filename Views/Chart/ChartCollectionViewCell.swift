//
//  ChartCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Jennifer Chukwuemeka on 07/03/2024.
//




import UIKit
import Charts
import CoreData


class ChartCollectionViewCell: UICollectionViewCell {
    
       
    static let identifier = "ChartCollectionViewCell"
    
    let incomeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let expenseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let expenseTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Expense:"
      
        label.textAlignment = .left
        return label
    }()
    
    private let incomeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "Income:"
        
        label.textAlignment = .left
        return label
    }()


    var lineChartView: LineChartView!
    var areaChartView: BarChartView!
    var candlestickChartView:  LineChartView!
    var monthlyChartView:  BarChartView!
    lazy var managedObjectContext: NSManagedObjectContext = {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }()

    override init(frame: CGRect) {
        super.init(frame: frame)
       
     
        contentView.backgroundColor = .secondarySystemBackground
        
        //contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 20
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: -4, height: -4)
       
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(incomeLabel)
        contentView.addSubview(expenseLabel)
        contentView.addSubview(expenseTitleLabel)
        contentView.addSubview(incomeTitleLabel)
        contentView.addSubview(dateLabel)
        

        lineChartView = LineChartView(frame: contentView.bounds)
        // Customize lineChartView as needed
        contentView.addSubview(lineChartView)

        // Create and configure the area chart view
        areaChartView = BarChartView(frame: contentView.bounds)
        // Customize areaChartView as needed
        areaChartView.isHidden = true
        contentView.addSubview(areaChartView)

        // Create and configure the stacked chart view
        candlestickChartView = LineChartView(frame: contentView.bounds)
        candlestickChartView.isHidden = true
              contentView.addSubview(candlestickChartView)
        
        monthlyChartView = BarChartView(frame: contentView.bounds)
           // Customize monthlyChartView as needed
           monthlyChartView.isHidden = true
           contentView.addSubview(monthlyChartView)
        setupContraint()
    }
    
    public func configureTodayDateLabel() {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat =  "EEEE, d MMM yyyy"
           let currentDate = dateFormatter.string(from: Date())
           dateLabel.text = currentDate
           dateLabel.textColor = .systemGray2
           // You can customize the label further if needed
           // For example, you can set a specific font, size, or apply other styling
           dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
       }
    
    public func configureMonthlyDateLabel() {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat =  "MMM yyyy"
           let currentDate = dateFormatter.string(from: Date())
           dateLabel.text = currentDate
           dateLabel.textColor = .systemGray2
           // You can customize the label further if needed
           // For example, you can set a specific font, size, or apply other styling
           dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
       }
    
    private func configureWeekDateLabel() {
        let currentDate = Date()
        let calendar = Calendar.current

        // Get the start date of the current week
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else {
            return
        }

        // Get the end date of the current week
        guard let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek) else {
            return
        }

        updateDateLabel(startOfWeek: startOfWeek, endOfWeek: endOfWeek)
    }

    private func updateDateLabel(startOfWeek: Date, endOfWeek: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM, yyyy" // Format as Month Day
        let startDateString = dateFormatter.string(from: startOfWeek)
        let endDateString = dateFormatter.string(from: endOfWeek)

        dateLabel.text = "\(startDateString) - \(endDateString)"
        dateLabel.textColor = .systemGray2
        // You can customize the label further if needed
        // For example, you can set a specific font, size, or apply other styling
        dateLabel.font = UIFont.boldSystemFont(ofSize: 16)
    }

    
    private func setupContraint() {
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -30),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: +15),
           
            incomeLabel.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 8),
           
            incomeLabel.trailingAnchor.constraint(equalTo: incomeTitleLabel.trailingAnchor, constant: +120),
            
            expenseLabel.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 8),
            expenseLabel.leadingAnchor.constraint(equalTo: expenseTitleLabel.centerXAnchor),
            expenseLabel.trailingAnchor.constraint(equalTo:expenseTitleLabel.trailingAnchor, constant: -5),
            
           expenseTitleLabel.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 8),
            
           
            expenseTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
           incomeTitleLabel.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 8),
           incomeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
           
            
        ])
    }






    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateChartData(category: String) {
        // Hide all charts initially
        lineChartView.isHidden = true
        areaChartView.isHidden = true
        candlestickChartView.isHidden = true
        monthlyChartView.isHidden = true

        switch category {
        case "Daily":
            // Update line chart data for daily view
            lineChartView.isHidden = false
            updateLineChartDataForDaily()
            updateExpenseLabelForDaily()
            updateIncomeLabelForDaily()
            configureTodayDateLabel()
        case "Weekly":
            // Update area chart data for weekly view
           candlestickChartView.isHidden = false
            updateAreaChartDataForWeekly()
            updateExpenseLabelForWeekly()
            configureWeekDateLabel()
        case "Yearly":
            // Update stacked chart data for yearly view
           areaChartView.isHidden = false
            updateCandlestickChartDataForYearly()
            updateExpenseLabelForYearly()
            updateIncomeLabelForYearly()
            
        case "Monthly":
              // Update bar chart data for monthly view
              monthlyChartView.isHidden = false
            updateDropletChartDataForMonthly()
            updateExpenseLabelForMonthly()
            updateIncomeLabelForMonthly()
           
            
            configureMonthlyDateLabel()
          
            
        default:
            break
        }
       
    }
    
    private func updateExpenseLabelForDaily() {
        // Calculate the date range for today
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Fetch expenses within the date range
        let totalExpense = fetchTotalExpenseAmount(startDate: startOfDay, endDate: endOfDay)
        
        // Update expense label with the total expense for today
        expenseLabel.text = "\(totalExpense)"
    }
    
    private func updateIncomeLabelForYearly() {
        // Calculate the date range for the current year
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfYear = calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year], from: currentDate))!)
        let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear)!
        
        // Fetch income within the date range
        let totalIncome = fetchTotalIncomeAmount(startDate: startOfYear, endDate: endOfYear)
        
        
        // Update income label with the total income for this year
        incomeLabel.text = " \(totalIncome)"
    }
    
    
    private func updateIncomeLabelForDaily() {
        // Calculate the date range for today
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // Fetch expenses within the date range
        let totalExpense = fetchTotalIncomeAmount(startDate: startOfDay, endDate: endOfDay)
        
        // Update expense label with the total expense for today
       incomeLabel.text = "\(totalExpense)"
    }
    
    private func updateExpenseLabelForWeekly() {
        // Calculate the date range for the current week
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!
        let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
        
        // Fetch expenses within the date range
        let totalExpense = fetchTotalExpenseAmount(startDate: startOfWeek, endDate: endOfWeek)
        
        // Update expense label with the total expense for this week
        expenseLabel.text = " \(totalExpense)"
    }
    
    private func updateIncomeLabelForMonthly() {
        // Calculate the date range for the current month
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        // Fetch income within the date range
        let totalIncome = fetchTotalIncomeAmount(startDate: startOfMonth, endDate: endOfMonth)
        
        // Update income label with the total income for this month
        incomeLabel.text = " \(totalIncome)"
    }
    
    private func updateExpenseLabelForYearly() {
        // Calculate the date range for the current year
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfYear = calendar.startOfDay(for: calendar.date(from: calendar.dateComponents([.year], from: currentDate))!)
        let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear)!
        
        // Fetch expenses within the date range
        let totalExpense = fetchTotalExpenseAmount(startDate: startOfYear, endDate: endOfYear)
        
        // Update expense label with the total expense for this year
        expenseLabel.text = "\(totalExpense)"
    }
    
    private func updateExpenseLabelForMonthly() {
        // Calculate the date range for the current month
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        // Fetch expenses within the date range
        let totalExpense = fetchTotalExpenseAmount(startDate: startOfMonth, endDate: endOfMonth)
        
        // Update expense label with the total expense for this month
        expenseLabel.text = " \(totalExpense)"
    }
    
    private func fetchTotalExpenseAmount(startDate: Date, endDate: Date) -> String {
        var totalExpense: Double = 0.0
        
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let expenses = try managedObjectContext.fetch(fetchRequest)
            for expense in expenses {
                if let amountString = expense.amount, let amount = Double(amountString) {
                    totalExpense += amount
                }
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
        
        let nairaAmount = "₦" + String(format: "%.2f", totalExpense) // Concatenate Naira sign with the amount
        return nairaAmount
    }
    
    // Function to update expense label for a specific period
    private func updateExpenseLabelForPeriod(startDate: Date, endDate: Date) -> Double {
        // Fetch total expense
        let totalExpense = fetchTotalExpenseAmount(startDate: startDate, endDate: endDate)
        
        // Fetch total budget
        let totalBudget = fetchTotalBudgetAmount(startDate: startDate, endDate: endDate)
        
        // Calculate remaining budget
        let remainingBudget = totalBudget - Double(totalExpense.dropFirst(1))!
        print("Remain: ₦\(remainingBudget)")
        return  remainingBudget
       
        
        // Update expense label with total expense
        //expenseLabel.text = totalExpense
        
        // Update budget label with remaining budget
        //budgetLabel.text = "Remaining Budget: ₦\(remainingBudget)"
    }

    
    private func fetchTotalBudgetAmount(startDate: Date, endDate: Date) -> Double {
        var totalBudget: Double = 0.0
        
        let fetchRequest: NSFetchRequest<Category> = NSFetchRequest<Category>(entityName: "Category")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let categories = try managedObjectContext.fetch(fetchRequest)
            for category in categories {
                if let amountString = category.amount, let amount = Double(amountString) {
                    totalBudget += amount
                }
            }
        } catch {
            print("Error fetching categories: \(error)")
        }
        
        return totalBudget
    }
    
    
    
    
   
    private func fetchTotalIncomeAmount(startDate: Date, endDate: Date) -> String {
        var totalExpense: Double = 0.0
        
        let fetchRequest: NSFetchRequest<Income> = NSFetchRequest<Income>(entityName: "Income")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let incomes = try managedObjectContext.fetch(fetchRequest)
            for incomes in incomes {
                if let amountString = incomes.income, let amount = Double(amountString) {
                    totalExpense += amount
                }
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
        
        let nairaAmount = "₦" + String(format: "%.2f", totalExpense) // Concatenate Naira sign with the amount
        return nairaAmount
    }


    
    private func updateLineChartDataForDaily() {
        // Fetch expenses for the current day from Core Data
        let currentDate = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: currentDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startOfDay as CVarArg, endOfDay as CVarArg)

        do {
            let expenses = try managedObjectContext.fetch(fetchRequest)

            // Prepare data entries for the chart
            var dataEntries: [ChartDataEntry] = []
            var xLabels: [String] = [] // Array to store X-axis labels

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a" // Format as hours:minutes AM/PM

            for (index, expense) in expenses.enumerated() {
                // Convert time to a formatted string representation for X-axis
                if let expenseDate = expense.date {
                    let timeString = dateFormatter.string(from: expenseDate)
                    xLabels.append(timeString)

                    // Convert time to a numerical representation for X-axis
                    let timeInMinutes = Double(index) // Assuming each expense is one unit apart
                    let dataEntry = ChartDataEntry(x: timeInMinutes, y: Double(expense.amount!) ?? 0.0)
                    dataEntries.append(dataEntry)
                }
            }

            // Create line data set
            let dataSet = LineChartDataSet(entries: dataEntries, label: "Daily Expenses")
            dataSet.colors = [UIColor.systemBlue]
            dataSet.circleColors = [UIColor.systemBlue]
            dataSet.lineWidth = 1.5
            dataSet.circleRadius = 3.0
            dataSet.drawValuesEnabled = false
           
            let gradientColors = [UIColor.systemBlue.cgColor, UIColor.clear.cgColor] as CFArray
            let colorLocations: [CGFloat] = [0.0, 1.0] // Gradient color locations

            guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else {
                print("Failed to create gradient")
                return
            }

            let gradientFill = LinearGradientFill(gradient: gradient, angle: 90.0) // Create LinearGradientFill instance
            dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90.0) // Apply gradient fill
            dataSet.drawFilledEnabled = true

            dataSet.mode = .cubicBezier // Use smooth line

            // Create line data
            let data = LineChartData(dataSet: dataSet)

            // Customize chart view
            lineChartView.backgroundColor = UIColor.systemBackground
            lineChartView.legend.enabled = false // Hide legend
            lineChartView.rightAxis.enabled = false // Hide right axis
            lineChartView.xAxis.labelPosition = .bottom // Show x-axis labels at the bottom
            lineChartView.xAxis.drawGridLinesEnabled = false // Hide vertical grid lines
            lineChartView.xAxis.labelTextColor = UIColor.label // Set x-axis label color
            lineChartView.leftAxis.labelTextColor = UIColor.label // Set left y-axis label color
            lineChartView.animate(xAxisDuration: 0.5) // Add animation

            // Set X-axis labels
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xLabels)
          
            // Set data to chart view
            lineChartView.data = data
        } catch {
            print("Error fetching expenses: \(error)")
        }
    }



    private func updateAreaChartDataForWeekly() {
        let currentDate = Date()
        let calendar = Calendar.current
        var startOfWeek = Date()
        var interval: TimeInterval = 0
        calendar.dateInterval(of: .weekOfMonth, start: &startOfWeek, interval: &interval, for: currentDate)
        let endOfWeek = startOfWeek.addingTimeInterval(interval)

        // Fetch expense data for the entire week
        let (dataEntries, daysOfWeek) = fetchExpenseDataForWeek(startDate: startOfWeek, endDate: endOfWeek)

        // Create dataset with data entries
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Weekly Chart Data")
        dataSet.colors = [NSUIColor.blue]
        dataSet.circleColors = [NSUIColor(red: 0, green: 122/255, blue: 1, alpha: 1)]
        dataSet.drawValuesEnabled = false
        dataSet.lineWidth = 2.0
        dataSet.circleRadius = 4.0 // Set radius of the data point circles
        dataSet.mode = .cubicBezier
        
        let gradientColors = [UIColor.systemBlue.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [0.0, 1.0] // Gradient color locations

        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else {
            print("Failed to create gradient")
            return
        }

        let gradientFill = LinearGradientFill(gradient: gradient, angle: 90.0) // Create LinearGradientFill instance
        dataSet.fill = LinearGradientFill(gradient: gradient, angle: 90.0) // Apply gradient fill
        dataSet.drawFilledEnabled = true


        // Create data object from dataset
        let data = LineChartData(dataSet: dataSet)

        // Assign data to chart view
        candlestickChartView.data = data

        // Set additional styling for the chart view
        candlestickChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: daysOfWeek)
        candlestickChartView.xAxis.labelCount = daysOfWeek.count
        candlestickChartView.xAxis.labelFont = .systemFont(ofSize: 10) // Set x-axis label font size
        candlestickChartView.leftAxis.labelFont = .systemFont(ofSize: 10) // Set y-axis label font size
        candlestickChartView.rightAxis.enabled = false // Disable right y-axis
        candlestickChartView.legend.enabled = false // Hide legend
        candlestickChartView.chartDescription.enabled = false // Hide chart description
        candlestickChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0) // Animation
    }

    private func fetchExpenseDataForWeek(startDate: Date, endDate: Date) -> ([ChartDataEntry], [String]) {
        var dataEntries: [ChartDataEntry] = []
        var daysOfWeek: [String] = []
        
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date < %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let expenses = try managedObjectContext.fetch(fetchRequest)
            
            let calendar = Calendar.current
            var currentDayOfWeek = calendar.component(.weekday, from: startDate)
            currentDayOfWeek -= calendar.firstWeekday // Adjust to start from 0
            
            var totalExpense: Double = 0.0
            
            for day in 0..<7 {
                let dayExpenses = expenses.filter { calendar.component(.weekday, from: $0.date!) == currentDayOfWeek }
                let totalDayExpense = dayExpenses.reduce(0.0) { $0 + Double($1.amount!)! }
                totalExpense += totalDayExpense
                
                let chartEntry = ChartDataEntry(x: Double(day), y: totalExpense)
                dataEntries.append(chartEntry)
                daysOfWeek.append(calendar.shortWeekdaySymbols[currentDayOfWeek]) // Append the day of the week
                
                currentDayOfWeek = (currentDayOfWeek + 1) % 7
            }
        } catch {
            print("Error fetching expenses: \(error)")
        }
        
        return (dataEntries, daysOfWeek)
    }
   
    
  
    private func updateDropletChartDataForMonthly() {
        var entries: [BarChartDataEntry] = []
        var labels: [String] = []

        let fetchExpenseRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        let fetchIncomeRequest: NSFetchRequest<Income> = NSFetchRequest<Income>(entityName: "Income")

        do {
            let expenses = try managedObjectContext.fetch(fetchExpenseRequest)
            let incomes = try managedObjectContext.fetch(fetchIncomeRequest)

            // Create a dictionary to store expenses and incomes for each day
            var dailyData: [Date: (expense: Double, income: Double)] = [:]

            // Populate daily data dictionary
            for expense in expenses {
                if let date = expense.date, let amount = Double(expense.amount ?? "0") {
                    let day = Calendar.current.startOfDay(for: date)
                    if let existingData = dailyData[day] {
                        dailyData[day] = (existingData.expense + amount, existingData.income)
                    } else {
                        dailyData[day] = (amount, 0)
                    }
                }
            }

            for income in incomes {
                if let date = income.date, let amount = Double(income.income ?? "0") {
                    let day = Calendar.current.startOfDay(for: date)
                    if let existingData = dailyData[day] {
                        dailyData[day] = (existingData.expense, existingData.income + amount)
                    } else {
                        dailyData[day] = (0, amount)
                    }
                }
            }

            // Sort daily data by date
            let sortedData = dailyData.sorted { $0.key < $1.key }

            // Convert the dictionary to data entries and labels
            for (index, (date, data)) in sortedData.enumerated() {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d"
                let label = dateFormatter.string(from: date)
                labels.append(label)
                let entry = BarChartDataEntry(x: Double(index), yValues: [data.expense, data.income])
                entries.append(entry)
            }

            // Create dataset with data entries
            let dataSet = BarChartDataSet(entries: entries, label: "")
            dataSet.colors = [UIColor.red, UIColor.green]
            dataSet.stackLabels = ["Expenses", "Incomes"]
            dataSet.drawValuesEnabled = false

            // Combine expense and income datasets
            let data = BarChartData(dataSet: dataSet)

            // Configure chart view
            monthlyChartView.backgroundColor = UIColor.systemBackground
            monthlyChartView.legend.enabled = true
            monthlyChartView.legend.textColor = UIColor.label
            monthlyChartView.rightAxis.enabled = false
            monthlyChartView.xAxis.labelPosition = .bottom
            monthlyChartView.xAxis.drawGridLinesEnabled = false
            monthlyChartView.xAxis.labelTextColor = UIColor.label
            monthlyChartView.leftAxis.labelTextColor = UIColor.label
            monthlyChartView.animate(xAxisDuration: 0.5)

            monthlyChartView.data = data
            monthlyChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: labels)

        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    private func fetchTotalExpenseForMonth(month: Int) -> String {
        var totalExpense: Double = 0.0
        
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: month, day: 1)),
              let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) else {
            return "₦0.00"
        }
        
        let fetchRequest: NSFetchRequest<Expense> = NSFetchRequest<Expense>(entityName: "Expense")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let expenses = try managedObjectContext.fetch(fetchRequest)
            for expense in expenses {
                if let amountString = expense.amount, let amount = Double(amountString) {
                    totalExpense += amount
                }
            }
        } catch {
            print("Error fetching expenses for month \(month): \(error)")
        }
        
        return "₦" + String(format: "%.2f", totalExpense)
    }

    private func fetchTotalIncomeForMonth(month: Int) -> String {
        var totalIncome: Double = 0.0
        
        let calendar = Calendar.current
        guard let startDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: month, day: 1)),
              let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) else {
            return "₦0.00"
        }
        
        let fetchRequest: NSFetchRequest<Income> = NSFetchRequest<Income>(entityName: "Income")
        fetchRequest.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as CVarArg, endDate as CVarArg)
        
        do {
            let incomes = try managedObjectContext.fetch(fetchRequest)
            for income in incomes {
                if let amountString = income.income, let amount = Double(amountString) {
                    totalIncome += amount
                }
            }
        } catch {
            print("Error fetching incomes for month \(month): \(error)")
        }
        
        return "₦" + String(format: "%.2f", totalIncome)
    }


    private func updateCandlestickChartDataForYearly() {
        var entries: [BarChartDataEntry] = []

        // Iterate over each month
        for month in 1...12 {
            // Fetch total expense and income for the month
            let totalExpense = fetchTotalExpenseForMonth(month: month)
            let totalIncome = fetchTotalIncomeForMonth(month: month)

            // Convert totalExpense and totalIncome to Double
            guard let expenseAmount = Double(totalExpense.dropFirst(1)), let incomeAmount = Double(totalIncome.dropFirst(1)) else {
                continue
            }

            // Create a bar chart entry for each month
            let entry = BarChartDataEntry(x: Double(month - 1), yValues: [expenseAmount, incomeAmount])
            entries.append(entry)
        }

        // Create dataset with data entries
        let dataSet = BarChartDataSet(entries: entries, label: "")
        dataSet.colors = [UIColor.red, UIColor.green]
        dataSet.stackLabels = ["Expenses", "Incomes"]
        dataSet.drawValuesEnabled = false

        // Create data object from dataset
        let data = BarChartData(dataSet: dataSet)

        // Assign data to chart view
        areaChartView.data = data

        // Configure chart view
        areaChartView.xAxis.labelPosition = .bottom
        areaChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
        areaChartView.xAxis.labelCount = 12
        areaChartView.xAxis.labelFont = .systemFont(ofSize: 10) // Set x-axis label font size
        areaChartView.leftAxis.labelFont = .systemFont(ofSize: 10) // Set y-axis label font size
        areaChartView.rightAxis.enabled = false // Disable right y-axis
        areaChartView.legend.enabled = false // Hide legend
        areaChartView.chartDescription.enabled = false // Hide chart description
        areaChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0) // Animation
    }

}
