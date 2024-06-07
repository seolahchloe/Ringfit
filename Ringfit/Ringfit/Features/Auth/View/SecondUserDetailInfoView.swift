//
//  SecondUserDetailInfoView.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/4/24.
//

import SwiftUI

struct SecondUserDetailInfoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: SignUpViewModel
    @Binding var isButton3: Bool
    
    @State var selectedGender: Gender
    @State private var isWrongdob: Bool = false
    @State private var presented = false
    @State private var strDOBDate = ""
    
    @State private var isNameTextfieldDisabled: Bool = false
    @State private var isTextfieldDisabled: Bool = false
    @State private var isCalendarSheetPresented = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd"
        return formatter
    }
    private var writeAllTextField: Bool {
        if strDOBDate.isEmpty || viewModel.workoutPurpose.rawValue.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    
    
    var body: some View {
        NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        Text("정보 입력하기")
                            .font(.title)
                            .bold()
                        
                        Text("거의 다 왔어요.\n\n아래 정보는 서비스 제공을 위해 필요한 정보이며,\n추후 마이페이지에서 수정할 수 있어요.")
                        
                        // MARK: - 생년월일
                        
                        Text("생년월일")
                            .bold() +
                        Text("*")
                            .foregroundStyle(Color.red)

                        DatePickerTextField(presented: $presented,
                                            date: .constant(Date()),
                                            value: $strDOBDate,
                                            isTextFieldDisabled: isTextfieldDisabled,
                                            placeholderText: "생년월일을 입력해주세요") { _ in
                        } onTap: {
                            presented = true
                        }
                        .onChange(of: strDOBDate) { newValue in
                            if let date = dateFormatter.date(from: newValue) {
                                viewModel.dob = date
                            }
                        }
                        .onChange(of: viewModel.dob) {
                            isWrongdob = !(viewModel.isValiddob(viewModel.dob.description))
                        }
                        Spacer()
                        
                        // MARK: - 성별
                        Text("성별")
                            .bold() +
                        Text("*")
                            .foregroundStyle(Color.red)
                        
                        
                        // MARK: - 성별 선택
                        Picker("성별선택", selection: $selectedGender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue).tag(gender.rawValue)
                            }
                        }
                        .onChange(of: selectedGender) { newValue in
                            viewModel.gender = newValue
                        }
                        .pickerStyle(.menu)
                        .accentColor(.black)
                        
                        // MARK: - 운동 목적
                        Text("운동목적")
                            .bold() +
                        Text("*")
                            .foregroundStyle(Color.red)
                        
                        HStack {
                            Button {
                                UserViewModel.shared.workoutPurpose = .improve
                            } label: {
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(viewModel.workoutPurpose == .improve ? .Main : Color.LightGray2)
                            }

                            
                            Text("체력 향상")
                            
                            Spacer()
                            
                            Button {
                                UserViewModel.shared.workoutPurpose = .maintain
                            } label: {
                                Circle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(viewModel.workoutPurpose == .maintain ? .Main : Color.LightGray2)
                            }
                            
                            Text("체중 감량")
                            
                            Spacer()
                        }
                        
                        
                        
                        Text("**Tips!**")
                            .bold()
                            .foregroundStyle(Color.red) +
                        Text("\n평소 운동을 꾸준히 하지 않았다면 \n**'건강 유지'** 를 선택해주세요.\n**'체력 향상'** 을 선택하면 목표 활동량이 높아져요!")
                        
                        Spacer()
                    }
                    .padding()
                    .onChange(of: presented) { newValue in
                        isCalendarSheetPresented = newValue
                    }
                    .onChange(of: writeAllTextField) {
                        isButton3 = writeAllTextField ? true : false
                    }
                    .sheet(isPresented: $isCalendarSheetPresented) {
                        CalendarSheet(presented: $presented,
                                      value: $strDOBDate,
                                      date: .constant(Date())
                        )
                        .presentationDetents([.height(250)])
                    }
                    .onAppear {
                        if UserDefaults.standard.string(forKey: "SignType") != "email" {
                            isNameTextfieldDisabled = true
                        }
                    }
                }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    SecondUserDetailInfoView(isButton3: .constant(true), selectedGender: .female)
        .environmentObject(SignUpViewModel())
}
