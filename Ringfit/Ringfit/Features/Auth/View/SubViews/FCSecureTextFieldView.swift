//
//  FCSecureTextField.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/27/24.
//

import SwiftUI

struct FCSecureTextFieldView: View {
    @Binding var text: String
    /// 잘못된 입력값 여부
    @Binding var isWrongText: Bool
    /// TextField 비활성화 여부
    @Binding var isTextFieldDisabled: Bool
    @FocusState var isTextFieldFocused: Bool
    
    let placeholderText: String

    private var textFieldStrokeColor: Color {
        if isWrongText {
            return Color(hexCode: "F05650")
        }
        return isTextFieldFocused ? .Main : Color(hexCode: "f2f2f2")
    }
    
    var body: some View {
        HStack {
            SecureField(placeholderText, text: $text)
                .submitLabel(.done)
                .focused($isTextFieldFocused)
                .disabled(isTextFieldDisabled)
                .padding(.leading, 10)
                .textInputAutocapitalization(.never)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.Main)
                }
                .padding(.trailing, 16)
            }
        }
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(textFieldStrokeColor)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isTextFieldDisabled ? Color(hexCode: "D4D4D4"): Color(hexCode: "f2f2f2"))
                    
                )
        )
    }
}

#Preview {
    FCSecureTextFieldView(text: .constant(""),
                          isWrongText: .constant(true),
                          isTextFieldDisabled: .constant(false),
                          isTextFieldFocused: FocusState(),
                          placeholderText: "내용을 입력하세요")
}
