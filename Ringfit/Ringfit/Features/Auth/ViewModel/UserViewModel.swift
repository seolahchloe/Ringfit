//
//  UserViewModel.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/27/24.
//

import Foundation
import Firebase
import FirebaseAuth

class UserViewModel: ObservableObject {
    static let shared = UserViewModel()
    private static let db = Firestore.firestore()
    
    @Published var currentUser: User?
    @Published var date: Date?
    @Published var nickname: String = ""
    @Published var workoutPurpose: WorkoutPurpose = .maintain
    @Published var gender: Gender = .female
    
    public init() {
        Task {
            try await loadUserData()
        }
    }
    
    @MainActor
    func fetchCurrentUser(_ user: User) {
        self.currentUser = user
        self.workoutPurpose = WorkoutPurpose(rawValue: user.workoutPurpose) ?? .maintain
    }
    
    /// Firebase에 있는 유저정보 불러오기
    func loadUserData() async throws{
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = Firestore.firestore().collection("users").document(userId)
        let snapshot = try await userRef.getDocument()
        let currentUser = try snapshot.data(as: User.self)
        await fetchCurrentUser(currentUser)
    }
    
    // 유저의 uid를 받아서 document로 반환
    func uidLoadUserData(_ uid: String) async throws -> User {
        let userRef = Firestore.firestore().collection("users").document(uid)
        let snapshot = try await userRef.getDocument()
        
        guard let data = snapshot.data() else {
            throw NSError(domain: "FirestoreError", code: 0, userInfo: [NSLocalizedDescriptionKey: "문서에 데이터가 없습니다."])
        }
        
        let decoder = Firestore.Decoder()
        let currentUser = try decoder.decode(User.self, from: data)
        
        return currentUser
    }
    
    @MainActor
    func updateUser(user: User) {
        if let userId = currentUser?.id {
            do {
                var updatedUser = user
                updatedUser.workoutPurpose = workoutPurpose.rawValue
                try UserViewModel.db.collection("users").document(userId).setData(from: updatedUser)
            } catch let error {
                print("Error updating user: \(error)")
            }
        }
    }
    
    func updateUser(with userInfo: UserInfo) {
           nickname = userInfo.nickname
       }
    
    // 사용자의 만 나이를 계산하는 메소드
    func calculateAge() -> Int {
        guard let dateOfBirth = currentUser?.dob else { return 0 }
        
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: now)
        let age = ageComponents.year!
        return age
    }
    
    func updateWorkoutPurpose(_ purpose: WorkoutPurpose) -> WorkoutPurpose {
        workoutPurpose = purpose
        return purpose
    }
    
    func updateGender(_ gender: Gender) {
            self.gender = gender
        }
    
}
