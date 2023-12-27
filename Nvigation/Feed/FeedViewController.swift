//
//  FeedViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit
import StorageService

final class FeedViewController: UIViewController {
    
    var coordinator: FeedCoordinator?
    
    // MARK: - Properties
    private var viewModel: FeedViewModel
    private let feed = FeedModel(secretWord: "12")
    lazy var feedView = FeedView()

    
    // MARK: - Init
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - View Controller Lifecycle
    
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupEvents()
        bindViewModel()
    }
    
    //MARK: - Private
    
    private func bindViewModel() {
        viewModel.updateUI = { [weak self] in
            self?.feedView.resultLabel.backgroundColor = self?.viewModel.isResultCorrect ?? false ? .green : .red
            self?.feedView.setButtonInteractionEnabled(self?.viewModel.isResultCorrect ?? false)
        }
        
        viewModel.resetFeed = { [weak self] in
            self?.feedView.resultLabel.backgroundColor = .black
            self?.feedView.guessTextField.text = ""
            self?.feedView.setButtonInteractionEnabled(false)
        }
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
        viewModel.show?()
        viewModel.resetFeed?()
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

