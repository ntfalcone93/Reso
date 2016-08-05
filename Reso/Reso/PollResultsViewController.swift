//
//  PollResultsViewController.swift
//  Reso
//
//  Created by Sean Gilhuly on 8/3/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import UIKit
import Charts

class PollResultsViewController: UIViewController {
    
    // MARK: - IBOutlet
//    
//    @IBOutlet weak var pieChartView: PieChartView!
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let options = ["Harmon's", "Pie Hole", "J-Dawgs", "Jimmy John's"]
//        let votes = [2.0, 0.6, 1.0, 1.5]
//        
//        setChart(options, values: votes)
//        self.pieChartView.drawSliceTextEnabled = false
//        self.pieChartView.drawHoleEnabled = false
//        self.pieChartView.usePercentValuesEnabled = true
//        
//    }
//    
//    func setChart(dataPoints: [String], values: [Double]) {
//        
//        pieChartView.noDataText = "No Data"
//        pieChartView.noDataTextDescription = "You need to provide data for the pie chart to appear"
//        pieChartView.descriptionText = "Test"
//        
//        
//        var dataEntries: [ChartDataEntry] = []
//        pieChartView.centerText = "The winner is....!"
//        
//        
//        for i in 0..<dataPoints.count {
//            
//            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
//            dataEntries.append(dataEntry)
//        }
//        
//        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Votes")
//        pieChartDataSet.colors = [UIColor(red: 0.984, green: 0.118, blue: 0.251, alpha: 1.00), UIColor(red: 0.996, green: 0.902, blue: 0.192, alpha: 1.00), UIColor(red: 0.243, green: 0.867, blue: 1.000, alpha: 1.00), UIColor(red: 0.145, green: 1.000, blue: 0.545, alpha: 1.00)]
//        
//        
//        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
//        
//        pieChartView.data = pieChartData
//        pieChartView.animate(yAxisDuration: 2.0, easingOption: .EaseInOutBack)
//        pieChartView.backgroundColor = UIColor.clearColor()
//        pieChartView.descriptionTextColor = UIColor.whiteColor()
//    }
    
}
