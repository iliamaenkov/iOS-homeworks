//
//  FeedModel.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 07.12.2023.
//

import Foundation

final class FeedModel {

    private let secretWord: String
    
    init(secretWord: String) {
        self.secretWord = secretWord
    }
    
    func check(_ word: String) -> Bool {
        return word == secretWord
    }
}

protocol FeedViewModelOutput {
    var show: Action? { get set }
}

final class FeedViewModel: FeedViewModelOutput {
    
    static let shared = FeedViewModel()
    
    var show: Action?
    
    var updateUI: (() -> Void)?
    var resetFeed: (() -> Void)?
    
    var isResultCorrect: Bool = false {
        didSet {
            updateUI?()
        }
    }
}
