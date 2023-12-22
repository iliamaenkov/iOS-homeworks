//
//  ProfileViewModel.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 18.12.2023.
//

import UIKit
import Foundation

protocol ProfileViewModelOutput {
    var state: State { get set }
    var currentState: ((State) -> Void)? { get set }
    func loadUser()
}

enum State {
    case initial
    case loading
    case loaded(User)
    case error
}

final class ProfileViewModel: ProfileViewModelOutput {
    
    private let service: UserService
    var currentState: ((State) -> Void)?
    
    var state: State = .initial {
        didSet {
            print(state)
            currentState?(state)
        }
    }
    
    init(service: UserService) {
        self.service = service
    }
    
    func loadUser() {
         state = .loading
         service.getCurrentUser { [weak self] result in
             guard let self = self else { return }
             switch result {
             case .success(let user):
                 self.state = .loaded(user)
             case .failure(_):
                 self.state = .error
             }
         }
     }
}
