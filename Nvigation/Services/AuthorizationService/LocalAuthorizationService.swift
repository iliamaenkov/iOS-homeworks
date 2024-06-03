//
//  LocalAuthorizationService.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 03.05.2024.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizationService {
    
    static let defaultService = LocalAuthorizationService()
    
    private var context = LAContext()
    
    var isFaceIDAvailable: Bool {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    func authorizeIfPossible(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Проверимся") { success, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    completion(false)
                } else {
                    completion(success)
                }
            }
        }
    }
    
}
