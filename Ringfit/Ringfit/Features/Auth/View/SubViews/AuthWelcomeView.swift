//
//  AuthWelcomeView.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/18/24.
//

import SwiftUI

struct AuthWelcomeView: View {
    @Binding var isButton1: Bool
    
    var body: some View {
        // MARK: - 환영 문구
        VStack(alignment: .leading) {
            Text("환영합니다!")
                .bold()
                .font(.title)

                .padding()
            
            Text("회원가입을 위해 아래의 이용 약관,\n개인정보 처리방침에 동의해 주세요.")
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .padding(.bottom, 10)
        
        AuthAgreementCheckView(isButton1: $isButton1)
    }
}


#Preview {
    AuthWelcomeView(isButton1: .constant(true))
        .environmentObject(SignUpViewModel())
}
