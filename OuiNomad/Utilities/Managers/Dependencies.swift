//
//  Dependencies.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import FirebaseFirestore
import Foundation

struct Dependencies {
    static let shared = Dependencies()

    let userManager: CurrentUserManager
    let fireStore: Firestore
    
    private init() {
        userManager = CurrentUserManager()
        fireStore = Firestore.firestore()
    }
}
