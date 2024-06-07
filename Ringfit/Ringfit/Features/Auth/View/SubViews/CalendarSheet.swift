//
//  CalendarSheet.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/5/24.
//

import SwiftUI

struct CalendarSheet: View {
    @Binding var presented: Bool
    @Binding var value: String
    @Binding var date: Date?
    
    @State private var calendarDate = Date()
    
    var body: some View {
        ZStack {
            Color.white
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                DatePicker("", selection: $calendarDate, displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                
                Button {
                    presented.toggle()
                    date = calendarDate
                    
                    value = MyDateFormatter.dateFormatter.string(from: calendarDate)
                } label: {
                    Text("확인")
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
//            .cornerRadius(15)
//            .shadow(radius: 5)
//            .padding()
        }
    }
}

struct CalendarSheet_Previews: PreviewProvider {
    static var previews: some View {
        @State var presented = false
        @State var date: Date?
        @State var value = ""
        
        return DateField(placeholder: "생년월일을 입력하세요",
                         presented: $presented,
                         date: $date,
                         value: $value)
            .textFieldStyle(.roundedBorder)
            .padding()
//            .calendarSheet(presented: $presented, value: $value)
    }
}
