//
//  MyHRDataView.swift
//  Ringfit
//
//  Created by Chloe Chung on 4/30/24.
//

import SwiftUI

struct MyHRDataView: View {
    @Environment (\.dismiss) var dismiss
    @State private var restingHeartRateText: String = ""
    
    var body: some View {
        NavigationStack {
            Divider()
            
            VStack(alignment: .leading) {
                // MARK: - 평균 심박수
                Text("평균심박수")
                    .bold()
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.LightGray1)
                    .overlay(
                        // TODO: - Resting Heart Rate 가져오기
                        Text(getAverageHeartRateText() + "bpm")
                    )
                    .frame(width: .infinity, height: 50)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("나의 심박 데이터")
        }
    }
    
    private func getAverageHeartRateText() -> String {
        HealthViewModel.shared.fetchRestingHeartRate { restingHeartRate in
            if let restingHeartRate = restingHeartRate {
                DispatchQueue.main.async {
                    self.restingHeartRateText = "\(Int(restingHeartRate))"
                }
            } else {
                DispatchQueue.main.async {
                    self.restingHeartRateText = "심박수 데이터 없음"
                }
            }
        }
        return restingHeartRateText
    }
}

#Preview {
    MyHRDataView()
}
