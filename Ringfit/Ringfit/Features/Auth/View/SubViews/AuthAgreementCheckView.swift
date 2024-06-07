//
//  AuthAgreementCheckView.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/18/24.
//

import SwiftUI

struct AuthAgreementCheckView: View {
    @Binding var isButton1: Bool // button1
    @State var termsAndConditionsTapped: Bool = false //isCheck1
    @State var privacyPolicyTapped: Bool = false //isCheck2
    
    private var allChecked: Bool {
        if termsAndConditionsTapped && privacyPolicyTapped {
            return true
        } else {
            return false
        }
    }
    
    func isAllChecked() {
        if termsAndConditionsTapped && privacyPolicyTapped {
            termsAndConditionsTapped.toggle()
            privacyPolicyTapped.toggle()
        } else {
            if !termsAndConditionsTapped {
                termsAndConditionsTapped.toggle()
            }
            if !privacyPolicyTapped {
                privacyPolicyTapped.toggle()
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // MARK: - 전체 동의
                HStack {
                    Button {
                        isAllChecked()
                    } label: {
                        if termsAndConditionsTapped && privacyPolicyTapped {
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color.Main)
                                    .frame(width: 25, height: 25)
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.white)
                            }
                        } else {
                            Circle()
                                .foregroundStyle(Color.gray)
                                .frame(width: 25, height: 25)
                        }
                    }
                    Text("회원가입 약관에 모두 동의합니다.")
                        .bold()
                        .font(.title3)
                }
                
                Divider()
                    .padding()
                
                
                // MARK: - 이용 약관
                HStack {
                    // 원형 버튼
                    Button {
                        termsAndConditionsTapped.toggle()
                    } label: {
                        if termsAndConditionsTapped {
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color.Main)
                                    .frame(width: 25, height: 25)
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.white)
                            }
                        } else {
                            Circle()
                                .foregroundStyle(Color.gray)
                                .frame(width: 25, height: 25)
                        }
                    }
                    
                    // 이용약관 DetailView로 넘어가기
                    NavigationLink {
                        TermsAndConditionsDetailView()
                    } label: {
                        Text("이용 약관")
                            .font(.title3)
                            .foregroundStyle(Color.black)
                        Text("(필수)")
                            .font(.title3)
                            .foregroundStyle(Color.red)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(Color.Main)
                    }
                }
                
                // MARK: - 개인정보 처리방침
                HStack {
                    Button {
                        privacyPolicyTapped.toggle()
                    } label: {
                        if privacyPolicyTapped {
                            ZStack {
                                Circle()
                                    .foregroundStyle(Color.Main)
                                    .frame(width: 25, height: 25)
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.white)
                            }
                        } else {
                            Circle()
                                .foregroundStyle(Color.gray)
                                .frame(width: 25, height: 25)
                        }
                    }
                    
                    NavigationLink {
                        PrivacyPolicyDetailView()
                    } label: {
                        Text("개인정보 처리방침")
                            .font(.title3)
                            .foregroundStyle(Color.black)
                        Text("(필수)")
                            .font(.title3)
                            .foregroundStyle(Color.red)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward")
                            .foregroundStyle(Color.Main)
                    }
                }
                Spacer()
            }
            .onChange(of: allChecked) {
                isButton1 = allChecked ? true : false
            }
            .padding()
        }
    }
}

#Preview {
    AuthAgreementCheckView(isButton1: .constant(true))
        .environmentObject(SignUpViewModel())
}
