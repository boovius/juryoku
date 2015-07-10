//
//  DateProcessor.swift
//  juryoku
//
//  Created by Joshua Book on 7/9/15.
//  Copyright (c) 2015 Boovius Projects. All rights reserved.
//

import Foundation

class DateProcessor {
    
    class func inThisWeek(date: NSDate) -> Bool {
        if let beginning = beginningOfWeek() {
            return firstDateGreaterThanSecond(date, second: beginning)
        } else {
            return false
        }
    }
    
    class func daysBetween(incomingFirst: NSDate, incomingSecond: NSDate) -> Int? {
        var firstDate: NSDate?
        firstDate = incomingFirst
        var secondDate: NSDate?
        secondDate = incomingSecond
        
        if  (firstDate != nil) {
            if  (secondDate != nil) {
                var calendar: NSCalendar = NSCalendar.currentCalendar()
                
                // Replace the hour (time) of both dates with 00:00
                let date1 = calendar.startOfDayForDate(firstDate!)
                let date2 = calendar.startOfDayForDate(secondDate!)
                
                let flags = NSCalendarUnit.DayCalendarUnit
                let components = calendar.components(flags, fromDate: date1, toDate: date2, options: nil)
                
                return components.day
            }
        }
        return nil
    }
    
    private
    
    class func beginningOfWeek() -> NSDate? {
        let cal = NSCalendar.currentCalendar()
        
        let components = NSDateComponents()
        var beginningOfWeek: NSDate?
        if let date = cal.dateByAddingComponents(components, toDate: NSDate(), options: NSCalendarOptions(0)) {
            var weekDuration = NSTimeInterval()
            if cal.rangeOfUnit(.CalendarUnitWeekOfYear, startDate: &beginningOfWeek, interval: &weekDuration, forDate: date) {
                let endOfWeek = beginningOfWeek?.dateByAddingTimeInterval(weekDuration)
            }
        }
        return beginningOfWeek
    }
    
    class func firstDateGreaterThanSecond(first: NSDate, second: NSDate) -> Bool {
        return first.compare(second) == NSComparisonResult.OrderedDescending
    }
}