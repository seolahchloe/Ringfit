//
//  UseAgreementView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/28/24.
//

import SwiftUI

// 이용약관 상세 화면
struct TermsAndConditionsDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("이용약관")
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            
            // MARK: - 상단 로고
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("logo_word_black")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 170, height: 2, alignment: .leading)
                }
            }
            
            // MARK: - 뒤로가기 버튼
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.black)
                    }
                }
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        TermsAndConditionsDetailView()
    }
}
