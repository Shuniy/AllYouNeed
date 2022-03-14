//
//  DateExtension.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 07/02/22.
//

import Foundation

//MARK: DATE
extension Date {
    
    var iso8601Calendar: Calendar {
        let calendar = Calendar(identifier: .iso8601)
        return calendar
    }
    
    var iso8601Formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.calendar = iso8601Calendar
        return formatter
    }
    
    func minutesFromNow(date: Date) -> Int {
        let now = Date()
        let components = iso8601Calendar.dateComponents([.minute], from: date, to: now)
        return components.minute!
    }
}
