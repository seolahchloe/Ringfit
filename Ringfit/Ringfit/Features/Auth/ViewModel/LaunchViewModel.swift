//
//  LaunchViewModel.swift
//  Ringfit
//
//  Created by Chloe Chung on 3/24/24.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine

class LaunchViewModel: ObservableObject {
    private let authService = AuthViewModel.shared
    private let userService = UserViewModel.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var authUser: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        setUpSubscribers()
    }
    
    func setUpSubscribers() {
        authService.$signInState
            .sink { [weak self] state in
                if state == .signIn {
                    self?.authUser = Auth.auth().currentUser
                } else {
                    self?.authUser = nil
                }
            }
            .store(in: &cancellables)
        
        userService.$currentUser
            .sink { [weak self] user in
                self?.currentUser = user
            }
            .store(in: &cancellables)
    }
}
