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
    func changeStateIfNeeded()
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
    
    init() {
#if DEBUG
        self.service = CurrentUserService.shared
#else
        self.service = TestUserService.shared
#endif
    }
    
    func changeStateIfNeeded() {
        state = .loading
        service.getCurrentUser { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let users):
                    state = .loaded(users)
                case .failure(_):
                    state = .error
            }
        }
    }
}
