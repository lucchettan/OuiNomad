//
//  Date+Extension.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 04/07/2023.
//

import Foundation

extension Date {
    func asCalendarDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: self)
    }
    
    func asHour() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
