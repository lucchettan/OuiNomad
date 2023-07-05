//
//  CreateMissionViewModel.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore
//import FirebaseTimestamp

class CreateMissionViewModel: ObservableObject {
    
    @Published var title = ""
    @Published var start = Date()
    @Published var end = Date()
    @Published var tasks: [String] = []
    @Published var profileType:ProfilesType = .maitreNageur
    @Published var newTask = ""

    @Published var showMissingFields = false
    
    @Published var userClient: UserClient?
    
    var isMissingInformation: Bool {
        title == "" || tasks.isEmpty
    }
    
    var clientCoordinate: GeoPoint?
    
    var clientEmail: String {
        userManager.storedUser?.email ?? ""
    }
    
    @Published var shouldCloseModal = false
    
    let userManager: CurrentUserManager
    let firestore: Firestore
    
    init(dependencies: Dependencies = Dependencies.shared) {
        self.userManager = dependencies.userManager
        self.firestore = dependencies.fireStore
        
        fetchUserType()
    }
    
    func addTask() {
        tasks.append(newTask)
        newTask = ""
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func getMissionLocation() {
        guard let userClient = userClient else { return }
        CoreLocationManager().geocodeAddress(address: userClient.adresse ?? "", zipCode: userClient.zipcode ?? "", country: userClient.pays ?? "") { coordinates, error in
            if let error = error {
                // Handle the geocoding error
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let coordinates = coordinates {
                // Use the coordinates to set the mission location or perform any other actions
                self.clientCoordinate = GeoPoint(latitude: coordinates.latitude, longitude: coordinates.longitude)
                print("Mission Location: \(self.clientCoordinate)")
            } else {
                // Unable to geocode the address
                print("Failed to geocode the address")
            }
        }
    }
}

// Firebase method
extension CreateMissionViewModel {
    func fetchUserType() {
        guard let email = Auth.auth().currentUser?.email else {
            // User is not authenticated or logged in
            return
        }
        
        let collectionRef = Firestore.firestore().collection("users")
        
        let query = collectionRef.whereField("email", isEqualTo: email)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                // Handle error
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                // No documents found
                return
            }
            
            for document in documents {
                let data = document.data()
                
                if let userType = data["userType"] as? String {
                    if userType == "client" {
                        // Decode UserClient object from Firestore data
                        if let userClientData = try? JSONSerialization.data(withJSONObject: data, options: []),
                           let userClient = try? JSONDecoder().decode(UserClient.self, from: userClientData) {
                            self.userClient = userClient
                            // Once UserClient information fetched, we try to build coordinates out of the adress informations
                            self.getMissionLocation()
                        }
                    }
                }
            }
        }
    }
    
    func saveMissionToDB() {
        if let userClient {
            guard let clientCoordinate = clientCoordinate else { return }
            var missionToSave = Mission(
                title: title,
                start: start,
                end: end,
                tasks: tasks,
                profileType: profileType.rawValue,
                clientEmail: self.userManager.storedUser?.email ?? "",
                location: clientCoordinate,
                adress: userClient.adresse,
                zipcode: userClient.zipcode,
                country: userClient.pays
            )
            
            missionToSave.clientFCMToken = self.userManager.deviceToken

            do {
                let missionRef = firestore.collection("Missions").document()
                
                missionRef.setData(missionToSave.toDictionary()) { error in
                    if let error = error {
                        print("Failed to save mission to Firestore: \(error.localizedDescription)")
                        // Handle the error
                    } else {
                        print("Mission saved successfully!")
                        // Handle success
                        self.shouldCloseModal = true
                    }
                }
            } catch {
                print("Error encoding Mission to save: ", error.localizedDescription)
            }
        }
    }
}
