//
//  ErrorWrapper.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
}
