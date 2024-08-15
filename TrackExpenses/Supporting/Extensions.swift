//
//  Extensions.swift
//  TrackExpenses
//
//  Created by Daniil Kim on 12.08.2024.
//

import Foundation
import SwiftUI

extension Color {
    static let customBackgroung = Color("Background")
    static let customIcon = Color("Icon")
    static let customText = Color("Text")
    static let SystemBackground = Color(uiColor: .systemBackground)

}

extension DateFormatter {
    static let allNumericKZ: DateFormatter = {
        print("Initializing DateFormatter")
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter
    }()
}

extension String {
    func dateParsed() -> Date {
        guard let parsedDate = DateFormatter.allNumericKZ.date(from: self) else {return Date()}
        
        return parsedDate
    }
}

extension Date: Strideable {
    func formatted() -> String {
        return self.formatted(.dateTime.year().month().day())
    }
}

extension Double {
    func roudedTo2Digits() -> Double {
        return (self*100).rounded() / 100
    }
}
