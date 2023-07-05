//
//  ProfilesType.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 03/07/2023.
//

import Foundation

enum ProfilesType: String, Codable, CaseIterable {
    case maitreNageur = "Maitre nageur"
    case serveur = "Serveur"
    case cuisinier = "Cuisinier"
    case agentDaccueil = "Agent d'accueil"
    case agentDeMenage = "Agent de ménage"
    case all = "Toutes les missions"
}
