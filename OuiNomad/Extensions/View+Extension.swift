//
//  View+Extension.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    var height: CGFloat
    var withoutStroke: Bool
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
//            .font(Fonts.Bold.body1)
            .frame(height: height)
            .padding(.horizontal, AppDimensions.screenPaddingHorizontal)
            .background(Color.clear.cornerRadius(AppDimensions.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                    .stroke(withoutStroke ? Color.clear : Color.black, lineWidth: 1)
            )
    }
}

extension View {
    func customButtonStyle(height: CGFloat = AppDimensions.buttonHeight, withoutStroke: Bool = false) -> some View {
        self.modifier(ButtonModifier(height: height, withoutStroke: withoutStroke))
    }

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct CommonBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .edgesIgnoringSafeArea(.all)
            .padding(.horizontal, AppDimensions.screenPaddingHorizontal)
            .background(Color.white)
    }
}

extension View {
    func commonBackground() -> some View {
        self.modifier(CommonBackgroundModifier())
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 1)
            )
            .padding(.horizontal, 5)
    }
}

struct BlurModifier: ViewModifier {
    var style: UIBlurEffect.Style = .systemThinMaterial

    func body(content: Content) -> some View {
        content
            .background(VisualEffectView(style: style))
    }
}

struct VisualEffectView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        // No updates needed
    }
}

extension View {
    func blurBackground(style: UIBlurEffect.Style = .systemThinMaterial) -> some View {
        self.modifier(BlurModifier(style: style))
    }
}

struct ConditionalBorderModifier: ViewModifier {
    let condition: Bool

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: AppDimensions.cornerRadius)
                    .stroke(condition ? Color.red : Color.clear, lineWidth: 1)
            )
    }
}

extension View {
    func mandatoryField(condition: Bool) -> some View {
        self.modifier(ConditionalBorderModifier(condition: condition))
    }
}
