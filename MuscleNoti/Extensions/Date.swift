//
//  Date.swift
//  MuscleNoti
//
//  Created by Giorgi Shamugia on 02.06.22.
//

import Foundation
import UIKit

extension TimeInterval {
    
    public func addMinute(_ minute: Int) -> TimeInterval? {
        var minuteInSecunds: Double = 0
        minuteInSecunds = Double(minute * 60)
        return minuteInSecunds
    }
    
    public func addHour(_ hour: Int) -> TimeInterval? {
        var hourInSecunds: Double = 0
        hourInSecunds = Double(hour * 3600)
        return hourInSecunds
    }
    
 }

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
