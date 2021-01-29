//
//  DateTimeUtility.swift
//  Cozy Up
//
//  Created by Keyur on 15/10/18.
//  Copyright © 2018 Keyur. All rights reserved.
//

import Foundation

func getCurrentTimeStampValue() -> String
{
    return String(format: "%0.0f", Date().timeIntervalSince1970)
}

func getTimestampFromDate(date : Date) -> Double
{
    return date.timeIntervalSince1970
}

func getDateFromTimeStamp(_ timeStemp:Double) -> Date
{
    return Date(timeIntervalSince1970: TimeInterval(timeStemp/1000))
}

func getDateStringFromServerTimeStemp(_ timeStemp:Double) -> String{
    
    let date : Date = Date(timeIntervalSince1970: TimeInterval(timeStemp/1000))
    
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = DATE_FORMAT.DISPLAY_DATE_FORMAT
    return dateFormatter.string(from: date)
}
func getTimeStringFromServerTimeStemp(_ timeStemp:Double) -> String{
    
    let date : Date = Date(timeIntervalSince1970: TimeInterval(timeStemp/1000))
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    //dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = DATE_FORMAT.DISPLAY_TIME_FORMAT
    return dateFormatter.string(from: date)
}

func getDateTimeStringFromServerTimeStemp(_ timeStemp:Double) -> String{
    
    let date : Date = Date(timeIntervalSince1970: TimeInterval(timeStemp/1000))
    
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = DATE_FORMAT.DISPLAY_DATE_TIME_FORMAT
    return dateFormatter.string(from: date)
}


func getDateStringFromDate(date : Date) -> String
{
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = DATE_FORMAT.SERVER_DATE_TIME_FORMAT
    return dateFormatter.string(from: date)
}

func getTimeStringFromDate(date : Date) -> String
{
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = DATE_FORMAT.DISPLAY_TIME_FORMAT
    return dateFormatter.string(from: date)
}

func getDateStringFromDate(date : Date, format : String) -> String
{
    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func getDateFromDateString(strDate : String, format : String) -> Date?
{
    let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: strDate)
}

func getDateStringFromDateWithLocalTimezone(date : Date, format : String) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func getDateFromDateString(strDate : String) -> Date
{
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
   // dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "YYYY-MM-dd"
    return dateFormatter.date(from: strDate)!
}

func getDateFromDateString1(strDate : String) -> String
{
    let dateFormatter1 = DateFormatter()
    dateFormatter1.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    dateFormatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"//"yyyy-MM-dd HH:mm:ss"
    let date1 =  dateFormatter1.date(from: strDate)!
    dateFormatter1.dateFormat = "dd, MMM yy"
    return dateFormatter1.string(from: date1)
}

func getTodayDateFromCurrentDate() -> String
{
    let dateFormatter1 = DateFormatter()
    let date1 = Date()
    dateFormatter1.dateFormat = "dd-MM-yyyy"
    return dateFormatter1.string(from: date1)
}


//MARK: Date difference
func getDifferenceFromCurrentTime(_ timeStemp : Double) -> Int
{
    let newDate : Date = Date(timeIntervalSince1970: TimeInterval(timeStemp/1000))
    let currentDate : Date = getCurrentDate()
    let interval = currentDate.timeIntervalSince(newDate)
    return Int(interval)
}

func getCurrentDate() -> Date
{
    let currentDate : Date = Date()
    return currentDate
}

func getDifferenceFromCurrentTimeInHourInDays(_ timestamp : Double) -> String
{
    let interval : Int = getDifferenceFromCurrentTime(timestamp)
    
    let second : Int = interval
    let minutes : Int = interval/60
    let hours : Int = interval/(60*60)
    let days : Int = interval/(60*60*24)
    let week : Int = interval/(60*60*24*7)
    let months : Int = interval/(60*60*24*30)
    let years : Int = interval/(60*60*24*30*12)
    
    var timeAgo : String = ""
    if  second < 60
    {
        timeAgo = (second < 3) ? "Just Now" : (String(second) + "s")
    }
    else if minutes < 60
    {
        timeAgo = String(minutes) + "m"
    }
    else if hours < 24
    {
        timeAgo = String(hours) + "h"
    }
    else if days < 30
    {
        timeAgo = String(days) + " "  + ((days > 1) ? "days" : "day")
    }
    else if week < 4
    {
        timeAgo = String(week) + " "  + ((week > 1) ? "weeks" : "week")
    }
    else if months < 12
    {
        timeAgo = String(months) + " "  + ((months > 1) ? "months" : "month")
    }
    else
    {
        timeAgo = String(years) + " "  + ((years > 1) ? "years" : "year")
    }
    
    if second > 3 {
        timeAgo = timeAgo + " ago"
    }
    return timeAgo
}

func getRemaingTimeInDayHourMinuteSecond(_ endDate : Date) -> String
{
//    let lastDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate)!
    let lastDate = endDate
    let diffDateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(), to: lastDate)
    let countdown = "\(diffDateComponents.day ?? 0)d \(diffDateComponents.hour ?? 0)h \(diffDateComponents.minute ?? 0)m \(diffDateComponents.second ?? 0)s"
    if diffDateComponents.day! < 0 && diffDateComponents.hour! < 0 && diffDateComponents.minute! < 0  && diffDateComponents.second! < 0 {
        return ""
    }
    return countdown
}

