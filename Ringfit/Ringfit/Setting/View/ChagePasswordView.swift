//
//  ChagePasswordView.swift
//  Ringfit
//
//  Created by Chloe Chung on 4/30/24.
//

import SwiftUI

struct ChagePasswordView: View {
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""
    @State private var isWrongText: Bool = false
    @State private var isTextFieldDisabled: Bool = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("기존 비밀번호")
                    .bold()
                
                FCTextField(text: $currentPassword,
                            isWrongText: isWrongText,
                            isTextFieldDisabled: isTextFieldDisabled,
                            placeholderText: "사용중인 비밀번호를 입력해주세요")
                
                
                Text("새로운 비밀번호")
                    .bold()
                
                FCTextField(text: $newPassword,
                            isWrongText: isWrongText,
                            isTextFieldDisabled: isTextFieldDisabled,
                            placeholderText: "새로운 비밀번호를 입력해주세요")
                
                Text("새로운 비밀번호 확인")
                    .bold()
                
                FCTextField(text: $confirmNewPassword,
                            isWrongText: isWrongText,
                            isTextFieldDisabled: isTextFieldDisabled,
                            placeholderText: "새로운 비밀번호를 다시 입력해주세요")
            }
            .padding(.vertical, 30)
            
            HStack {
                Button {
                    AuthViewModel.shared.changePassword(currentPassword: currentPassword,
                                                        newPassword: newPassword,
                                                        confirmPassword: confirmNewPassword) { result in
                        switch result {
                        case .success:
                            // 비밀번호 변경 성공 처리
                            print("비밀번호가 성공적으로 변경되었습니다.")
                        case .failure(let error):
                            // 비밀번호 변경 실패 처리
                            print("비밀번호 변경 실패: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("비밀번호 변경하기")
                        .modifier(FCButtonModifier(width: .infinity,
                                                   height: 50,
                                                   fontColor: .white,
                                                   buttonColor: (currentPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) ? .LightGray2 : .Main,
                                                   cornerRadius: 10))
                }
            }
            
            Spacer()
            
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        ChagePasswordView()
    }
}
