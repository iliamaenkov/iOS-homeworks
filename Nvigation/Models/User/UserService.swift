//
//  UserService.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 20.11.2023.
//

import UIKit

protocol UserService: AnyObject {
    var user: User { get set }
    func checkUser(login: String) -> User?
    func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void)
}

extension UserService {
    func checkUser(login: String) -> User? {
        return login == user.login ? user : nil
    }
    func getUser() -> User { user }
}

class CurrentUserService: UserService {

    static let shared = CurrentUserService()
    var currentUser: User?
    
    var user = User(
        login: "Kenobi",
        password: "yoda",
        fullName: "Obi Van Kenobi",
        avatar: UIImage(named: "Kenobi")!,
        status: "Online"
    )
    init() {
        self.user = User(
            login: "Kenobi",
            password: "yoda",
            fullName: "Obi Van Kenobi",
            avatar: UIImage(named: "Kenobi")!,
            status: "Online"
        )
    }
    
    func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            guard let self = self else { return }
            completion(.success(self.user))
        })
    }
}

class TestUserService: UserService {
    
    static let shared = TestUserService()
    var currentUser: User?
    
    var user = User(
        login: "Test",
        password: "12345",
        fullName: "Test_User",
        avatar: UIImage(named: "No_avatar")!,
        status: "DEBUG"
    )
    init() {
        self.user = User(
            login: "Test",
            password: "12345",
            fullName: "Test_User",
            avatar: UIImage(named: "No_avatar")!,
            status: "DEBUG"
        )
    }
    
    func getCurrentUser(completion: @escaping (Result<User, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            guard let self = self else { return }
            completion(.success(self.user))
        })
    }
}
