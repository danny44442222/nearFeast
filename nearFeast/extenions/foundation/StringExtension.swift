//
//  String.swift
//  Shopp
//
//  Created by Umair Afzal on 10/12/2021.
//

import Foundation

extension String {
    
    var notEmpty: Bool {
        return !self.isEmpty
    }
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
    
    var length: Int {
        return self.count
    }
    
    var toArray: [String] {
        return self.components(separatedBy: ",")
    }
    
    func localize(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    func floatValue() -> Float {
        return Float(self.replacingOccurrences(of: ",", with: ""))!
    }
    
    func intValue() -> Int {
        return Int(self) ?? 0
    }
    
    func doubleValue() -> Double {
        if let value = (self as NSString?)?.doubleValue {
            return value
        }
        return 0.0
    }
    
    func asData() -> Data {
        return self.data(using: .utf8) ?? Data()
    }
    
    func asDate(formatter: DateFormatter) -> Date {
        if let date = formatter.date(from: self) {
            return date
        }
        
        return Date()
    }
    
    func caseInsensitiveEqual(to other: String) -> Bool {
        return self.localizedCaseInsensitiveCompare(other) == .orderedSame
    }
    
    func byReplacingDoubleQuotes() -> String {
        // replacing latin char of double quotes with standard double quotes using escape sequence
        return self.replacingOccurrences(of: "”", with: "\"")
    }
    
    /// A function that removes leading and trailing white space characters from the string
    /// - Returns: Updated string without white space characters
    func byRemovingWhiteSpaces() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func containsValue(_ value: String) -> Bool {
        return self.localizedCaseInsensitiveContains(value)
    }  
}
