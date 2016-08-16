//
//  dateHelper.swift
//  Reso
//
//  Created by Patrick Pahl on 8/15/16.
//  Copyright © 2016 ResoPolling. All rights reserved.
//

import Foundation

extension NSDate {
    
    func stringValue() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(self)
    }
}