//
//  SignUp.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import FirebaseAuth
import SwiftUI

// TODO: SignUp 1/1
// animate success and navigate to listview, maybe we can send a Passthroughsubject notification to homeview
struct SignUpView: View {
    @StateObject var viewModel: SignUpViewModel
    @FocusState private var passwordFieldFocused: Bool
    @FocusState private var emailFieldFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    enum Dimensions {
        static let verticalPadding: CGFloat = 25
    }
    
    @State private var currentPage = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: AppDimensions.verticalSpaceBetweenItems * 2) {
                Image("OuiNomad-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: geometry.size.height / 4, alignment: .center)
                    .padding(.horizontal, AppDimensions.buttonHeight)
                
                inputFields
                    .frame(height: geometry.size.height / 4, alignment: .bottom)
                
                loginBlock
                    .frame(maxHeight: geometry.size.height / 5, alignment: .top)
            }
            .frame(height: geometry.size.height)
            .commonBackground()
            .navigationBarBackButtonHidden(true)
            .statusBar(hidden: true)
            .alert(item: $viewModel.error) { errorWrapper in
                Alert(title: Text(Strings.somethingWentWrong),
                      message: Text(errorWrapper.error.localizedDescription),
                      dismissButton: .default(Text(Strings.ok)))
            }
        }
    }
    
    var createAccountLabels: some View {
        VStack {
            Text(Strings.createAccount)
            
            Text(Strings.toGetStartedNow)
        }
    }
    
    var inputFields: some View {
        VStack {
            LogField(text: $viewModel.inputEmail, title: Strings.email)
                .textContentType(.emailAddress)
                .disableAutocorrection(true)
                .focused($emailFieldFocused)

            SecureLogField(text: $viewModel.inputPassword, title: Strings.password)
                .textContentType(.password)
                .disableAutocorrection(true)
                .focused($passwordFieldFocused)

            SecureLogField(text: $viewModel.inputPassword2, title: Strings.confirmPassword)
                .textContentType(.password)
                .disableAutocorrection(true)
                .focused($passwordFieldFocused)
            
            if passwordFieldFocused && !viewModel.passwordRespectRegex{
                Text(Strings.passwordRequirement)
                    .foregroundColor(.red)
            } else if emailFieldFocused && !viewModel.emailIsValid {
                Text(Strings.provideCorrectEmail)
                    .foregroundColor(.red)
            }
        }
    }
    
    var loginBlock: some View {
        VStack {
            Button(action: viewModel.register) {
                Text(Strings.signUp)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .disabled(!viewModel.emailIsValid || !viewModel.passwordsAreValid)
            }
            .frame(maxWidth: .infinity)
            .frame(height: AppDimensions.buttonHeight)
            .background(AppDimensions.accentColor.cornerRadius(AppDimensions.cornerRadius))

            signInLabel
                .padding(.top, AppDimensions.buttonHeight)
        }
    }
    
    
    var signInLabel: some View {
        Button(action: { dismiss() }) {
            VStack {
                Text(Strings.alreadyHaveAnAccount)
                    .foregroundColor(.gray)
                
                Text(Strings.signInNow)
                    .underline()
                    .foregroundColor(AppDimensions.accentColor)
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel())
    }
}
