//
//  TextFieldView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/27/24.
//

import SwiftUI

struct FCTextField: View {
    @Binding var text: String
    /// 잘못된 입력값 여부
    let isWrongText: Bool
    /// TextField 비활성화 여부
    let isTextFieldDisabled: Bool
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
            HStack {
                TextField(placeholderText, text: $text)
                    .submitLabel(.done)
                    .focused($isTextFieldFocused)
                    .disabled(isTextFieldDisabled)
                    .padding(10)
                    .textInputAutocapitalization(.never)
                
                if !text.isEmpty && isTextFieldFocused {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(isWrongText ? .Error : .Main)
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
                            .fill(isTextFieldDisabled ? Color.LightGray2: Color.BackgroundGray)
                    )
            )
            
            if isTextFieldFocused {
                Button {
                    isTextFieldFocused = false
                } label: {
                    Text("취소")
                }
            }
        }
    }
}

#Preview {
    FCTextField(text: .constant(""),
                    isWrongText: false,
                    isTextFieldDisabled: false,
                    isTextFieldFocused: FocusState(),
                    placeholderText: "내용을 입력하세요")
    .environmentObject(SignUpViewModel())
}
