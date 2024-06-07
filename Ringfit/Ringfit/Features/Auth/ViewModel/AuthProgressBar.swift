//
//  AuthProgressBar.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/19/24.
//

import SwiftUI

struct AuthProgressBar: ProgressViewStyle {
    @Binding var value: Double
    @Binding var total: Double
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .accentColor(.Main)
            .animation(.easeOut(duration: 1), value: value)
    }
}

