//
//  NomadMissionsView.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import SwiftUI

struct NomadMissionsView: View {
    @StateObject var viewModel: NomadMissionsViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Séléctionnez un type de mission:")) {
                    Picker("", selection: $viewModel.profileType) {
                        ForEach(ProfilesType.allCases, id: \.self) { profile in
                            Text(profile.rawValue)
                        }
                    }
                    .labelsHidden()
                }
                
                if viewModel.toAssignMissions.isEmpty, viewModel.assignedMissionsPending.isEmpty, viewModel.validatedMissions.isEmpty {
                    Text("Nous n'avons pas encore de missions à vous proposer")
                }
                
                if !viewModel.toAssignMissions.isEmpty {
                    makeSectionViewFor(missions: viewModel.toAssignMissions, title: "Missions disponibles")
                }
                
                if !viewModel.assignedMissionsPending.isEmpty {
                    makeSectionViewFor(missions: viewModel.assignedMissionsPending, title: "Mission en attente d'acceptation")
                }
                if !viewModel.validatedMissions.isEmpty {
                    makeSectionViewFor(missions: viewModel.validatedMissions, title: "Mission validée")
                }
            }
            .navigationTitle("Missions")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { viewModel.shouldDisplaySettings = true }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.shouldDisplaySettings) {
            SettingsView(viewModel: SettingsViewModel())
        }
    }
    
    func makeSectionViewFor(missions: [Mission], title: String) -> some View {
        Section(header: Text(title)) {
            ForEach(missions, id: \.self) { mission in
                NavigationLink(
                    destination: MissionForNomadView(
                        mission: mission,
                        acceptMission: viewModel.acceptMission(_:),
                        deAssignMission: viewModel.deAssignMission(_:))
                ) {
                    MissionRow(mission: mission)
                }
            }
        }
    }
}

struct NomadMissionsView_Previews: PreviewProvider {
    static var previews: some View {
        NomadMissionsView(viewModel: NomadMissionsViewModel())
    }
}
