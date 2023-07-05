//
//  ClientMissionViewModel.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift

class ClientMissionViewModel: ObservableObject {
    // MARK: UI values
    @Published var missions: [Mission] = []
    @Published var shouldDisplaySettings = false
    @Published var shouldDisplayCreationSheet = false
    
    var notAssignedMissions: [Mission] {
        missions.filter { $0.assignedNomadEmail == "" }
    }
    
    var assignedMissionsToValidate: [Mission] {
        missions.filter { $0.assignedNomadEmail != "" && !$0.isValidated }
    }
    
    var validatedMissions: [Mission] {
        missions.filter { $0.isValidated }
    }
    
    // MARK: Data values
    let userManager: CurrentUserManager
    let firestore: Firestore
    
    
    // MARK: Values for logic
    @State var missionToSave: Mission?
    
    private var missionListener: ListenerRegistration?

    init(dependencies: Dependencies = Dependencies.shared) {
        self.userManager = dependencies.userManager
        self.firestore = dependencies.fireStore
        observeClientMissions()
    }
    
    func saveMission() {
        
    }
    
    func showCreationSheet() {
        shouldDisplayCreationSheet = true
    }
    
    func showSettings() {
        shouldDisplaySettings = true
    }
    
    deinit {
        missionListener?.remove()
    }
}

// MARK: FireBase methods
extension ClientMissionViewModel {
    func observeClientMissions() {
        let collectionRef = Firestore.firestore().collection("Missions")
        let query = collectionRef.whereField("clientEmail", isEqualTo: Auth.auth().currentUser?.email ?? "")

        missionListener = query.addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching missions: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                return
            }
            
            var missions: [Mission] = []
            
            for document in documents {
                var missionData = document.data()
                missionData["documentID"] = document.documentID
                
                do {
                    let mission = try Firestore.Decoder().decode(Mission.self, from: missionData)
                    missions.append(mission)
                } catch {
                    print("Failed to parse mission data for \(document.documentID): \(error)")
                }
            }
            
            self?.missions = missions
        }
    }
}