func getRemainingTime(_ date : String) -> String {
    
    let endDate : Date = getDateFromDateString(strDate: date)
    let currentDate : Date = getCurrentDate()
    let interval = endDate.timeIntervalSince(currentDate)
    
    let second : Int = Int(interval)
    let minutes : Int = Int(interval/60)
    let hours : Int = Int(interval/(60*60))
    let days : Int = Int(interval/(60*60*24))
    let months : Int = Int(interval/(60*60*24*30))
    
    var strTime = ""
    
    if months > 0 {
        if months > 1 {
            strTime = String(months) + " months"
        }else{
            strTime = String(months) + " month"
        }
    }
    else if days > 0 {
        if days > 1 {
            strTime = String(days) + " days"
        }else{
            strTime = String(days) + " day"
        }
    }
    else if hours > 0 {
        if hours > 1 {
            strTime = String(hours) + " hrs"
        }else{
            strTime = String(hours) + " hr"
        }
    }
    else{
        if minutes > 0 {
            strTime = String(minutes) + "Min."
        }
        if second > 0 {
            strTime = strTime + " " + String(second) + "S"
        }
    }
    
    return strTime
}

func getTodayString() -> String{
    
    let date = Date()
    let calender = Calendar.current
    let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
    
    let year = components.year
    let month = components.month
    let day = components.day
    let hour = components.hour
    let minute = components.minute
    let second = components.second
    
    let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
    
    return today_string
    
}

func isSameDateString(firstDate : String, secondDate : String) -> Bool
{
    let strDate1 : String = getDateStringFromServerTimeStemp(Double(firstDate)!)
    let strDate2 : String = getDateStringFromServerTimeStemp(Double(secondDate)!)
    
    if strDate1 == strDate2
    {
        return true
    }
    return false
}

func isSameDate(firstDate : String, secondDate : String) -> Bool
{
    let strDate1 : String = getDateStringFromServerTimeStemp(Double(firstDate)!)
    let strDate2 : String = getDateStringFromServerTimeStemp(Double(secondDate)!)
        
    if strDate1 == strDate2
    {
        return true
    }
    return false
}

func getdayDifferenceFromCurrentDay(_ timeStemp : Double) -> String
{
    let calendar = NSCalendar.current
    let date1 = calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(timeStemp/1000)))
    let date2 = calendar.startOfDay(for: getCurrentDate())
    
    let components = calendar.dateComponents([.day], from: date1, to: date2)
    
    var timeAgo : String = ""
    if components.day == 0
    {
        timeAgo = "TODAY"
    }
    else if components.day == 1
    {
        timeAgo = "YESTERDAY"
    }
    else
    {
        timeAgo = getDateStringFromServerTimeStemp(TimeInterval(timeStemp))
    }
    
    return timeAgo
}

func getDateOnlyFromDate(date : Date) -> String
{
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "d"
    return dateFormatter.string(from: date)
}

func get24HoureIn12Houre(time : String) -> String {
    let houreMin = time.components(separatedBy: ":")
    var time12: String = time
    if Int(houreMin[0])! < 12 {
        time12 = houreMin[0] + ":" + houreMin[1] + " AM"
    } else {
        time12 = String(Int(houreMin[0])! - 12) + ":" + houreMin[1] + " PM"
    }
    
    return time12
}

func getMonthOnlyFromDate(date : Date) -> String
{
    let dateFormatter = DateFormatter()
    //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "m"
    return dateFormatter.string(from: date)
}


func getOnlyDateTimestamp(date : Date) -> Double
{
    let strDate : String = getDateStringFromDate(date: date)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
//    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = DATE_FORMAT.DISPLAY_DATE_FORMAT
    return getTimestampFromDate(date: dateFormatter.date(from: strDate)!)
}

func getDateTimeStringForChat(_ timesstamp : Double) -> String
{
    let date : Date = getDateFromTimeStamp(timesstamp)
    return getOrdinalDate(date: date)
}

func getOrdinalDate(date : Date) -> String{
    // Day
    let calendar = Calendar.current
    let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
    
    // Formate
    let dateFormate = DateFormatter()
    dateFormate.dateFormat = "MMM yyyy"
    let newDate = dateFormate.string(from: date)
    
    var day  = "\(anchorComponents.day!)"
    switch (day) {
    case "1" , "21" , "31":
        day.append("st")
    case "2" , "22":
        day.append("nd")
    case "3" ,"23":
        day.append("rd")
    default:
        day.append("th")
    }
    return day + " " + newDate
}

func getUserAge(date : Date) -> Int
{
    let calendar = Calendar.current
    let totalYear = calendar.dateComponents([.year], from: date, to: Date())
    return totalYear.year!
}

func getMinimumDateOfBirth() -> Date
{
    return Calendar.current.date(
        byAdding: .year,
        value: -18,
        to: Date())!
}

func getDateFromComponent(_ day : Int, _ month : Int, _ year : Int) -> String
{
    let strDate : String = String(day) + "/" + String(month) + "/" + String(year)
    
    let dateFormatter = DateFormatter()
//    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = DATE_FORMAT.DISPLAY_DATE_FORMAT
    let date : Date = dateFormatter.date(from: strDate)!
    return getDateStringFromDate(date: date)
}

func getTimeFromComponent(_ hours : Int, _ minutes : Int) -> String
{
    var time : String = String(hours) + ":" + String(minutes)
    if hours < 12
    {
        time = time + " AM"
    }
    else
    {
        time = time + " PM"
    }
    
    return time
}

func getDurationFromComponent(_ hours : Int, _ minutes : Int) -> String
{
    return (String(hours) + ":" + String(minutes) + " hours")
}


func getHoursMinutesSecondsFrom(seconds: Double) -> String {
    let secs = Int(seconds)
    //let hours = (secs / 3600)
    let minutes = (secs % 3600) / 60
    let seconds = (secs % 3600) % 60
    
    var minString : String = String(minutes)
    if minString.count == 1
    {
        minString = "0" + minString
    }
    var secString : String = String(seconds)
    if secString.count == 1
    {
        secString = "0" + secString
    }
    
    return minString + ":" + secString
}
