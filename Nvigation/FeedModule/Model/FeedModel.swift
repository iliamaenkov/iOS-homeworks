//
//  FeedModel.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 07.12.2023.
//

import Foundation

final class FeedModedl {
    
    // Обработчик для результата проверки слова
    var onCheckResult: ((Bool) -> Void)?
    
    private let secretWord: String
    
    init(secretWord: String) {
        self.secretWord = secretWord
    }
    
    func check(_ word: String) {
        let isCorrect = word == secretWord
        onCheckResult?(isCorrect)
    }
}
