//
//  UserClient.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import Foundation

struct UserClient: Codable {
    var userType: UserType
    var nomClient: String?
    var adresse: String?
    var zipcode: String?
    var pays: String?
    var email: String?
    var documentID: String? = ""
}

extension UserClient {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "userType": userType.rawValue,
            "nomClient": nomClient ?? "",
            "adresse": adresse ?? "",
            "zipcode": zipcode ?? "",
            "pays": pays ?? "",
            "email": email ?? "",
            "documentID": documentID ?? ""
        ]
        
        // Remove empty values
        dict = dict.filter { !($0.value is String) || !($0.value as! String).isEmpty }
        
        return dict
    }
}
