//
//  SettingsViewModel.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore

class SettingsViewModel: ObservableObject {
    // MARK: UI Values
    // Nomad:
    @Published var nomadNom = ""
    @Published var nomadPrenom = ""
    @Published var tauxHorraire = ""
    @Published var iban = ""
    @Published var numeroProfessionnel = ""
    
    // Client:
    @Published var clientNom = ""
    @Published var adresse = ""
    @Published var zipcode = ""
    @Published var pays = ""
    
    var documentID: String = ""
    
    let userManager: CurrentUserManager
    let firestore: Firestore
    
    @Published var userType: UserType?
    
    init(dependencies: Dependencies = Dependencies.shared) {
        self.userManager = dependencies.userManager
        self.firestore = dependencies.fireStore
        
        if let userNomad = userManager.nomadUser {
            nomadNom = userNomad.nomNomad ?? ""
            nomadPrenom = userNomad.prenom ?? ""
            tauxHorraire = userNomad.tauxHorraire ?? ""
            iban = userNomad.iban ?? ""
            numeroProfessionnel = userNomad.numeroProfessionnel ?? ""
            documentID = userNomad.documentID ?? ""
            userType = .nomad
        }
        
        if let userClient = userManager.clientUser {
            clientNom = userClient.nomClient ?? ""
            adresse = userClient.adresse ?? ""
            zipcode = userClient.zipcode ?? ""
            pays = userClient.pays ?? ""
            documentID = userClient.documentID ?? ""
            userType = .client
        }
    }
    
    func updateUser() {
        guard documentID != "" else {
            print("documentID is nil")
            return
        }
        
        let userRef = Firestore.firestore().collection("users").document(documentID)
        
        switch userType {
        case .nomad:
            var userNomadToUpdate = UserNomad(
                userType: .nomad,
                nomNomad: nomadNom,
                prenom: nomadPrenom,
                tauxHorraire: tauxHorraire,
                numeroProfessionnel: numeroProfessionnel,
                iban: iban,
                email: Auth.auth().currentUser?.email ?? "",
                documentID: documentID
                )
            
            userRef.setData(userNomadToUpdate.toDictionary()) { error in
                if let error = error {
                    print("Error updating user : \(error.localizedDescription)")
                } else {
                    print("User updated successfully")
                }
            }
        case .client:
            var userClientToUpdate = UserClient(
                userType: .client,
                nomClient: clientNom,
                adresse: adresse,
                zipcode: zipcode,
                pays: pays,
                email: Auth.auth().currentUser?.email ?? "",
                documentID: documentID)

            userRef.setData(userClientToUpdate.toDictionary()) { error in
                if let error = error {
                    print("Error updating user : \(error.localizedDescription)")
                } else {
                    print("User updated successfully")
                }
            }
        default:
            print("FAILURE: No specific user type stored")
            break
        }
    }
}
