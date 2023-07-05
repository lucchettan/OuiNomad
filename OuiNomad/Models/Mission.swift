//
//  Mission.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import Firebase
import Foundation

struct Mission: Codable, Hashable {
    var documentID: String?
    var title: String?
    var start: Date?
    var end: Date?
    var tasks: [String] = []
    var profileType: String?
    var clientEmail: String?
    var assignedNomadEmail: String?
    var isValidated: Bool = false
    var location: GeoPoint?
    var adress: String?
    var zipcode: String?
    var country: String?
    var clientFCMToken: String? = ""
    var nomadFCMToken: String? = ""
}
// a changer ->
// - creer une serie de donnees dans la DB pour les types de profil
// - le faire choisir a l'utilisateur quand il cree son compte
// - le faire selectionner au client quand il cree une mission avec un getProfileTypes()

import Firebase

extension Mission {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "title": title ?? ""
        ]
        
        if let start = start {
            dict["start"] = Timestamp(date: start)
        }
        
        if let end = end {
            dict["end"] = Timestamp(date: end)
        }
        
        dict["tasks"] = tasks
        dict["profileType"] = profileType ?? ""
        dict["clientEmail"] = clientEmail ?? ""
        dict["assignedNomadEmail"] = assignedNomadEmail ?? ""
        dict["isValidated"] = isValidated
        dict["adress"] = adress
        dict["zipcode"] = zipcode
        dict["country"] = country
        dict["clientFCMToken"] = clientFCMToken
        dict["nomadFCMToken"] = nomadFCMToken

        if let latitude = location?.latitude, let longitude = location?.longitude {
            dict["location"] = GeoPoint(latitude: latitude, longitude: longitude)
        }
        
        return dict
    }
}

import CoreLocation

extension Array where Element == Mission {
    func filterByProximity(to userLocation: CLLocation?) -> [Mission] {
        guard let location = userLocation else {
            return self
        }
        
        return self.filter { mission in
            guard let missionLocation = mission.location else {
                return false
            }

            let missionCLLocation = CLLocation(latitude: missionLocation.latitude, longitude: missionLocation.longitude)
            let distance = location.distance(from: missionCLLocation)

            return distance <= 50000 // 50 kilometers in meters
        }
    }
}
