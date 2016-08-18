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
    static let shared = ChartView()

    func setChart(dataPoints: [String], values: [Double]) {
        
        self.noDataText = "No Data"
        self.noDataTextDescription = "You need to provide data for the pie chart to appear"
        self.descriptionText = "Test"
        
        
        var dataEntries: [ChartDataEntry] = []
        self.centerText = "The winner is....!"
        
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Votes")
        pieChartDataSet.colors = [UIColor(red: 0.984, green: 0.118, blue: 0.251, alpha: 1.00), UIColor(red: 0.996, green: 0.902, blue: 0.192, alpha: 1.00), UIColor(red: 0.243, green: 0.867, blue: 1.000, alpha: 1.00), UIColor(red: 0.145, green: 1.000, blue: 0.545, alpha: 1.00)]
        
        
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        self.data = pieChartData
        self.animate(yAxisDuration: 2.0, easingOption: .EaseInOutBack)
        self.backgroundColor = UIColor.clearColor()
        self.descriptionTextColor = UIColor.whiteColor()
        
    }

}