//
//  ChartController.swift
//  
//
//  Created by Sean Gilhuly on 8/4/16.
//
//

import Foundation
import Charts

class ChartView: PieChartView {
    
    // MARK: Functions
    
    func setChart(options: [String], votes: [Double]) {
        
        self.noDataText = "No Results"
        self.noDataTextDescription = "There is no results to display"
        self.descriptionText = "Results View"
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<options.count {
            
            let dataEntry = ChartDataEntry(value: votes[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Votes")
        
        pieChartDataSet.colors = [UIColor(red: 0.984, green: 0.118, blue: 0.251, alpha: 1.00), UIColor(red: 0.996, green: 0.902, blue: 0.192, alpha: 1.00), UIColor(red: 0.243, green: 0.867, blue: 1.000, alpha: 1.00), UIColor(red: 0.145, green: 1.000, blue: 0.545, alpha: 1.00)]
        
        let pieChartData = PieChartData(xVals: options, dataSet: pieChartDataSet)
        
        self.centerText = "Results"
        self.data = pieChartData
        self.backgroundColor = UIColor.clearColor()
        self.descriptionTextColor = UIColor.whiteColor()
        self.xAxis.labelPosition = .Bottom
        self.legend.enabled = false
        self.highlighter = nil
        self.xAxis.setLabelsToSkip(0)
        
        self.drawSliceTextEnabled = false
        self.drawHoleEnabled = false
        self.usePercentValuesEnabled = true
        
        // Animation
        self.animate(yAxisDuration: 2.0, easingOption: .EaseInOutBack)
    }
}