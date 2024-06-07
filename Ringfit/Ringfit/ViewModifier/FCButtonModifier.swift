//
//  FCButtonModifier.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/27/24.
//

import SwiftUI

struct FCButtonModifier: ViewModifier {
    var width: CGFloat
    var height: CGFloat
    var fontColor: Color
    var buttonColor: Color
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .frame(width: width, height: height)
                .foregroundStyle(buttonColor)
            content
                .foregroundStyle(fontColor)
        }
    }
}
