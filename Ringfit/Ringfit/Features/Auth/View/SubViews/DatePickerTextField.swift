//
//  DatePickerTextField.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/5/24.
//

import SwiftUI

struct DatePickerTextField: View {
    @FocusState var isTextFieldFocused: Bool
    
    @Binding var presented: Bool
    @Binding var date: Date?
    @Binding var value: String

    let isTextFieldDisabled: Bool
    var placeholderText: String
    let onEditingChanged: (Bool) -> Void
    var onTap: () -> Void
    
    private var textFieldStrokeColor: Color {
        
        return isTextFieldFocused ? .Main : Color(hexCode: "f2f2f2")
    }
    
    var body: some View {
        GeometryReader { geometry in
        HStack {
                HStack {
                    TextField(placeholderText, text: $value)
                        .submitLabel(.done)
                        .focused($isTextFieldFocused)
                        .disabled(isTextFieldDisabled)
                        .padding(10)
                        .textInputAutocapitalization(.never)
                    
                    if isTextFieldFocused {
                        Button {
                            value = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.Main)
                        }
                        .padding(.trailing, 16)
                    }
                }
                .frame(width: geometry.size.width , height: 44)
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
                        Text("확인")
                    }
                }
            }
            .onTapGesture {
                onTap()
                print("Tapped!")
            }
        }
    }
}

#Preview {
    DatePickerTextField(presented: .constant(true),
                        date: .constant(nil),
                        value: .constant(""),
                        isTextFieldDisabled: false,
                        placeholderText: "생년월일을 입력하세요",
                        onEditingChanged: { _ in }) { } // onTap 클로저 제공
}
