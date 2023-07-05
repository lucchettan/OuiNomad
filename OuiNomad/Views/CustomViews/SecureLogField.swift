//
//  SecureLogField.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import SwiftUI

struct SecureLogField: View {
    @Binding var text: String
    let title: String

    var body: some View {
        SecureField(title, text: $text)
            .foregroundColor(.black)
            .padding(.vertical, AppDimensions.screenPaddingHorizontal)
            .padding(.horizontal, AppDimensions.screenPaddingHorizontal)
            .background(.regularMaterial)
            .cornerRadius(AppDimensions.cornerRadius)
    }
}

struct SecureLogField_Previews: PreviewProvider {
    static var previews: some View {
        SecureLogField(text: .constant("title Input"), title: "Title")
    }
}
