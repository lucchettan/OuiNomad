//
//  SettingsView.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            if let user = viewModel.userManager.nomadUser {
                nomadDetails
                    .navigationTitle("Mes informations")
            } else if let user = viewModel.userManager.clientUser {
                clientDetails
                    .navigationTitle("Mes informations")
            }
        }
    }
    
    var nomadDetails: some View {
        List {
            Section(header: Text("Nom")) {
                TextField("", text: $viewModel.nomadNom)
            }
            
            Section(header: Text("Prénom")) {
                TextField("", text: $viewModel.nomadPrenom)
            }
            
            Section(header: Text("Taux horraire")) {
                TextField("", text: $viewModel.tauxHorraire)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("N° Professionnel ")) {
                TextField("", text: $viewModel.iban)
                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("IBAN")) {
                TextField("", text: $viewModel.numeroProfessionnel)
                    .keyboardType(.numberPad)
            }
            
            Button("Se déconnecter", action: viewModel.userManager.logOff)
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: AppDimensions.buttonHeight * 0.75)
                .frame(maxWidth: UIScreen.main.bounds.width / 2)
                .background(Color.black.cornerRadius(AppDimensions.cornerRadius))
                .listRowBackground(Color.clear)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Sauvegarder", action: {
                    viewModel.updateUser()
                    dismiss()
                })
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(height: AppDimensions.buttonHeight)
                    .frame(maxWidth: .infinity)
                    .background(AppDimensions.accentColor.cornerRadius(AppDimensions.cornerRadius))
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
    
    var clientDetails: some View {
        List {
            Section(header: Text("Nom")) {
                TextField("", text: $viewModel.clientNom)
            }
            
            Section(header: Text("Adresse(Numéro et rue)")) {
                TextField("", text: $viewModel.adresse)
            }
            
            Section(header: Text("Code Postal")) {
                TextField("", text: $viewModel.zipcode)
            }
            
            Section(header: Text("Pays")) {
                TextField("", text: $viewModel.pays)
            }
            
            Button("Se déconnecter", action: viewModel.userManager.logOff)
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: AppDimensions.buttonHeight * 0.75)
                .frame(maxWidth: UIScreen.main.bounds.width / 2)
                .background(Color.black.cornerRadius(AppDimensions.cornerRadius))
                .listRowBackground(Color.clear)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Sauvegarder", action: {
                    viewModel.updateUser()
                    dismiss()
                })
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(height: AppDimensions.buttonHeight)
                    .frame(maxWidth: .infinity)
                    .background(AppDimensions.accentColor.cornerRadius(AppDimensions.cornerRadius))
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
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: SettingsViewModel())
    }
}
