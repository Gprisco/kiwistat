//
//  DateExtensions.swift
//  kiwistat
//
//  Created by Giovanni Prisco on 16/01/2020.
//  Copyright © 2020 Giovanni Prisco. All rights reserved.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}

extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601String: String {
        return Formatter.iso8601.string(from: self)
    }
    
    var dateToText: String {
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        
        return df.string(from: self)
    }
    
    var isoToTimeString: String {
        let df = DateFormatter()
        df.dateFormat = "hh:mm"
        
        return df.string(from: self)
    }
    
    var dayMonth: String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM"
        
        return df.string(from: self)
    }
}

extension String {
    var iso8601Date: Date? {
        return Formatter.iso8601.date(from: self)
    }
    
    var dayMonth: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        let date = df.date(from: self)
        
        df.dateFormat = "dd/MM"
        
        return df.string(from: date!)
    }
}
