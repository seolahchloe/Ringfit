// AuthViewModel.swift
// Ringfit
//
// Created by Chloe Chung on 2/27/24.

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct UserInfo {
    let nickname: String
}

class AuthViewModel: ObservableObject {
    @Published var signInState: SignInState = .signOut
    
    static let shared = AuthViewModel()
    
    enum SignInState {
        case signIn
        case signOut
        case signUp
    }
    
    func signOut() {
        let signType = UserDefaults.standard.string(forKey: "SignType")
        if signType == "email" {
            emailAuthSignOut()
        }
        print("로그아웃되었습니다.")
    }
    
    func signIn(email: String, password: String) {
            // 로그인 로직 구현
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
                if let error = error {
                    // 로그인 실패 처리
                    print("로그인 실패: \(error.localizedDescription)")
                    return
                }
                
                // 로그인 성공 후 사용자 정보 가져오기
                self?.fetchUserInfo { userInfo in
                    // 사용자 정보를 UserViewModel에 저장
                    UserViewModel.shared.updateUser(with: userInfo)
                    
                    // 로그인 상태 업데이트
                    DispatchQueue.main.async {
                        self?.signInState = .signIn
                    }
                }
            }
        }
    
    func fetchUserInfo(completion: @escaping (UserInfo) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Firestore에서 사용자 정보 가져오기
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("사용자 정보 가져오기 실패: \(error.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot, let data = snapshot.data() {
                let nickname = data["nickname"] as? String ?? ""
                let userInfo = UserInfo(nickname: nickname)
                completion(userInfo)
            }
        }
    }
    
    // MARK: - Firebase 정보 관련
    @MainActor
    func uploadUserData(uid: String, name: String, nickname: String, email: String, gender: String, dob: Date, stabledPulse: Int, workoutPurpose: WorkoutPurpose) async {
        let user = User(name: name, nickName: nickname, email: email, dob: dob, gender: gender, workoutPurpose: workoutPurpose.rawValue)
        let userDict: [String: Any] = [
            "id": uid,
            "name": user.name,
            "nickName": user.nickName,
            "email": user.email,
            "dob": user.dob,
            "gender": user.gender,
            "workoutPurpose": user.workoutPurpose,
            "stabledPulse": user.stabledPulse
        ]
        
        do {
            let userRef = Firestore.firestore().collection("users").document(uid)
            try await userRef.setData(userDict)
            print("UserData uploaded successfully")
        } catch {
            print("Error uploading UserData: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Email 로그인
    /// 회원가입
    @MainActor
    func emailAuthSignUp(withEmail email: String, password: String, name: String, nickname: String, gender: String, stabledPulse: Int, dob: Date, workoutPurpose: WorkoutPurpose) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            await uploadUserData(uid: result.user.uid, name: name, nickname: nickname, email: email, gender: gender, dob: dob, stabledPulse: stabledPulse, workoutPurpose: workoutPurpose)
            let currentUser = try await UserViewModel.shared.uidLoadUserData(result.user.uid)
            print(currentUser.nickName)
//            self.currentUser = .customUser(currentUser)
            
            self.signInState = .signIn
        } catch {
            print("email SignUp error: \(error.localizedDescription)")
        }
    }
    
    /// 로그인
    @MainActor
    func emailAuthSignIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.signInState = .signIn
            UserDefaults.standard.set("email", forKey: "SignType")
            try await UserViewModel.shared.loadUserData()
        } catch {
            print("email SignIn error: \(error.localizedDescription)")
            throw error // 에러를 throw하여 호출한 곳에서 처리할 수 있도록 합니다.
        }
    }
    
    /// 로그아웃
    func emailAuthSignOut() {
        do {
            try Auth.auth().signOut()
//            self.currentUser = nil
            UserViewModel.shared.currentUser = nil
            self.signInState = .signOut
            UserDefaults.standard.removeObject(forKey: "SignType")
        } catch {
            print("email SignOut error: \(error.localizedDescription)")
        }
    }
    
    /// 비밀번호 변경
    func changePassword(currentPassword: String, newPassword: String, confirmPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
         guard let user = Auth.auth().currentUser else {
             completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "사용자를 찾을 수 없습니다."])))
             return
         }
         
         let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)
         
         user.reauthenticate(with: credential) { result, error in
             if let error = error {
                 completion(.failure(error))
                 return
             }
             
             if newPassword != confirmPassword {
                 completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "새로운 비밀번호와 비밀번호 확인이 일치하지 않습니다."])))
                 return
             }
             
             user.updatePassword(to: newPassword) { error in
                 if let error = error {
                     completion(.failure(error))
                 } else {
                     completion(.success(()))
                 }
             }
         }
     }
}

