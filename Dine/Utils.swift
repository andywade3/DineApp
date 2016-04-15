//
//  Utils.swift
//  Dine
//
//  Created by YiHuang on 4/5/16.
//  Copyright © 2016 YYZ. All rights reserved.
//

import Foundation

class Log {
    
    class func info(content: String?) {
        if let content = content {
            print("[Log][INFO]: \(content)")
        } else {
            print("[Log][INFO]: nil")
        }
    }
    
    class func error(content: String?) {
        if let content = content {
            print("[Log][ERROR]: \(content)")
        } else {
            print("[Log][ERROR]: nil")
        }
    }
    
    class func warning(content: String?) {
        if let content = content {
            print("[Log][WARN]: \(content)")
        } else {
            print("[Log][WARN]: nil")
        }
    }
}

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: .MatchLast).year
    }
    
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: .MatchLast).month
    }

    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date, toDate: self, options: .MatchLast).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: .MatchLast).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: .MatchLast).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: .MatchLast).second
    }

}