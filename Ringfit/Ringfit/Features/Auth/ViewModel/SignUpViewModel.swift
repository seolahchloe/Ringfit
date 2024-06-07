//
//  SignUpViewModel.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/27/24.
//

import Foundation

class SignUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var checkPassword: String = ""
    @Published var name: String = ""
    @Published var nickname: String = ""
    @Published var dob: Date
    @Published var gender: Gender = .female
    @Published var workoutPurpose: WorkoutPurpose = .maintain
    @Published var stabledPulse: Int = 0
    
    init() {
        self.dob = Date()
    }
    
    @MainActor
    func createEmailUser() async throws {
        do {
            try await AuthViewModel.shared.emailAuthSignUp(withEmail: email, password: password, name: name, nickname: nickname, gender: gender.rawValue, stabledPulse: stabledPulse, dob: dob, workoutPurpose: WorkoutPurpose(rawValue: workoutPurpose.rawValue) ?? .maintain)
            self.email = ""
            self.password = ""
            self.checkPassword = ""
            self.name = ""
            self.nickname = ""
            self.dob = Date()
            self.workoutPurpose = .maintain
            self.stabledPulse = 0
        } catch {
            print("Error signing up: \(error.localizedDescription)")
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^[A-Za-z0-9~!@#$%^&*]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        return passwordPredicate.evaluate(with: password)
    }
    
    func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z]{2,}$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)

        return namePredicate.evaluate(with: name)
    }
    
    func isValiddob(_ dob: String) -> Bool {
        let dobRegex = "^([0-9]{4})(0|1)([0-9])([0-3])([0-9])$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", dobRegex)
        
        return passwordPredicate.evaluate(with: dob)
    }
    
    func isSamePassword(_ password: String, _ checkPassword: String) -> Bool {
        if password == checkPassword {
            return false
        } else {
            return true
        }
    }
}

