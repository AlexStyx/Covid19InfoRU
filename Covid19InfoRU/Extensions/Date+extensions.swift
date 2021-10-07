//
//  Data+extensions.swift
//  Covid19InfoRU
//
//  Created by Александр Бисеров on 9/28/21.
//

import Foundation

extension Date {
    static func fromString(_ string: String) -> Date? {
        let components = string.components(separatedBy: "T").first?.components(separatedBy: "-").compactMap{Int($0)}
        var dateComponents = DateComponents()
        if let components = components {
            dateComponents.year = components[0]
            dateComponents.month = components[1]
            dateComponents.day = components[2]
        } else {
            return nil
        }
        return Calendar.current.date(from: dateComponents)
    }
    
    public func toString() -> String {
        // frormat date to '2020-01-01T00:00:00Z' String
        let nowComponents = Calendar.current.dateComponents([.day, .month, .year], from: self)
        guard
            let year = nowComponents.year?.convertedToDateFormat(),
            let month = nowComponents.month?.convertedToDateFormat(),
            let day = nowComponents.day?.convertedToDateFormat()
        else {
            fatalError("Cannot get date components in toString() -> String")
        }
        let resultString = year + "-" + month + "-" + day + "T00:00:00Z"
        return resultString
    }
    
    public func aYearAgo() -> Date {
         Calendar.current.date(byAdding: .year, value: -1, to: self) ?? Date()
    }
}


extension Int {
    func convertedToDateFormat() -> String {
        let converted = String(describing: self)
        return converted.count < 2 ? "0" + converted : converted
    }
}
