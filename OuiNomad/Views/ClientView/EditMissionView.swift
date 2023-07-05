//
//  EditMissionView.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 03/07/2023.
//

import SwiftUI

struct EditMissionView: View {
    @StateObject var viewModel: EditMissionViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Intitulé")) {
                    TextField("Titre", text: $viewModel.title)
                }
                
                Section(header: Text("Type de mission")) {
                    Picker("", selection: $viewModel.profileType) {
                        ForEach(ProfilesType.allCases, id: \.self) { profile in
                            Text(profile.rawValue)
                        }
                    }
                    .labelsHidden()
                }
                
                Section(header: Text("Dates")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Début")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            DatePicker("", selection: $viewModel.start, displayedComponents: .date)
                                .labelsHidden()
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Fin")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            DatePicker("", selection: $viewModel.end, displayedComponents: .date)
                                .labelsHidden()
                        }
                    }
                }
                
                Section(header: Text("Tâches")) {
                    ForEach(viewModel.tasks, id: \.self) { task in
                        Text(task)
                    }
                    .onDelete(perform: viewModel.deleteTask)
                    
                    HStack {
                        TextField("Nouvelle tâche", text: $viewModel.newTask)
                        
                        Button(action: viewModel.addTask) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(viewModel.newTask.isEmpty)
                    }
                }
                
                if let assignedNomad = viewModel.nomadUser{
                    Section(header: Text("Nomad assigné")) {
                        Text("\(assignedNomad.nomNomad ?? "") \(assignedNomad.prenom ?? "")")
                        Text("Taux horraire: \(assignedNomad.tauxHorraire ?? "")€")

                        if  !viewModel.mission.isValidated {
                            Button("Refuser", action: viewModel.refuseNomad)
                                .foregroundColor(.white)
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: AppDimensions.buttonHeight * 0.75)
                                .background(Color.red.cornerRadius(AppDimensions.cornerRadius))
                            
                            
                            Button("Accepter", action: viewModel.acceptNomad)
                                .foregroundColor(.white)
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity)
                                .frame(height: AppDimensions.buttonHeight * 0.75)
                                .background(Color.green.cornerRadius(AppDimensions.cornerRadius))
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                
                if viewModel.mission.isValidated {
                    Section(header: Text("Validation")) {
                        Toggle("Est validée", isOn: $viewModel.isValidated)
                    }
                    
                    Section {
                        Button("Sauvegarder", action: {
                            viewModel.isValidated ? viewModel.updateMission() : viewModel.refuseNomad()
                            dismiss()
                        })
                        .foregroundColor(.white)
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .frame(height: AppDimensions.buttonHeight)
                        .background(AppDimensions.accentColor.cornerRadius(AppDimensions.cornerRadius))
                    }
                    .listRowBackground(Color.clear)
                }
            }
        }
        .navigationTitle("Mission")
        .listStyle(InsetGroupedListStyle())
    }
}

struct EditMissionView_Previews: PreviewProvider {
    static var previews: some View {
        EditMissionView(viewModel: EditMissionViewModel(mission: Mission()))
    }
}
