//
//  DateFormatterExtension.swift
//  Shopp
//
//  Created by Umair Afzal on 29/12/2021.
//

import Foundation

extension DateFormatter {
    
    static let MMDDYYYY = formatter(format: "MM/dd/yyyy")
    static let MMddyy = formatter(format: "MM/dd/yy")
    static let yyyyMMdd = formatter(format: "yyyy MM dd")
    static let yyyyMMddWithDash = formatter(format: "yyyy-MM-dd")
    static let MMddyyyyWithDash = formatter(format: "MM-dd-yyyy")
    static let mmddyyTime12Hours = formatter(format: "MM/dd/yy hh:mm a")
    static let mmddyyyyTime12Hours = formatter(format: "MM/dd/yyyy hh:mm a")
    static let hmm = formatter(format: "hh:mm")
    static let hhmm = formatter(format: "HH:mm")
    static let HHMMSS = formatter(format: "HH:MM:SS")
    static let MMMM = formatter(format: "MMMM")
    static let monthYYYY = formatter(format: "MMMM yyyy")
    static let monthddyyyy = formatter(format: "MMMM dd, yyyy")
    static let dayOnly = formatter(format: "EEEE")
    static let MMMddyyyy = formatter(format: "MMM dd, yyyy")
    static let MMMdd = formatter(format: "MMM dd")
    static let MMDDYYYYWithoutSlash = formatter(format: "MMddyyyy")
    static let YYYYMMDDWithTime = formatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ")
    static let EEEddMMMMyyyy = formatter(format: "EEEE, dd MMMM yyyy")
    static let ddMMyyyy = formatter(format: "dd MMM yyyy")
    static let DDMMYYYY = formatter(format: "DD-MM-YYYY")
    static let ddMMYYYY = formatter(format: "dd MMMM yyyy")
    static let EddMMMM = formatter(format: "E, dd MMMM")
    static let dd = formatter(format: "dd")
    static let dMMM = formatter(format: "d MMM")
    static let dMM = formatter(format: "h:mm")
    static let dd_MM_yyyy = formatter(format: "dd-MM-yyyy")
    static let ddMMMMYYYYYY = formatter(format: "ddMMMMYYYYYY")
    
    private static func formatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }

    /// To convert api date string to date
    /// - Returns: api date formmat
    static func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
}
