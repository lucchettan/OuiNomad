//
//  SignInView.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import FirebaseAuth
import SwiftUI

// TODO: SignIn
struct SignInView: View {
    @StateObject var viewModel: SignInViewModel
    @Environment(\.dismiss) var dismiss

    enum Dimensions {
        static let verticalPadding: CGFloat = 25
        static let paddingTraillingForgetPassword: CGFloat = -10
        static let paddingTopForgetPassword: CGFloat = 5
        static let offsetInScreenforgetPasswordSheet: CGFloat = 50
        static let offsetOffScreenforgetPasswordSheet: CGFloat = UIScreen.main.bounds.height
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
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
                    .overlay {
                        if viewModel.presentForgotPasswordAlert {
                            Button(action: viewModel.dismissForgetPassword) {
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
                }
                
                forgetPasswordSheet
            }
        }
    }
    
    var welcomeLabels: some View {
        VStack {
            Text(Strings.welcome)
            
            Text(Strings.gladToSeeYou)
        }
    }
    
    var inputFields: some View {
        VStack(alignment: .trailing) {
            LogField(text: $viewModel.inputEmail, title: Strings.email)
                .textContentType(.emailAddress)
                .disableAutocorrection(true)
                .submitLabel(.next)
            
            SecureLogField(text: $viewModel.inputPassword, title: Strings.password)
                .textContentType(.password)
                .disableAutocorrection(true)
                .submitLabel(.continue)
                .onSubmit {
                    viewModel.login()
                }
            
            forgetPassword
        }
    }
    
    var forgetPassword: some View {
        Button(action: viewModel.requestForgetPassword) {
            Text(Strings.forgotPassword)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var forgetPasswordSheet: some View {
        VStack(alignment: .leading) {
            Text(Strings.forgotPassword)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, AppDimensions.screenPaddingHorizontal * 2)
            
            Spacer()
            
            Text(Strings.pleaseProvideEmailToResetPassword)
            
            LogField(text: $viewModel.forgotPasswordInput, title: Strings.email)
            
            Spacer()
            
            HStack(spacing: AppDimensions.verticalSpaceBetweenItems) {
                Button(action: viewModel.dismissForgetPassword) {
                    Text(Strings.cancel)
                }
                    .frame(maxWidth: .infinity)
                    .customButtonStyle()
                Button(action: viewModel.submitForgetPasswordRequest) {
                    Text(Strings.reset)
                }
                    .frame(maxWidth: .infinity)
                    .customButtonStyle()
            }
            Spacer()
        }
        .foregroundColor(.black)
        .frame(height: 375)
        .edgesIgnoringSafeArea(.horizontal)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, AppDimensions.screenPaddingHorizontal)
        .background(Color.white.cornerRadius(AppDimensions.cornerRadius * 2))
        .offset(y: viewModel.presentForgotPasswordAlert ? Dimensions.offsetInScreenforgetPasswordSheet : Dimensions.offsetOffScreenforgetPasswordSheet)
    }
    
    var loginBlock: some View {
        VStack {
            Button(action: viewModel.login) {
                Text(Strings.login)
                    .foregroundColor(.white)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity)
                    .disabled(viewModel.inputEmail.isEmpty || viewModel.inputPassword.isEmpty || !viewModel.emailIsValid)
            }
            .frame(maxWidth: .infinity)
            .frame(height: AppDimensions.buttonHeight)
            .background(AppDimensions.accentColor.cornerRadius(AppDimensions.cornerRadius))
            .alert(item: $viewModel.error) { errorWrapper in
                Alert(title: Text(Strings.somethingWentWrong),
                      message: Text(errorWrapper.error.localizedDescription),
                      dismissButton: .default(Text(Strings.ok)))
            }
            
//            Text(Strings.orLoginWith)
                        
//            HStack {
//                Button(action: {}) {
//                    Text(Strings.apple)
//                        .frame(maxWidth: .infinity)
//                }
//                .customButtonStyle(height: AppDimensions.buttonHeight / 2)
//
//                Button(action: {}) {
//                    Text(Strings.google)
//                        .frame(maxWidth: .infinity)
//                }
//                .customButtonStyle(height: AppDimensions.buttonHeight / 2)
//
//                Button(action: {}) {
//                    Text(Strings.facebook)
//                        .frame(maxWidth: .infinity)
//                }
//                .customButtonStyle(height: AppDimensions.buttonHeight / 2)
//            }
            Spacer()
            
            signUpLabel
                .padding(.top, AppDimensions.buttonHeight)
        }
    }
    
    var signUpLabel: some View {
        NavigationLink(destination: SignUpView(viewModel: SignUpViewModel())) {
            VStack {
                Text(Strings.noAccountYet + " ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                +
                Text(Strings.registerNow)
                    .underline()
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(AppDimensions.accentColor)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel())
    }
}
