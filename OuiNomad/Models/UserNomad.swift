//
//  UserNomad.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import Foundation

struct UserNomad: Codable {
    var userType: UserType
    var nomNomad: String?
    var prenom: String?
    var tauxHorraire: String?
    var numeroProfessionnel: String?
    var iban: String?
    var email: String?
    var documentID: String? = ""
}

extension UserNomad {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "userType": userType.rawValue,
            "nomNomad": nomNomad ?? "",
            "prenom": prenom ?? "",
            "tauxHorraire": tauxHorraire ?? "",
            "numeroProfessionnel": numeroProfessionnel ?? "",
            "iban": iban ?? "",
            "email": email ?? "",
            "documentID": documentID ?? ""
        ]
        
        // Remove empty values
        dict = dict.filter { !($0.value is String) || !($0.value as! String).isEmpty }
        
        return dict
    }
}
