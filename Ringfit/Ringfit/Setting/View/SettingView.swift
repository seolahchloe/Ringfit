//
//  SettingView.swift
//  Ringfit
//
//  Created by Chloe Chung on 4/16/24.
//

import SwiftUI

struct SettingView: View {
    @Environment (\.dismiss) var dismiss
    @State private var isAlert: Bool = false

    
    var body: some View {
        NavigationStack {
            Divider()

            VStack(spacing: 20) {
                NavigationLink {
                    MyHRDataView()
                } label: {
                    Text("나의 심박 데이터")
                        .foregroundStyle(Color.black)
                        .font(.title3)
                }
                
                Divider()
                
                NavigationLink {
                    ChagePasswordView()
                } label: {
                    Text("비밀번호 변경")
                        .foregroundStyle(Color.black)
                        .font(.title3)
                }
                
                Divider()
                
                NavigationLink {
                    TermsAndConditionsDetailView()
                } label: {
                    Text("서비스 이용약관")
                        .foregroundStyle(Color.black)
                        .font(.title3)
                }
                
                Divider()
                
                NavigationLink {
                    PrivacyPolicyDetailView()
                } label: {
                    Text("개인정보 처리방침")
                        .foregroundStyle(Color.black)
                        .font(.title3)
                }
                
                Divider()
                
                Button {
                    AuthViewModel.shared.signOut()
                } label: {
                    Text("로그아웃")
                        .foregroundStyle(Color.black)
                        .font(.title3)
                }
                .ringFitAlert(isPresented: $isAlert,
                                 title: "로그아웃 되었습니다",
                                 secondButtonTitle: nil,
                                 secondButtonColor: nil,
                                 secondButtonAction: nil,
                                 buttonTitle: "확인",
                                 buttonColor: .Main) {
                    AuthViewModel.shared.signOut()
                    print("로그아웃 완료")
                }
                
                Spacer()
            }
            .padding()
            .frame(width: .infinity, alignment: .topLeading)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("설정")
        .navigationBarBackButtonHidden(true)
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

#Preview {
    NavigationStack {
        SettingView()
    }
}
