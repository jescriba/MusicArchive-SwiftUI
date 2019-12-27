//
//  DateFormatter+Extensions.swift
//  MusicArchive-SwiftUI
//
//  Created by joshua on 12/26/19.
//  Copyright © 2019 joshua. All rights reserved.
//

import Foundation

extension DateFormatter {
    static func iso8601() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXX"
        return formatter
    }
}
