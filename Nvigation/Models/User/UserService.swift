//
//  UserService.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 20.11.2023.
//

import UIKit

protocol UserService {
    var user: User { get set }
    func checkUser(login: String) -> User?
}

extension UserService {
    func checkUser(login: String) -> User? {
        return login == user.login ? user : nil
    }
    func getUser() -> User { user }
}

class CurrentUserService: UserService {
    
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
}

class TestUserService: UserService {
    
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
}
