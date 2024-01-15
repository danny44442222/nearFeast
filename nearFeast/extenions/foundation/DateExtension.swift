//
//  DateExtension.swift
//  Shopp
//
//  Created by Umair Afzal on 29/12/2021.
//

import Foundation

extension Date {
    
    func formatAsyyyyMMdd() -> String {
        return DateFormatter.yyyyMMdd.string(from: self)
    }
    
    func formatAsMMMM() -> String {
        return DateFormatter.MMMM.string(from: self)
    }
    
    func formatAsMonthYYYY() -> String {
        return DateFormatter.monthYYYY.string(from: self)
    }
    
    func formatAsyyyyMMddWithDash() -> String {
        return DateFormatter.yyyyMMddWithDash.string(from: self)
    }
    
    func formatAsMMddyyyyWithDash() -> String {
        return DateFormatter.MMddyyyyWithDash.string(from: self)
    }
    
    func formatAsMMddyyyy() -> String {
        return DateFormatter.MMDDYYYY.string(from: self)
    }
    
    func formatAsMMddyyTime12Hours() -> String {
        return DateFormatter.mmddyyTime12Hours.string(from: self)
    }
    
    func formatAsMMddyyyyTime12Hours() -> String {
        return DateFormatter.mmddyyyyTime12Hours.string(from: self)
    }
    
    func formatAshmma() -> String {
        return DateFormatter.hmm.string(from: self)
    }
    
    func formatAsHHMMSS() -> String {
        return DateFormatter.HHMMSS.string(from: self)
    }
    
    func formatAsMonthddyyyy() -> String {
        return DateFormatter.monthddyyyy.string(from: self)
    }
    
    func formatAsFullDayName() -> String {
        return DateFormatter.dayOnly.string(from: self)
    }
    
    func formatAsMMMddyyyy() -> String {
        return DateFormatter.MMMddyyyy.string(from: self)
    }
    
    func formatAsMMddyy() -> String {
        return DateFormatter.MMddyy.string(from: self)
    }
    
    func formatAsMMMdd() -> String {
        return DateFormatter.MMMdd.string(from: self)
    }
    
    func formatAsMMDDYYYYWithoutSlash() -> String {
        return DateFormatter.MMDDYYYYWithoutSlash.string(from: self)
    }
    
    func formatAsEEEddMMMMyyyy(date: String) -> String {
        let date = DateFormatter.dateFormatter().date(from: date)
        return DateFormatter.EEEddMMMMyyyy.string(from: date ?? Date())
    }
    
    func formatAsDDMMMMYYYYYY(date: String) -> String {
        let date = DateFormatter.dd_MM_yyyy.date(from: date)
        return DateFormatter.ddMMMMYYYYYY.string(from: date ?? Date())
    }
    
    func formatAsdMM(date: String) -> String {
        let date = DateFormatter.hhmm.date(from: date) ?? Date()
        return DateFormatter.dMM.string(from: date)
    }
    
    func formatAsdMMM(date: String) -> String {
        let date = DateFormatter.dateFormatter().date(from: date)
        return DateFormatter.dMMM.string(from: date ?? Date())
    }
    
    func formatAsEddMMMM(date: String) -> String {
        let date = DateFormatter.dateFormatter().date(from: date)
        return DateFormatter.EddMMMM.string(from: date ?? Date())
    }
    
    func changeFormathhmmTohmma(datestring: String) -> String {
        let date = DateFormatter.hhmm.date(from: datestring) ?? Date()
        return DateFormatter.hmm.string(from: date)
    }
    
    func changeFormathmmaToHHMMSS(dateStirng: String) -> String {
        var prayerTime = dateStirng
        let Date = DateFormatter.hmm.date(from: prayerTime) ?? Date()
        prayerTime = DateFormatter.HHMMSS.string(from: Date)
        return prayerTime
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    // Get difference between 2 dates
    func interval(of component: Calendar.Component, from date: Date) -> Int {
        let calendar = Calendar.current
        guard let start = calendar.ordinality(of: component, in: .era, for: date) else { return 0 }
        guard let end = calendar.ordinality(of: component, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    // Get current date in seconds and retrun in Integer
    func inSeconds() -> Int {
        let hour = Calendar.current.component(.hour, from: self)
        let mintue = Calendar.current.component(.minute, from: self)
        let second = Calendar.current.component(.second, from: self)
        let currentTime = hour*60*60 + mintue*60 + second
        return currentTime as Int
    }
    
    // convert timeStrign in seconds e.g prayerTimeInSecond(prayerTime: "01:00:00") and return 3600 in integer
    //func prayerTimeInSeconds(prayerTime: String) -> Int {
//        if let index = prayerTime.range(of: " ")?.lowerBound {
//            let substring = prayerTime[..<index]
//            let prayerTime = String(substring)
//
//            let time = prayerTime.components(separatedBy: ":")
//            let hour = Int(time[0])
//            let mintue = Int(time[1])
//            //let second:Int? = Int(prayerTime[2])
//            if let hour = hour, let mintue = mintue {
//                let prayerSeconds = hour*60*60 + mintue*60
//                return prayerSeconds
//            }
//        }
//        return 0
//    }
    
    // calcuate remaining time and return in seconds e.g  "03:44:00" - currentTime
    //func calculateRemaingTime(from dateStirng: String) -> Int  {
        //        let prayerTime = self.changeFormathmmaToHHMMSS(dateStirng: dateStirng)
//        let prayerSecond = prayerTimeInSeconds(prayerTime: dateStirng)
//        let currentDate = inSeconds()
//        let endTime = prayerTimeInSeconds(prayerTime: "24:00 ")
//        if currentDate >= prayerSecond {
//            return prayerSecond + (endTime - currentDate)
//        }
//        return prayerSecond - currentDate
//    }
    
    // Get remaning time formatt in hours:minutes:seconds
    func RemainingTimeFormatt(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self))) ?? Date()
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth()) ?? Date()
    }
    
    // last day of month
    func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
    }
    
    func isTodaysDate() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func isYesterdaysDate() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    static func startOfLastWeek(from: Date) -> Date {
        let startDate = from.startOfDay()
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: startDate)
        return lastWeekDate ?? Date()
    }
    
    static var calendar: Calendar = {
        return Calendar(identifier: .gregorian)
    }()

    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }

    func isWeekend() -> Bool {
        return Date.calendar.isDateInWeekend(self)
    }
}
