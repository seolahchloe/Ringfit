//
//  FCAlerModifier.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/26/24.
//

import SwiftUI

struct FCAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let buttonTitle: String
    let buttonColor: Color
    let action: () -> Void
    
    let secondButtonTitle: String?
    let secondButtonColor: Color?
    let secondButtonAction: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text(title)
                        .foregroundStyle(.black)
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        if let secondButtonTitle, let secondButtonColor, let secondButtonAction {
                            Button {
                                secondButtonAction()
                                isPresented.toggle()
                            } label: {
                                Text(secondButtonTitle)
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 44)
                            }
                            .background(secondButtonColor)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )
                        }
                        
                        Button {
                            action()
                            isPresented.toggle()
                            
                        } label: {
                            Text(buttonTitle)
                                .foregroundColor(.white)
                                .frame(
                                    width: secondButtonTitle == nil ? 180 : 100,
                                    height: 44
                                )
                        }
                        .background(buttonColor)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                    }
                    
                }
                .padding(.horizontal, 40)
                .padding(.vertical, 30)
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                        )
                )
            }
        }
    }
}

#Preview {
    Text("Alert")
        .modifier(
            FCAlertModifier(
                isPresented: .constant(true),
                title: "회원가입이 완료되었습니다! 🎉 \n완료되었습니다!",
                buttonTitle: "확인",
                buttonColor: .Main,
                action: { },
                secondButtonTitle: "취소",
                secondButtonColor: .red,
                secondButtonAction: { }
            )
        )
}
