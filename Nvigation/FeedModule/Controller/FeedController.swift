//
//  FeedViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit
import StorageService

final class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    private let feed = FeedModedl(secretWord: "12")
    lazy var feedView = FeedView()
    
    let postTitle = PostTitle(title: "New Post")
    
    // MARK: - View Controller Lifecycle
    
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupEvents()
    }
    
    private func setupEvents() {
        feedView.onCheck = { [weak self] word in
            self?.handleCheck(word: word)
        }
        feedView.onResultLabelTapped = { [weak self] in
            self?.handleResultLabelTapped()
        }
    }
    
    // Проверка слова
    private func handleCheck(word: String) {
        guard !word.isEmpty else {
            // Показать алерт
            showAlert(message: "Введите контрольное слово.")
            feedView.setButtonInteractionEnabled(false)
            return
        }
        let isCorrect = feed.check(word)
        feedView.resultLabel.backgroundColor = isCorrect ? .green : .red
        feedView.setButtonInteractionEnabled(isCorrect)
    }
    
    //Обрабатываем тап по результату
    private func handleResultLabelTapped() {
        let postViewController = PostViewController()
        postViewController.feedViewController = self
        postViewController.postTitle = postTitle
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

