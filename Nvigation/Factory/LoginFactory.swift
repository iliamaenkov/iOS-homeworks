//
//  LoginFactory.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 29.11.2023.
//

import UIKit

protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    private let checkerService: CheckerService
    
    init(checkerService: CheckerService) {
        self.checkerService = checkerService
    }
    
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector(checkerService: checkerService)
    }
}


