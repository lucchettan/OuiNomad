//
//  EditMissionViewModel.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 03/07/2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseFirestore

class EditMissionViewModel: ObservableObject {
    let userManager: CurrentUserManager
    let firestore: Firestore
    
    @Published var mission: Mission
    
    @Published var title = ""
    @Published var start = Date()
    @Published var end = Date()
    @Published var tasks: [String] = []
    @Published var profileType: ProfilesType = .agentDeMenage
    @Published var newTask = ""
    @Published var isValidated: Bool
    @Published var nomadUser: UserNomad?
    
    init(dependencies: Dependencies = Dependencies.shared, mission: Mission) {
        self.userManager = dependencies.userManager
        self.firestore = dependencies.fireStore
        
        self.mission = mission
        self.title = mission.title ?? ""
        self.start = mission.start ?? Date()
        self.tasks = mission.tasks
        self.profileType = ProfilesType(rawValue: mission.profileType ?? "Serveur") ?? .maitreNageur
        self.isValidated = mission.isValidated
        
        if let nomadEmail = mission.assignedNomadEmail {
            fetchUserNomad(email: nomadEmail) { userNomad in
                self.nomadUser = userNomad
            }
        }
    }
    
    func addTask() {
        tasks.append(newTask)
        newTask = ""
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func fetchUserNomad(email: String, completion: @escaping (UserNomad?) -> Void) {
        let collectionRef = Firestore.firestore().collection("users")
        let query = collectionRef.whereField("email", isEqualTo: email)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(nil)
                return
            }
            
            guard let documentData = documents.first?.data() else {
                completion(nil)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: documentData, options: [])
                let userNomad = try JSONDecoder().decode(UserNomad.self, from: jsonData)
                completion(userNomad)
            } catch {
                print("Failed to decode user data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func updateMission() {
        self.mission.title = title
        self.mission.start = start
        self.mission.end = end
        self.mission.tasks = tasks
        self.mission.isValidated = isValidated
        self.mission.profileType = profileType.rawValue
        
        self.mission.assignedNomadEmail = isValidated ? self.mission.assignedNomadEmail : ""
        
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
    
    func acceptNomad() {
        isValidated = true
        updateMission()
        
        if let deviceToken = mission.nomadFCMToken {
            NotificationManager.sendNotificationToUser(deviceToken: deviceToken, notificationType: .accepted, missionTitle: mission.title)
        } else {
            print("No nomad token saved")
        }
    }
    
    func refuseNomad() {
        if let deviceToken = mission.nomadFCMToken {
            NotificationManager.sendNotificationToUser(deviceToken: deviceToken, notificationType: .cancelled, missionTitle: mission.title)
        } else {
            print("No nomad token saved")
        }
        
        isValidated = false
        self.mission.nomadFCMToken = ""
        updateMission()
    }
    
    func deleteMission() {
         guard let missionID = mission.documentID else {
             print("Mission ID is nil")
             return
         }
        
        if let deviceToken = mission.nomadFCMToken {
            NotificationManager.sendNotificationToUser(deviceToken: deviceToken, notificationType: .deleted, missionTitle: mission.title)
        }
         
         let missionRef = Firestore.firestore().collection("Missions").document(missionID)
         
         missionRef.delete { error in
             if let error = error {
                 print("Error deleting mission: \(error.localizedDescription)")
             } else {
                 print("Mission deleted successfully")
             }
         }
     }
}
