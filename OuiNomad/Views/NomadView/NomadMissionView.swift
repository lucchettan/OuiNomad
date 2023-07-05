//
//  MissionForNomadView.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 03/07/2023.
//

import CoreLocation
import Firebase
import SwiftUI

struct MissionForNomadView: View {
    @State var mission: Mission
    
    var acceptMission: (Mission) -> Void
    var deAssignMission: (Mission) -> Void

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Intitulé")) {
                    Text(mission.title ?? "")
                }
                
                Section(header: Text("Type de mission")) {
                    Text(mission.profileType ?? "")
                }
                
                Section(header: Text("Dates")) {
                    Text("\(mission.start?.asCalendarDate() ?? "") - De \(mission.start?.asHour() ?? "") à \(mission.end?.asHour() ?? "")")
                        .font(.subheadline)
                }
                
                Section(header: Text("Tâches")) {
                    ForEach(mission.tasks, id: \.self) { task in
                        Text(task)
                    }
                }
                
                if let latitude = mission.location?.latitude, let longitude = mission.location?.longitude {
                    Section(header: adressLabel) {
                        MiniMapView(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                            .frame(height: 200)
                            .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    if let assignedNomadEmail = mission.assignedNomadEmail {
                        if mission.assignedNomadEmail == Auth.auth().currentUser?.email {
                            Button("Annuler la mission", action: {
                                deAssignMission(mission)
                                presentationMode.wrappedValue.dismiss()
                            })
                            .foregroundColor(.white)
                            .font(.title3.bold())
                            .frame(height: AppDimensions.buttonHeight)
                            .frame(maxWidth: .infinity)
                            .background(Color.red.cornerRadius(AppDimensions.cornerRadius))
                        } else {
                            Button(action: {
                                acceptMission(mission)
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Accepter la mission")
                            }
                            .foregroundColor(.white)
                            .font(.title3.bold())
                            .frame(height: AppDimensions.buttonHeight)
                            .frame(maxWidth: .infinity)
                            .background(Color.green.cornerRadius(AppDimensions.cornerRadius))
                        }
                    }
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Mission")
    }
    
    private var adressLabel: some View {
        Text("\(mission.adress ?? ""), \(mission.zipcode ?? "") \(mission.country ?? "")")
    }
}

struct MissionForNomadView_Previews: PreviewProvider {
    static var previews: some View {
        MissionForNomadView(mission: Mission(), acceptMission: {_ in }, deAssignMission: {_ in })
    }
}
