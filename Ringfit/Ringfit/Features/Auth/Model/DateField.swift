//
//  DateField.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/4/24.
//

import SwiftUI

struct DateField: View {
    let placeholder: String
    @Binding var presented: Bool
    @Binding var date: Date?
    @Binding var value: String
    
    @State private var isWrongText: Bool = false
    @State private var isTextFieldDisabled: Bool = false

    
    var body: some View {
        DatePickerTextField(presented: $presented,
                            date: $date,
                            value: $value,
                        isTextFieldDisabled: isTextFieldDisabled,
                        placeholderText: placeholder) { value in
                    presented = value
        } onTap: {
            presented = true
        }
        .onChange(of: value) {
            date = MyDateFormatter.dateFormatter.date(from: value)
        }
    }
}

//#Preview {
//    @State var date: Date? = nil
//    @State var presented = false
//    DateField(placeholder: "생일을 입력하세요",
//              presented: $presented,
//              date: $date,
//              value: .constant(""))
////        .padding()
//}

struct DateField_Previews: PreviewProvider {
    static var previews: some View {
        @State var date: Date? = nil
        @State var presented = false
        return DateField(placeholder: "생년월일을 입력하세요",
                         presented: $presented,
                         date: $date,
                         value: .constant(""))
            .padding()
    }
}
