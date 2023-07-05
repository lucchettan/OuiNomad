//
//  SignUpViewModel.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import FirebaseAuth
import SwiftUI

// TODO: SignUpViewModel 2/2
// Handle ERRORS
// setup alert process to submit forget password make sure the input email is filled with an alert if not
class SignUpViewModel: ObservableObject {
    @Published var inputEmail: String = ""
    @Published var inputPassword: String = ""
    @Published var inputPassword2: String = ""
    @Published var isFocusOnPassword = false
    @Published var error: ErrorWrapper?
    @Published var userType: UserType?
    
    var passwordRespectRegex: Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        
        return passwordPredicate.evaluate(with: inputPassword)
    }
    
    var passwordsAreValid: Bool {
        passwordRespectRegex && !inputPassword.isEmpty && inputPassword == inputPassword2
    }
    
    var emailIsValid: Bool {
        let emailRegexPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegexPattern)
        return emailPredicate.evaluate(with: inputEmail)
    }
    
    let userManager: CurrentUserManager
    
    init(userManager: CurrentUserManager = Dependencies.shared.userManager) {
        self.userManager = userManager
    }
    
    func register() {
        userManager.register(email: inputEmail, password: inputPassword) { result in
            switch result {
            case .success( _):
                break
            case .failure(let error):
                self.error = ErrorWrapper(error: error)
            }
        }
    }
}
