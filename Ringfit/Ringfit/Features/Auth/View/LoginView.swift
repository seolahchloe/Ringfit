//
//  LoginView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/26/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isWrongText: Bool = false
    @State private var isTextfieldDisabled: Bool = false
    @State private var findPasswordisTapped: Bool = false
    
    @State var isButton1: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("logo_word_black")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 217)
            
            Spacer()

            
            // MARK: - 로그인하기
            VStack(alignment: .leading) {
                Text("이메일(아이디)")
                    .bold()
                
                FCTextField(text: $email,
                                isWrongText: isWrongText,
                                isTextFieldDisabled: isTextfieldDisabled,
                                placeholderText: "이메일")
                
                
                Text("비밀번호")
                    .bold()
                
                FCSecureTextFieldView(text: $password,
                                      isWrongText: $isWrongText,
                                      isTextFieldDisabled: $isTextfieldDisabled,
                                      placeholderText: "비밀번호")
                
            }
            .padding()
            
            
            // MARK: - 비밀번호 찾기
            HStack {
                Spacer()
                
                Button {
                    findPasswordisTapped.toggle()
                } label: {
                    Text("비밀번호를 잊으셨나요?")
                        .bold()
                        .foregroundStyle(Color.Main)
                }
                .sheet(isPresented: $findPasswordisTapped, content: {
                    FindPasswordView()
                })
                .padding(.vertical, -25)
            }
            .padding()
            
            
            Spacer()
            
            
            // MARK: - 로그인 버튼
                Button {
                    Task {
                        do {
                            try await AuthViewModel.shared.emailAuthSignIn(withEmail: email, password: password)
                            isWrongText = true
                            
                        } catch {
                            print("로그인 실패: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("로그인")
                        .modifier(FCButtonModifier(width: 350,
                                                   height: 50,
                                                   fontColor: .white,
                                                   buttonColor: .Main,
                                                   cornerRadius: 10))
                }
                
                
                Spacer()
                
                // MARK: - 회원가입
                HStack {
                    Text("계정이 없으신가요?")
                        .foregroundStyle(Color.DarkGray1)
                        .font(.footnote)
                    
                    NavigationLink {
                        EmailSignUpMainView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("회원가입")
                            .foregroundStyle(Color.Main)
                            .underline()
                            .bold()
                            .font(.footnote)
                    } 
                    .simultaneousGesture(TapGesture().onEnded {
                        UserDefaults.standard.set("email", forKey: "SignType")
                    })
                }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
            .environmentObject(SignUpViewModel())
    }
}
