//
//  ClientsMissionView.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import SwiftUI

struct ClientsMissionView: View {
    @StateObject var viewModel: ClientMissionViewModel
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.notAssignedMissions.isEmpty, viewModel.assignedMissionsToValidate.isEmpty, viewModel.validatedMissions.isEmpty {
                    Text("Vous n'avez pas encore de missions à traiter")
                }
                
                if !viewModel.notAssignedMissions.isEmpty {
                    makeSectionViewFor(missions: viewModel.notAssignedMissions, title: "Mission en attente d'acceptation par un nomad")
                }
                
                if !viewModel.assignedMissionsToValidate.isEmpty {
                    makeSectionViewFor(missions: viewModel.assignedMissionsToValidate, title: "Mission à valider")
                }
                if !viewModel.validatedMissions.isEmpty {
                    makeSectionViewFor(missions: viewModel.validatedMissions, title: "Mission validée")
                }
            }
            .navigationTitle("Missions")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: viewModel.showSettings) {
                        Image(systemName: "gearshape.fill")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.showCreationSheet) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.shouldDisplaySettings) {
            SettingsView(viewModel: SettingsViewModel())
        }
        .sheet(isPresented: $viewModel.shouldDisplayCreationSheet) {
            CreateMissionView(viewModel: CreateMissionViewModel())
        }
    }
    
    func makeSectionViewFor(missions: [Mission], title: String) -> some View {
        Section(header: Text(title)) {
            ForEach(missions, id: \.self) { mission in
                NavigationLink(destination: EditMissionView(viewModel: EditMissionViewModel(mission: mission))) {
                    MissionRow(mission: mission)
                }
            }
        }
    }
}

struct ClientsMissionView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsMissionView(viewModel: ClientMissionViewModel())
    }
}
