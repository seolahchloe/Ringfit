//
//  AgreementMainView.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/28/24.
//

import SwiftUI
import FirebaseAuth

// 약관 동의 메인 화면
struct EmailSignUpMainView: View {
    @Environment (\.dismiss) var dismiss
    @EnvironmentObject var viewModel: SignUpViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @State var isButton1: Bool = false
    @State var isButton2: Bool = false
    @State var isButton3: Bool = false
    
    @State private var showRingfitTabView: Bool = false

    @State private var signIndex: Int = 1
    @State private var isAlert: Bool = false
    @State private var progressBarValue: Double = 0
    @State private var progressBarTotal: Double = 100
    @State private var selectedGender: Gender = .female
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        VStack {
            if showRingfitTabView {
                RingfitTabView(cardioAchievementPercentage: 30)
            } else {
                VStack(spacing: 0) {
                    
                    // MARK: - ProgressBar
                    ProgressView(value: progressBarValue, total: progressBarTotal)
                        .progressViewStyle(AuthProgressBar(
                            value: $progressBarValue,
                            total: $progressBarTotal))
                }
                
                // MARK: - Progressbar에 순서에 따른 view 띄워주기
                ZStack {
                    button
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .ringFitAlert(isPresented: $isAlert,
                         title: "회원가입이 완료되었습니다! 🎉",
                         secondButtonTitle: nil,
                         secondButtonColor: nil,
                         secondButtonAction: nil,
                         buttonTitle: "확인",
                         buttonColor: .Main
        ) {
            let signtype = UserDefaults.standard.string(forKey: "SignType")
            if signtype == "email" {
                Task {
                    try await viewModel.createEmailUser()
                }
            }
            
            // MARK: - RingfitTabView로 전환
            updateUserData()
            showRingfitTabView = true
        }
//        .fullScreenCover(isPresented: $showRingfitTabView) {
//                    RingfitTabView(cardioAchievementPercentage: 30)
//                }
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
                HStack {
                    if signIndex != 1 {
                        Button {
                            signIndex -= 1
                            print("signIndex decreased")
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundStyle(Color.black)
                        }
                        
                    } else {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.black)
                        }
                    }
                }
                .padding(.horizontal, 0)
            }
            
        }
    }
    private func updateUserData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let updatedUser = User(id: currentUser.uid,
                               name: viewModel.name,
                               nickName: viewModel.nickname,
                               email: viewModel.email,
                               dob: viewModel.dob,
                               gender: viewModel.gender.rawValue,
                               workoutPurpose: viewModel.workoutPurpose.rawValue)
        
        userViewModel.updateUser(user: updatedUser)
    }
}

extension EmailSignUpMainView {
    var button: some View {
        NavigationStack {
            VStack {
                if signIndex == 1 {
                    AuthWelcomeView(isButton1: $isButton1)
                        .onAppear(perform: {
                            progressBarValue = (100 / 3) * 1
                        })
                } else if signIndex == 2 {
                    FirstUserDetailInfoView(isButton2: $isButton2)
                        .onAppear(perform: {
                            progressBarValue = (100 / 3) * 2
                        })
                } else if signIndex == 3 {
                    SecondUserDetailInfoView(isButton3: $isButton3, selectedGender: selectedGender)
                        .onAppear(perform: {
                            progressBarValue = (100 / 3) * 3
                        })
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        if signIndex < 3 {
                            signIndex += 1
                        } else {
                            isAlert.toggle()
                        }
                    } label: {
                        Text(signIndex == 3 ? "회원가입 완료" : "계속")
                            .modifier(FCButtonModifier(width: 350,
                                                       height: 50,
                                                       fontColor: .white,
                                                       buttonColor: signIndex == 1 && !isButton1 ||
                                                       signIndex == 2 && !isButton2 ||
                                                       signIndex == 3 && !isButton3 ? .LightGray2 : .Main,
                                                       cornerRadius: 10))
                    }
                    .disabled(signIndex == 1 && !isButton1 || signIndex == 2 && !isButton2 || signIndex == 3 && !isButton3)
                    
                }
            }
        }
    }
}


#Preview {
    NavigationStack {
        EmailSignUpMainView()
            .environmentObject(SignUpViewModel())
    }
}
