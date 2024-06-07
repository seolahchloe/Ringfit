//
//  MyProfile.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/12/24.
//

import SwiftUI

struct MyProfileView: View {
    @EnvironmentObject var viewModel: SignUpViewModel
    @ObservedObject private var authViewModel = AuthViewModel.shared
    @ObservedObject private var userViewModel = UserViewModel.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            if let nickName = userViewModel.currentUser?.nickName {
                Text("\(nickName) 님")
                    .font(.largeTitle)
            } else {
                Text(userViewModel.currentUser?.name ?? "이름없음 님")
                    .font(.largeTitle)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("이름")
                    .bold()
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.LightGray1)
                    .overlay(
                        Text("\(userViewModel.currentUser?.name ?? "이름 없음")")                    )
                    .frame(width: .infinity, height: 50, alignment: .leading)
                
                // MARK: - 닉네임
                Text("닉네임")
                    .bold()
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.LightGray1)
                    .overlay(
                        Text(userViewModel.currentUser?.nickName ?? userViewModel.currentUser?.name ?? "닉네임 없음")
                    )
                    .frame(width: .infinity, height: 50)
                
                
                // MARK: - ID(이메일)
                Text("ID(이메일)")
                    .bold()
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.LightGray1)
                    .overlay(
                        Text("\(userViewModel.currentUser?.email ?? "이메일 없음")")
                    )
                    .frame(width: .infinity, height: 50)
                
                // MARK: - 생년월일
                Text("생년월일")
                    .bold()
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.LightGray1)
                    .overlay(
                        Text(MyDateFormatter.dateFormatter.string(from: userViewModel.currentUser?.dob ?? Date()))
                    )
                    .frame(width: .infinity, height: 50)
                
                
                
                // MARK: - 성별
                Text("성별")
                    .bold()
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.LightGray1)
                    .overlay(
                        Text("\(userViewModel.currentUser?.gender ?? "성별 확인 불가")")
                    )
                    .frame(width: .infinity, height: 50)
                
                
                // MARK: - 운동목적
                Text("운동 목적")
                    .bold()
                
                HStack {
                    Button {
                        userViewModel.workoutPurpose = .improve
                    } label: {
                        Circle()
                            .frame(width: 25, height: 25)
                            .foregroundColor(userViewModel.workoutPurpose == .improve ? .Main : Color.LightGray2)
                    }

                    Text("체력 향상")
                    Spacer()

                    Button {
                        userViewModel.workoutPurpose = .maintain
                    } label: {
                        Circle()
                            .frame(width: 25, height: 25)
                            .foregroundColor(userViewModel.workoutPurpose == .maintain ? .Main : Color.LightGray2)    }

                    Text("건강 유지")

                    Spacer()
                }
                
                Spacer()
                
                Button {
                    if let currentUser = userViewModel.currentUser {
                        userViewModel.updateUser(user: currentUser)
                    }
                } label: {
                    Text("저장하기")
                        .modifier(FCButtonModifier(width: .infinity,
                                               height: 50,
                                               fontColor: .white,
                                               buttonColor: .Main,
                                               cornerRadius: 10))
                }

            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        MyProfileView()
            .environmentObject(SignUpViewModel())
            .environmentObject(UserViewModel())
    }
}
