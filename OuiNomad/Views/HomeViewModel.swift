//
//  HomeViewModel.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import Combine
import Firebase
import FirebaseCore
import FirebaseFirestore
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var userLoggedIn: Bool = false
    @Published var userType: UserType? //
    
    @Published var userClient: UserClient? {
         didSet {
             if userClient != nil {
                 // User type is client
                 userManager.userType = .client
             }
         }
     }
     @Published var userNomad: UserNomad? {
         didSet {
             if userNomad != nil {
                 // User type is nomad
                 userManager.userType = .nomad
             }
         }
     }
    
    @Published var userManager: CurrentUserManager
    
    private var cancellables = Set<AnyCancellable>()

    let firestore: Firestore
    
    init(dependencies: Dependencies = Dependencies.shared) {
        self.userManager = dependencies.userManager
        self.firestore = dependencies.fireStore
        
        userManager.$clientUser
            .receive(on: DispatchQueue.main)
            .assign(to: \.userClient, on: self)
            .store(in: &cancellables)
        
        userManager.$nomadUser
            .receive(on: DispatchQueue.main)
            .assign(to: \.userNomad, on: self)
            .store(in: &cancellables)
    }
}
