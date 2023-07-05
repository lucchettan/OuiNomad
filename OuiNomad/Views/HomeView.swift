//
//  HomeView.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        VStack {
            if viewModel.userManager.storedUser != nil {
                if viewModel.userClient != nil {
                    ClientsMissionView(viewModel: ClientMissionViewModel())
                } else if viewModel.userNomad != nil  {
                    NomadMissionsView(viewModel: NomadMissionsViewModel())
                } else {
                    OnboardingScreen(viewModel: OnboardingScreenViewModel())
                }
            } else {
                SignInView(viewModel: SignInViewModel())
            }
        }
            .onAppear {
                viewModel.userManager.ObserveForLoggedInUser { user in
                    viewModel.userLoggedIn = user != nil
                }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
