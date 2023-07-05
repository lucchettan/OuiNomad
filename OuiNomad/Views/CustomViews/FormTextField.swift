//
//  FormTextField.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import SwiftUI

struct FormTextField: View {
    @Binding var text: String
    let title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .foregroundColor(.gray)
                .padding(.horizontal, AppDimensions.screenPaddingHorizontal)
                .padding(.top, AppDimensions.screenPaddingHorizontal / 2)
            
            TextField("", text: $text)
                .foregroundColor(.black)
                .padding(.horizontal, AppDimensions.screenPaddingHorizontal)
                .padding(.bottom, AppDimensions.screenPaddingHorizontal / 2)
                .disableAutocorrection(true)
        }
        .background(Color.gray.opacity(0.1).cornerRadius(AppDimensions.cornerRadius))
    }
}

struct FormTextField_Previews: PreviewProvider {
    static var previews: some View {
        FormTextField(text: .constant("title Input"), title: "Title")
    }
}
