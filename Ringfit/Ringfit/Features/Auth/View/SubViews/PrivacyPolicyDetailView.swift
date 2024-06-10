//
//  SignUpUserInfoView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/28/24.
//

import SwiftUI

// 개인정보(Personal Information) 처리방침 상세 화면
struct PrivacyPolicyDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("개인정보 처리방침")
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
    
}
#Preview {
    NavigationStack {
        PrivacyPolicyDetailView()
    }
}
