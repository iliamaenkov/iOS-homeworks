//
//  ProfileViewModel.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 18.12.2023.
//

import UIKit
import Foundation

enum State {
    case initial
    case loading
    case loaded(User)
    case error
}

protocol ProfileViewModelOutput {
    var state: State { get set }
    var currentState: ((State) -> Void)? { get set }
    func loadUser()
    var showPhotoGallery: Action? { get set }
    var showProfile: Action? { get set }
}

final class ProfileViewModel: ProfileViewModelOutput {
    
    static let shared = ProfileViewModel(service: CheckerService())
    
    var showProfile: Action?
    var showPhotoGallery: Action?
    var currentUser: User?
    
    private let service: CheckerServiceProtocol?
    var currentState: ((State) -> Void)?
    
    var state: State = .initial {
        didSet {
            print(state)
            currentState?(state)
        }
    }
    
    init(service: CheckerServiceProtocol) {
        self.service = service
    }
    
    func loadUser() {
        state = .loading
        if let currentUser = currentUser {
            state = .loaded(currentUser)
        } else {
            state = .error
        }
    }
}
