//
//  MissionRow.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import SwiftUI

struct MissionRow: View {
    var mission: Mission
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(mission.title ?? "")
                    .font(.headline)
                
                Text("\(mission.start?.asCalendarDate() ?? "") - De \(mission.start?.asHour() ?? "") à \(mission.end?.asHour() ?? "")")
                    .font(.caption)
            }
            
            Spacer()
        }
        .foregroundColor(mission.assignedNomadEmail == nil ? .red : .primary)
        .border(mission.assignedNomadEmail == nil ? Color.red : Color.clear)
    }
}
