//
//  OnboardingScreenViewModel.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import Firebase
import FirebaseFirestore
import Foundation

class OnboardingScreenViewModel: ObservableObject {
    // Form
    // - Client values
    @Published var nomClient: String = ""
    @Published var adresse: String = ""
    @Published var zipcode: String = ""
    @Published var pays: String = ""

    // - Nomad values
    @Published var nomNomad: String = ""
    @Published var prenom: String = ""
    @Published var tauxHorraire: String = ""
    @Published var numeroProfessionnel = ""
    @Published var iban = ""
    
    @Published var userType: UserType?
    @Published var pointEmptyField: Bool = false
    
    var informationIsMissing: Bool {
        guard let userType = userType else { return false }
        switch userType {
        case .nomad:
            return nomNomad == "" || prenom == "" || tauxHorraire == "" || numeroProfessionnel == "" || iban == ""
        case .client:
            return nomClient == "" || adresse == "" || zipcode == "" || pays == ""
        }
    }
    
    @Published var shouldAlertForMissingField: Bool = false
    
    let userManager: CurrentUserManager
    let firestore: Firestore
    
    init(dependencies: Dependencies = Dependencies.shared) {
        self.userManager = dependencies.userManager
        self.firestore = dependencies.fireStore        
    }
    
    func setUserType(with type: UserType) {
        self.userType = type
        self.shouldAlertForMissingField = false
    }
    
    func saveUserInfo() {
        guard let userType = userType else { return }
        
        switch userType {
        case .client:
            let client = UserClient(
                userType: userType,
                nomClient: nomClient,
                adresse: adresse,
                zipcode: zipcode,
                pays: pays,
                email: userManager.storedUser?.email)
            
            saveUserToFirestore(client)
        case .nomad:
            let nomad = UserNomad(
                userType: userType,
                nomNomad: nomNomad,
                prenom: prenom,
                tauxHorraire: tauxHorraire,
                numeroProfessionnel: numeroProfessionnel,
                iban: iban,
                email: userManager.storedUser?.email)
            
            saveUserToFirestore(nomad)
        }
    }
    
    func saveUserToFirestore<T: Codable>(_ user: T) {
        guard !informationIsMissing else {
            shouldAlertForMissingField = true
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
            
            guard let userId = Auth.auth().currentUser?.uid else {
                // User is not authenticated or logged in
                return
            }

            let userRef = Firestore.firestore().collection("users").document(userId)
            
            userRef.setData(dictionary) { error in
                if let error = error {
                    // Handle error while saving data
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    // Data saved successfully
                    print("User data saved successfully")
                }
            }
        } catch {
            // Handle encoding error
            print("Error encoding user data: \(error.localizedDescription)")
        }
        
        userManager.fetchUserType()
    }
}
