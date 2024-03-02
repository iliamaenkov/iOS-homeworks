//
//  CheckerService.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 23.01.2024.
//

import UIKit
import FirebaseAuth

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
    func signUp(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
}


enum AuthError: Error {
    case invalidCredential
    case unknown
}

final class CheckerService: CheckerServiceProtocol {
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.invalidCredential.rawValue:
                    completion(.failure(AuthError.invalidCredential))
                default:
                    print("Firebase Authentication Error:", error)
                    completion(.failure(AuthError.unknown))
                }
            } else {
                completion(.success(()))
            }
        }
    }



    func signUp(email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                switch error.code {
                case AuthErrorCode.invalidCredential.rawValue:
                    completion(.failure(AuthError.invalidCredential))
                default:
                    print("Firebase Authentication Error:", error)
                    completion(.failure(AuthError.unknown))
                }
            } else {
                completion(.success(()))
            }
        }
    }
}

struct LoginInspector: LoginViewControllerDelegate {
    
    private let checkerService: CheckerService
    
    init(checkerService: CheckerService) {
        self.checkerService = checkerService
    }
    
    func check(login email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        checkerService.checkCredentials(email: email, password: password, completion: completion)
    }
    
    func signUp(_ email: String, _ password: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        checkerService.signUp(email: email, password: password, completion: completion)
    }
}

