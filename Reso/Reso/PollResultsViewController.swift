//
//  PollResultsViewController.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit
import Charts

class PollResultsViewController: UIViewController, ChartViewDelegate {
    
    var options = [Option]() {
        didSet {
            setChart(buildChartNames(), values: buildChartData())
        }
    }
    var poll: Poll?
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartView.usePercentValuesEnabled = true
        
        observeOptions()

    }
    
    func observeOptions() {
        guard let poll = poll else { return }
        PollController.observeOptions(poll) { (options) in
            self.options = options.sort { $0.identifier < $1.identifier }
        }
    }
    
    func buildChartNames() -> [String] {
        var chartNames: [String] = []
        
        for option in options {
            chartNames.append(option.name)
        }
        return chartNames
    }
    
    func buildChartData() -> [Double] {
        var chartData: [Double] = []
        for option in options {
            chartData.append(Double(option.votes.count))
        }
        return chartData
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        pieChartView.noDataText = "No Results"
        pieChartView.noDataTextDescription = "There is no results to display."
        pieChartView.descriptionText = ""
        
        var dataEntries: [ChartDataEntry] = []
        pieChartView.centerText = ""
        
        var extraColors: [UIColor] = []
        var extraLabels: [String] = []
        
        var allColors = [
            UIColor(red: 0.984, green: 0.118, blue: 0.251, alpha: 1.00),
            UIColor(red: 0.996, green: 0.902, blue: 0.192, alpha: 1.00),
            UIColor(red: 0.243, green: 0.867, blue: 1.000, alpha: 1.00),
            UIColor(red: 0.145, green: 1.000, blue: 0.545, alpha: 1.00)]
        
        var selectedColors = [UIColor]()
        var names = [String]()
        
        for i in 0..<dataPoints.count {
            if values[i] != 0.0 {
                selectedColors.append(allColors[i])
                names.append(dataPoints[i])
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            } else {
                if i < allColors.count {
                    extraLabels.append(dataPoints[i])
                    extraColors.append(allColors[i])
                }
            }
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        pieChartDataSet.colors = selectedColors
        
        let pieChartData = PieChartData(xVals: names, dataSet: pieChartDataSet)
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1.0
        formatter.percentSymbol = " %"
        pieChartData.setValueFormatter(formatter)
        
        pieChartView.data = pieChartData
        pieChartView.animate(yAxisDuration: 0.1, easingOption: .EaseInOutBack)
        pieChartView.backgroundColor = UIColor.clearColor()
        pieChartView.descriptionTextColor = UIColor.blackColor()
        
        pieChartView.holeColor = UIColor.clearColor()
        pieChartView.legend.setExtra(colors: extraColors, labels: extraLabels)
        pieChartView.notifyDataSetChanged()

        pieChartView.centerText = ""
        pieChartView.highlighter = nil
        
    }
}