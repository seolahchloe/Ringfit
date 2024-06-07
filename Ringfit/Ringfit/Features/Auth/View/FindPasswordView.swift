//
//  FindPasswordView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/27/24.
//

import SwiftUI

struct FindPasswordView: View {
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var isWrongText: Bool = false
    @State private var isTextFieldDisabled: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Group {
                    Text("비밀번호를 잊으셨다면,\n고객님의 이메일로 임시 비밀번호를 보내드려요.\n")
                        .padding(.vertical, 5)
                    Text("가입하신  성함과 이메일을 입력하고\n메일보내기 버튼을 눌러 주세요.")
                }
                .bold()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("가입한 이름")
                        .bold()
                    
                    FCTextField(text: $name,
                                isWrongText: isWrongText,
                                isTextFieldDisabled: isTextFieldDisabled,
                                placeholderText: "가입시 입력한 이름을 입력해주세요")
                    
                    
                    Text("가입한 이메일")
                        .bold()
                    
                    FCTextField(text: $email,
                                isWrongText: isWrongText,
                                isTextFieldDisabled: isTextFieldDisabled,
                                placeholderText: "가입시 입력한 이름을 입력해주세요")
                }
                .padding(.vertical, 30)
                
                HStack {
                    Button {
                        
                    } label: {
                        Text("메일 보내기")
                            .modifier(FCButtonModifier(width: .infinity,
                                                       height: 50,
                                                       fontColor: .white,
                                                       buttonColor: (name.isEmpty || email.isEmpty) ? .LightGray2 : .Main,
                                                       cornerRadius: 10))
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("비밀번호 찾기")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                            .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    FindPasswordView()
}
