//
//  FCUser.swift
//  Ringfit
//
//  Created by Chloe Chung on 2/27/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Identifiable, Hashable, Codable {
    /// 유저 아이디
    var id: String?
    
    /// 이름, 닉네임
    var name: String
    var nickName: String?
    
    /// 이메일(ID), 비밀번호
    var email: String
    /// 생년월일
    var dob: Date? = nil
    
    /// 성별
    var gender: String
    
    /// 안정시 심박수
    var stabledPulse: Int? = 0
    
    /// 운동 목적
    var workoutPurpose: String
}
