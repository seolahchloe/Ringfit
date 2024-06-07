//
//  RegisterUserInfoView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/28/24.
//

import SwiftUI
import HealthKit

// 회원가입 유저정보 입력
struct FirstUserDetailInfoView: View {
//    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: SignUpViewModel
    @Binding var isButton2: Bool
    
    @State private var isWrongName: Bool = false
    @State private var isWrongNickname: Bool = false
    @State private var isWrongEmail: Bool = false
    @State private var isWrongPassword: Bool = false
    @State private var isSamePassword: Bool = false
    
    @State private var isTextFieldDisabled: Bool = false
    @State private var lostPasswordisTapped: Bool = false
    private var writeAllTextField: Bool {
        if isWrongName || isWrongPassword || isSamePassword || viewModel.checkPassword.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("아래 정보는 서비스 제공을 위해 필요한 정보이며,\n추후 마이페이지에서 수정할 수 있어요.")
                        .padding(.vertical, 30)
                    
                    
                    // MARK: - 이름
                    Text("이름")
                        .bold() +
                    Text("*")
                        .foregroundStyle(Color.red)
                    FCTextField(text: $viewModel.name,
                                isWrongText: isWrongName,
                                    isTextFieldDisabled: isTextFieldDisabled,
                                    placeholderText: "이름을 입력하세요")
                    .onChange(of: viewModel.name) {
                    }
                    
                    // MARK: - 닉네임
                    Text("닉네임")
                        .bold()
                    
                    FCTextField(text: $viewModel.nickname,
                                isWrongText: isWrongNickname,
                                    isTextFieldDisabled: isTextFieldDisabled,
                                    placeholderText: "닉네임을 입력하세요")
                    .onChange(of: viewModel.nickname) {
                    }
                    
                    Text("미기입시 이름으로 표기됩니다.")
                        .font(.footnote)
                        .padding(.vertical, -10)
                        .padding(.horizontal, 0)
                        .frame(alignment: .topLeading)
                    
                    // MARK: - ID(이메일)
                    Text("ID(이메일)")
                        .bold() +
                    Text("*")
                        .foregroundStyle(Color.red)
                    
                    FCTextField(text: $viewModel.email,
                                isWrongText: isWrongEmail,
                                    isTextFieldDisabled: isTextFieldDisabled,
                                    placeholderText: "ID로 사용하실 이메일을 입력하세요")
                    .onChange(of: viewModel.email) {
                        isWrongEmail = !(viewModel.isValidEmail(viewModel.email))
                        print("\(viewModel.email)")
                    }
                    
                    // MARK: - 비밀번호
                    HStack {
                        VStack(alignment: .leading) {
                            Text("비밀번호")
                                .bold() +
                            Text("*")
                                .foregroundStyle(Color.red)
                            
                            FCSecureTextFieldView(text: $viewModel.password,
                                                  isWrongText: $isWrongPassword,
                                                  isTextFieldDisabled: $isTextFieldDisabled,
                                                  placeholderText: "비밀번호를 입력하세요")
                            .onChange(of: viewModel.password) {
                                isWrongPassword = !(viewModel.isValidPassword(viewModel.password))
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("비밀번호 확인")
                                .bold() +
                            Text("*")
                                .foregroundStyle(Color.red)
                            
                            FCSecureTextFieldView(text: $viewModel.checkPassword,
                                                  isWrongText: $isSamePassword,
                                                  isTextFieldDisabled: $isTextFieldDisabled,
                                                  placeholderText: "비밀번호를 확인합니다")
                            .onChange(of: viewModel.checkPassword) {
                                isSamePassword = viewModel.isSamePassword(viewModel.password, viewModel.checkPassword)
                            }

                        }
                    }
                    
                    Spacer()

                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .onChange(of: writeAllTextField) {
                    isButton2 = writeAllTextField ? true : false
                }
//                .onAppear {
//                    if UserDefaults.standard.string(forKey: "SignType") != "email" {
//                        isTextFieldDisabled = false
//                        isButton2 = true
//                    }
//                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FirstUserDetailInfoView(isButton2: .constant(true))
            .environmentObject(SignUpViewModel())
    }
}

