//
//  FeedModel.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 07.12.2023.
//

import Foundation

final class FeedModedl {

    private let secretWord: String
    
    init(secretWord: String) {
        self.secretWord = secretWord
    }
    
    func check(_ word: String) -> Bool {
        return word == secretWord
    }
}
