//
//  NomadMissionsViewModel.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 03/07/2023.
//

import CoreLocation
import Firebase
import SwiftUI

class NomadMissionsViewModel: NSObject, ObservableObject {
    let userManager: CurrentUserManager
    let firestore: Firestore
    
    var missionListener: ListenerRegistration?
    
    let locationManager: CLLocationManager
    
    @Published var missions: [Mission] = []
    @Published var shouldDisplaySettings = false
    @Published var shouldDisplayMissionSheet = false
    
    @Published var profileType: ProfilesType = .serveur
    
    var toAssignMissions: [Mission] {
        missions.filter {
            $0.assignedNomadEmail == "" &&
            $0.start ?? Date() >= Date() &&
            (profileType == .all || $0.profileType == profileType.rawValue)
        }
        //.filterByProximity(to: locationManager.location)
        // TODO: Uncomment the proximity filter for release
    }
    
    var assignedMissionsPending: [Mission] {
        missions.filter { $0.assignedNomadEmail == userManager.storedUser?.email && !$0.isValidated}
    }
    
    var validatedMissions: [Mission] {
        missions.filter { $0.isValidated && $0.assignedNomadEmail == userManager.storedUser?.email }
    }

    init(dependencies: Dependencies = Dependencies.shared) {
        self.userManager = dependencies.userManager
        self.firestore = dependencies.fireStore
        self.locationManager = CLLocationManager()
        
        super.init()
        
        startObservingNomadMissions()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
     }

    func startObservingNomadMissions() {
        let collectionRef = firestore.collection("Missions")
        let query = collectionRef.whereField("assignedNomadEmail", in: ["", Auth.auth().currentUser?.email ?? ""])
                                 .whereField("start", isGreaterThan: Date())
        
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
     
     deinit {
         missionListener?.remove()
     }
    
    func updateMission(_ mission: Mission) {
        guard let missionID = mission.documentID else {
            print("Mission ID is nil")
            return
        }
        
        let missionRef = Firestore.firestore().collection("Missions").document(missionID)
        
        missionRef.setData(mission.toDictionary()) { error in
            if let error = error {
                print("Error updating mission: \(error.localizedDescription)")
            } else {
                print("Mission updated successfully")
            }
        }
    }
    
    func acceptMission(_ mission: Mission) {
        var missionToUpdate = mission
        missionToUpdate.assignedNomadEmail = Auth.auth().currentUser?.email
        missionToUpdate.nomadFCMToken = userManager.deviceToken

        updateMission(missionToUpdate)
        
        // Trigger notification to the user
        if let deviceToken = mission.clientFCMToken {
            NotificationManager.sendNotificationToUser(deviceToken: deviceToken, notificationType: .attributed, missionTitle: mission.title)
        }
    }
    
    func deAssignMission(_ mission: Mission) {
        var missionToUpdate = mission
        missionToUpdate.assignedNomadEmail = ""
        missionToUpdate.isValidated = false
        missionToUpdate.nomadFCMToken = ""
        updateMission(missionToUpdate)
        
        if mission.isValidated, let deviceToken = mission.clientFCMToken {
            NotificationManager.sendNotificationToUser(deviceToken: deviceToken, notificationType: .cancelled, missionTitle: mission.title)
        }
    }
}

// MARK: Location process
extension NomadMissionsViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            // Handle the case where location authorization is denied or restricted
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // Use the user's current location
            // location.coordinate.latitude
            // location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location update errors
    }
}

