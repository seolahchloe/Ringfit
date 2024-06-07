//
//  Color+Extensions.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/27/24.
//

import Foundation
import SwiftUI

// MARK: - Convenience Initializers
extension Color {
    public init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0
        )
    }
    
    public init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
    init(hexCode: String) {
        var formattedHex = hexCode.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        Scanner(string: formattedHex).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


// MARK: - Helpers

public extension Color {
    static let workoutColors: [Color] = [.HKGray, .HKSkyblue, .HKGreen, .HKYellow, .HKNavy]
    
    static func randomWorkoutColor() -> Color {
        workoutColors.randomElement() ?? .HKNavy
    }
    
    var uiColor: UIColor {
        UIColor(self)
    }
    
    static var Main: Color {
        return .init(hexCode: "#8DC9FF")
    }
    
    static var BackgroundGray: Color {
        return .init(hexCode: "#F2F2F2")
    }
    
    static var LightGray1: Color {
        return .init(hexCode: "#ECECEC")
    }
    
    static var LightGray2: Color {
        return .init(hexCode: "#D4D4D4")
    }
    
    static var DarkGray1: Color {
        return .init(hexCode: "#666666")
    }
    
    static var DarkGray2: Color {
        return .init(hexCode: "#404040")
    }
    
    static var Black: Color {
        return .init(hexCode: "#1C1C1C")
    }
    
    static var Error: Color {
        return .init(hexCode: "#F05650")
    }
    
    
    // MARK: - 운동별 색상
    static var HKNavy: Color {
        return .init(hexCode: "#13243E")
    }
    
    static var HKSkyblue: Color {
        return .init(hexCode: "#A9D2EF")
    }
    
    static var HKGreen: Color {
        return .init(hexCode: "#AEC46F")
    }
    
    static var HKYellow: Color {
        return .init(hexCode: "#F5B84F")
    }
    
    static var HKGray: Color {
        return .init(hexCode: "#D9D9D9")
    }
}

