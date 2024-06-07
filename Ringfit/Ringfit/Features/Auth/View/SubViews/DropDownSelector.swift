//
//  DropDownSelector.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/28/24.
//

import SwiftUI

struct DropDownOption: Hashable {
    let key: String
    let value: String
    
    public static func == (lhs: DropDownOption, rhs: DropDownOption) -> Bool {
        return lhs.key == rhs.key
    }
}

struct DropDownSelector: View {
    @State private var shouldShowDropDown: Bool = false
    @State private var selectedOption: DropDownOption? = nil
    
    var placeholder: String
    var isDropDownDisabled: Bool = false
    var options: [DropDownOption]
    var onOptionSelected: ((_ option: DropDownOption) -> Void)?
    private let buttonHeight: CGFloat = 44
    
    private var dropDownStrokeColor: Color {
        
        return isDropDownDisabled ? .Main : Color(hexCode: "f2f2f2")
    }
    
    var body: some View {
        Button {
            self.shouldShowDropDown.toggle()
        } label: {
            HStack {
                Text(selectedOption == nil ? placeholder : selectedOption!.value)
                    .font(.system(size: 14))
                    .foregroundColor(selectedOption == nil ? Color.gray: Color.black)
                
                Spacer()
                
                Image(systemName: self.shouldShowDropDown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                    .resizable()
                    .frame(width: 9, height: 5)
                    .font(Font.system(size: 9, weight: .medium))
                    .foregroundColor(Color.black)
            }
        }
        .padding(.horizontal)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .frame(width: UIScreen.main.bounds.width / 2, height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(dropDownStrokeColor)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isDropDownDisabled ? Color.LightGray2: Color.BackgroundGray)
                )
        )
        .overlay(
            VStack {
                if self.shouldShowDropDown {
                    Spacer(minLength: buttonHeight + 10)
                    DropDown(options: self.options, onOptionSelected: { option in
                        shouldShowDropDown = false
                        selectedOption = option
                        self.onOptionSelected?(option)
                    })
                }
            }, alignment: .center
        )
    }
}

struct DropDown: View {
    var options: [DropDownOption]
    var onOptionSelected: ((_ option: DropDownOption) -> Void)?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                ForEach(self.options, id: \.self) { option in
                    DropDownRow(option: option,
                                onOptionSelected: self.onOptionSelected)
                }
            }
        }
        .frame(height: 60)
        .padding(.vertical, 5)
        .background(Color.white)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct DropDownRow: View {
    var option: DropDownOption
    var onOptionSelected: ((_ option: DropDownOption) -> Void)?
    
    var body: some View {
        Button(action: {
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
            HStack {
                Text(self.option.value)
                    .font(.system(size: 14))
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}

struct DropdownSelector_Previews: PreviewProvider {
    static var uniqueKey: String {
        UUID().uuidString
    }
    
    static let options: [DropDownOption] = [
        DropDownOption(key: uniqueKey, value: "여자"),
        DropDownOption(key: uniqueKey, value: "남자"),
    ]
    
    
    static var previews: some View {
        Group {
            DropDownSelector(
                placeholder: "성별을 선택하세요",
                options: options,
                onOptionSelected: { option in
                    print(option)
                })
            .padding(.horizontal)
        }
    }
}

//#Preview {
//
//    DropDownSelector()
//}
