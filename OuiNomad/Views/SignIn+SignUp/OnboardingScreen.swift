//
//  OnboardingScreen.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import SwiftUI

struct OnboardingScreen: View {
    @StateObject var viewModel: OnboardingScreenViewModel
    
    var body: some View {
        List {
            // Titre
            Section {
                VStack {
                    Text("Félicitations,")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    
                    Text("Votre compte a bien été créé!")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            // UserType Selection
            Section {
                Text("Vous désirez utiliser l'application en tant que:")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: { viewModel.setUserType(with: .client) }) {
                    Text("Client")
                        .foregroundColor(viewModel.userType == .client ? .white : .black)
                }
                .frame(maxWidth: .infinity)
                .customButtonStyle()
                .background(viewModel.userType == .client ? Color.black.cornerRadius(AppDimensions.cornerRadius) : Color.white.cornerRadius(AppDimensions.cornerRadius))
                
                Button(action: { viewModel.setUserType(with: .nomad) }) {
                    Text("Nomad")
                        .foregroundColor(viewModel.userType == .nomad ? .white : .black)
                }
                .frame(maxWidth: .infinity)
                .customButtonStyle()
                .background(viewModel.userType == .nomad ? Color.black.cornerRadius(AppDimensions.cornerRadius) : Color.white.cornerRadius(AppDimensions.cornerRadius))
            }
            .listRowSeparator(.hidden)
            
            // Formulaire
            if let userType = viewModel.userType {
                Section {
                    switch userType {
                    case .nomad:
                        nomadForm
                    case .client:
                        clientForm
                    }
                    
                    Button("Commencer", action: viewModel.saveUserInfo)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppDimensions.buttonHeight)
                        .background(AppDimensions.accentColor.cornerRadius(AppDimensions.cornerRadius))
                }
                .listRowSeparator(.hidden)
            }
        }
    }
    
    var clientForm: some View {
        VStack {
            FormTextField(text: $viewModel.nomClient, title: "Nom")
                .mandatoryField(condition: viewModel.shouldAlertForMissingField && viewModel.informationIsMissing && viewModel.nomClient == "")
            
            FormTextField(text: $viewModel.adresse, title: "adresse")
                .mandatoryField(condition: viewModel.shouldAlertForMissingField && viewModel.informationIsMissing && viewModel.adresse == "")
            
            FormTextField(text: $viewModel.zipcode, title: "Code postal")
                .mandatoryField(condition: viewModel.shouldAlertForMissingField && viewModel.informationIsMissing && viewModel.zipcode == "")
            
            FormTextField(text: $viewModel.pays, title: "Pays")
                .mandatoryField(condition: viewModel.shouldAlertForMissingField && viewModel.informationIsMissing && viewModel.pays == "")
            
        }
    }
    
    var nomadForm: some View {
        VStack {
            FormTextField(text: $viewModel.nomNomad, title: "Nom")
                .mandatoryField(condition: viewModel.shouldAlertForMissingField && viewModel.informationIsMissing && viewModel.nomNomad == "")
            
            FormTextField(text: $viewModel.prenom, title: "Prenom")
                .mandatoryField(condition: viewModel.shouldAlertForMissingField && viewModel.informationIsMissing && viewModel.prenom == "")
                .keyboardType(.numberPad)
            FormTextField(text: $viewModel.tauxHorraire, title: "Taux Horraire")
                .mandatoryField(condition: viewModel.shouldAlertForMissingField && viewModel.informationIsMissing && viewModel.tauxHorraire == "")
                .keyboardType(.numberPad)

            FormTextField(text: $viewModel.numeroProfessionnel, title: "N° Professionnel")
                .mandatoryField(condition: viewModel.shouldAlertForMissingField && viewModel.informationIsMissing && viewModel.numeroProfessionnel == "")
                .keyboardType(.numberPad)

            FormTextField(text: $viewModel.iban, title: "IBAN")
                .mandatoryField(condition: viewModel.shouldAlertForMissingField && viewModel.informationIsMissing && viewModel.iban == "")
                .keyboardType(.numberPad)
        }
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(viewModel: OnboardingScreenViewModel())
    }
}
