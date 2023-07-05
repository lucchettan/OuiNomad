//
//  SignInViewModel.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import FirebaseAuth
import SwiftUI

// TODO: Steps
// disconnect user and remove it from user default
// Handle ERRORS

class SignInViewModel: ObservableObject {
    @Published var presentForgotPasswordAlert: Bool = false
    @Published var inputEmail: String = ""
    @Published var forgotPasswordInput: String = ""
    @Published var inputPassword: String = ""
    @Published var error: ErrorWrapper?
    
    var emailIsValid: Bool {
        let emailRegexPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegexPattern)
        return emailPredicate.evaluate(with: inputEmail)
    }
    
    var passwordRespectRegex: Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        return passwordPredicate.evaluate(with: inputPassword)
    }
    
    let userManager: CurrentUserManager
    
    init(userManager: CurrentUserManager = Dependencies.shared.userManager) {
        self.userManager = userManager
    }
    
    func login() {
        userManager.logIn(email: inputEmail, password: inputPassword) { result in
            switch result {
            case .success( _):
                break
            case .failure(let error):
                self.error = ErrorWrapper(error: error)
            }
        }
        
    }
    
    func requestForgetPassword() {
        withAnimation(.spring()) {
            presentForgotPasswordAlert = true
        }
    }
    
    func dismissForgetPassword() {
        withAnimation(.spring()) {
            presentForgotPasswordAlert = false
        }
    }
    
    func submitForgetPasswordRequest() {
        userManager.submitForgetPasswordRequest(email: forgotPasswordInput)
        // TODO: handle errors from submit forget password and propose to open mail on success
        dismissForgetPassword()
    }
}
