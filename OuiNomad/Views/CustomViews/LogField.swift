//
//  LogField.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import SwiftUI

struct LogField: View {
    @Binding var text: String
    let title: String

    var body: some View {
        TextField(title, text: $text)
            .foregroundColor(.black)
            .padding(.vertical, AppDimensions.screenPaddingHorizontal)
            .padding(.horizontal, AppDimensions.screenPaddingHorizontal)
            .background(.regularMaterial)
            .cornerRadius(AppDimensions.cornerRadius)
    }
}

struct LogField_Previews: PreviewProvider {
    static var previews: some View {
        LogField(text: .constant("title Input"), title: "Title")
    }
}

