//
//  DateUtil.swift
//  YinTaiApp
//
//  Created by yuan xiaojun on 2019/4/1.
//  Copyright © 2019 air. All rights reserved.
//

import UIKit

public class DateUtil: NSObject {
    
    public static func timeStampFormat(_ timestamp: Int) -> String {
        let timeInterval:TimeInterval = TimeInterval(timestamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time = dateformatter.string(from: date as Date)
        return time
    }
    
    public static func timeStampFormat(_ timestamp: Int, _ dateFormat : String) -> String {
        let timeInterval:TimeInterval = TimeInterval(timestamp)
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        let time = dateformatter.string(from: date as Date)
        return time
    }
    
    
    public static func stringToTimeStamp(stringTime:String,format:String = "yyyy-MM-dd")->String {

        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        let date = dfmatter.date(from: stringTime)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp) * 1000
        return String(dateSt)
    }

    public static func compareCurrentTime(_ timestamp: Double) -> String {
        //将时间戳转换为日期
        let timeInterval1:TimeInterval = TimeInterval(timestamp / 1000)
        let timeDate = NSDate(timeIntervalSince1970: timeInterval1)
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince(timeDate as Date)
        var temp:Double = 0
        var result:String = ""
        if timeInterval/60 < 1 {
            result = "刚刚"
        }else if (timeInterval/60) < 60{
            temp = timeInterval/60
            result = "\(Int(temp))分钟前"
        }else if timeInterval/(60 * 60) < 24 {
            temp = timeInterval/(60 * 60)
            result = "\(Int(temp))小时前"
        }
//        else if timeInterval/(24 * 60 * 60) < 30
        else{
            temp = timeInterval / (24 * 60 * 60)
            result = "\(Int(temp))天前"
            if temp > 3 {
                result = timeStampFormat(Int(timestamp / 1000), "yyyy-MM-dd")
            }
        }
//        else if timeInterval/(30 * 24 * 60 * 60)  < 12 {
//            temp = timeInterval/(30 * 24 * 60 * 60)
//            result = "\(Int(temp))个月前"
//        }else{
//            temp = timeInterval/(12 * 30 * 24 * 60 * 60)
//            result = "\(Int(temp))年前"
//        }
        return result
    }
    
    // 根据日期获取当天0点的时间戳
    public static func getMorningDate(date:Date) -> Date{
        let calendar = NSCalendar.init(identifier: .chinese)
        let components = calendar?.components([.year,.month,.day], from: date)
        return (calendar?.date(from: components!))!
    }
    
    
    // 获取当前时区的Date
    public static func getCurrentDate() -> Date {
        let nowDate = Date()
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: nowDate)
        let localeDate = nowDate.addingTimeInterval(TimeInterval(interval))
        return localeDate
    }
    
    // 时间戳转换成Date
    public static func timestampWithDate(_ timestamp: Double) -> Date {
        let date = Date.init(timeIntervalSince1970: timestamp)
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT(for: date)
        let localeDate = date.addingTimeInterval(TimeInterval(interval))
        return localeDate
    }
    
    
}

