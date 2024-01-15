//
//  DateComponents.swift
//  PrayerTime
//
//  Created by Zohaib on 20/07/2022.
//

import Foundation

extension DateComponents {
    
    mutating func setComponentsForNotifications(date: Date, time: Date) {
        self.day = Calendar.current.component(.day, from: date)
        self.month = Calendar.current.component(.month, from: date)
        self.year = Calendar.current.component(.year, from: date)
        self.minute = Calendar.current.component(.minute, from: time)
        self.hour = Calendar.current.component(.hour, from: time)
    }
}
