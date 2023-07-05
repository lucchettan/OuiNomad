//
//  CurrentUserManager.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class CurrentUserManager: ObservableObject {
    @Published var storedUser: User?
    
    @Published var deviceToken: String?
    
    @Published var clientUser: UserClient? {
        didSet {
            if clientUser != nil {
                // User type is client
                userType = .client
            }
        }
    }
    
    @Published var nomadUser: UserNomad? {
        didSet {
            if nomadUser != nil {
                // User type is nomad
                userType = .nomad
            }
        }
    }
    
    @Published var userType: UserType?
    
    func ObserveForLoggedInUser(action: @escaping (User?) -> Void) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.storedUser = user
                print("Success: User is ALREADY LOGGED IN", user)
                self.fetchUserType()
            } else {
                print("OFF: User is logged out")
            }
            
            action(user)
        }
    }
    
    func logIn(email: String, password: String, completion: @escaping (Result<User?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login Error: ", error.localizedDescription)
                completion(.failure(error))
            } else {
                completion(.success(result?.user))
                self.fetchUserType()
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<User?, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Register Error: ", error.localizedDescription)
                completion(.failure(error))
            } else {
                print("Register Success: ", result?.user as Any)
                completion(.success(result?.user))
            }
        }
    }
    
    func logOff() {
        do {
            try Auth.auth().signOut()
            print("User signed off")
            UserDefaults.standard.removeObject(forKey: "UserType")
            storedUser = nil
            clientUser = nil
            nomadUser = nil
            deviceToken = nil
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func submitForgetPasswordRequest(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Login Error: ", error.localizedDescription)
            }
        }
    }
}

// MARK: UserType Process
extension CurrentUserManager {
    // MARK: UserType Process
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
                 var data = document.data()
                 data["documentID"] = document.documentID

                 if let userType = data["userType"] as? String {
                     if userType == "client" {
                         // Decode UserClient object from Firestore data
                         if let userClientData = try? JSONSerialization.data(withJSONObject: data, options: []),
                            let userClient = try? JSONDecoder().decode(UserClient.self, from: userClientData) {
                             self.clientUser = userClient
                         }
                     } else if userType == "nomad" {
                         // Decode UserNomad object from Firestore data
                         if let userNomadData = try? JSONSerialization.data(withJSONObject: data, options: []),
                            let userNomad = try? JSONDecoder().decode(UserNomad.self, from: userNomadData) {
                             self.nomadUser = userNomad
                         }
                     }
                 }
             }
         }
     }
}
