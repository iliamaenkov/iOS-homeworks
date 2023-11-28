//
//  UserService.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 20.11.2023.
//

import UIKit

protocol UserService {
    func checkUser(_ userLogin: String) -> User?
}

class CurrentUserService: UserService {
    
    private var currentUser: User?
    
    init() {
        self.currentUser = User(
            logIn: "Kenobi",
            fullName: "Obi Van Kenobi",
            avatar: UIImage(named: "Kenobi") ?? UIImage(named: "No_avatar")!,
            status: "Online")
    }
    
    func checkUser(_ userLogin: String) -> User? {
        if let user = currentUser, user.logIn == userLogin {
            print("User Found: \(user.fullName)")
            return user
        }
        print("User Not Found")
        return nil
    }
}

class TestUserService: UserService {
    
    private var currentUser: User?
    
    init() {
        self.currentUser = User(
            logIn: "Test",
            fullName: "Test User",
            avatar: UIImage(named: "No_avatar")!,
            status: "Debug mode")
    }
    
    func checkUser(_ userLogin: String) -> User? {
        if let user = currentUser, user.logIn == userLogin {
            print("User Found: \(user.fullName)")
            return user
        }
        print("User Not Found")
        return nil
    }
}
