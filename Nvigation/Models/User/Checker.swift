//
//  Checker.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 28.11.2023.
//

import UIKit

final class Checker {
    
    let login: String?
    var password: String?
    
    var service: UserService
    static let shared = Checker()
    
    private init() {
#if DEBUG
        service = TestUserService()
#else
        service = CurrentUserService()
#endif
        login = service.getUser().login
        password = service.getUser().password
    }
    
    func check(login: String, password: String) -> Bool {
        login == self.login && password == self.password
    }
}

struct LoginInspector: LoginViewControllerDelegate {
    
    func check(_ login: String, _ password: String) -> Bool {
         Checker.shared.check(login: login, password: password)
     } 
}
