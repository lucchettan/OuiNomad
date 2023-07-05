//
//  CreateMissionView.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import SwiftUI

struct CreateMissionView: View {
    @StateObject var viewModel: CreateMissionViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss

    var defaultSectionBackground: Color {
        colorScheme == .dark ? .gray.opacity(0.1) : .white
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Intitulé")) {
                    TextField("Titre", text: $viewModel.title)
                }
                .listRowBackground(viewModel.isMissingInformation && viewModel.title == ""  && viewModel.showMissingFields ? Color.red.opacity(0.1) : defaultSectionBackground)
                
                Section(header: Text("Type de mission")) {
                    Picker("", selection: $viewModel.profileType) {
                        ForEach(ProfilesType.allCases, id: \.self) { profile in
                            Text(profile.rawValue)
                        }
                    }
                    .labelsHidden()
                }
                .listRowBackground(defaultSectionBackground)
                
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
                .listRowBackground(defaultSectionBackground)
                
                Section {
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
                } header: {
                    Text("Tâches")
                }
                .listRowBackground(viewModel.isMissingInformation &&
                                   viewModel.tasks.isEmpty &&
                                   viewModel.showMissingFields ? Color.red.opacity(0.1) : defaultSectionBackground)
            }
            .navigationTitle("Créer une mission")
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        if viewModel.isMissingInformation {
                            viewModel.showMissingFields = viewModel.isMissingInformation
                        } else {
                            viewModel.saveMissionToDB()
                        }
                    }) {
                        Text("Publier")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: AppDimensions.buttonHeight * 0.75)
                    .background(
                        viewModel.showMissingFields && viewModel.isMissingInformation ?
                        Color.gray.cornerRadius(AppDimensions.cornerRadius) : AppDimensions.accentColor.cornerRadius(AppDimensions.cornerRadius)
                    )
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Text("\(Image(systemName: "xmark.circle.fill"))")
                            .foregroundColor(.gray)
                            .font(.title3)
                    }
                }
            }
        }
        .onChange(of: viewModel.shouldCloseModal) { boolean in
            if boolean == true {
                dismiss()
            }
        }
    }
    

}

struct CreateMissionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMissionView(viewModel: CreateMissionViewModel())
    }
}
