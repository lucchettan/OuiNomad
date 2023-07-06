//
//  EditMissionView.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 03/07/2023.
//

import SwiftUI

struct EditMissionView: View {
    @StateObject var viewModel: EditMissionViewModel
    
    @State var showDeleteAlert = false
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
                    VStack(alignment: .leading) {
                        HStack {
                            DatePicker("Le", selection: $viewModel.start, displayedComponents: [.date])
                                .frame(maxHeight: .infinity, alignment: .top)
                                .padding(.top, 8)

                            Spacer()
                            
                            VStack {
                                DatePicker("De", selection: $viewModel.start, in: viewModel.start..., displayedComponents: [.hourAndMinute])
                                
                                DatePicker("À", selection: $viewModel.end, in: viewModel.start..., displayedComponents: [.hourAndMinute])
                            }
                            .frame(width: 150)
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
                
                Button(action: { self.showDeleteAlert.toggle() }) {
                    Text("\(Image(systemName: "trash")) Supprimer la mission")
                }
                .foregroundColor(.red)
                .frame(height: AppDimensions.buttonHeight * 0.5)
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Supprimer la mission"),
                    message: Text("Êtes vous sûre de vouloir supprimer cette mission?"),
                    primaryButton: .destructive(Text("Supprimer"), action: viewModel.deleteMission),
                    secondaryButton: .cancel(Text("Annuler"))
                )
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
