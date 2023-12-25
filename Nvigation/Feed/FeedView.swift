//
//  FeedView.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 07.12.2023.
//

import UIKit

final class FeedView: UIView {

    // Обработчик для кнопки проверки
    var onCheck: ((String) -> Void)?
    // Обработчик для тапа по результату
    var onResultLabelTapped: (() -> Void)?
    
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(title: "Check", titleColor: .white) { [weak self] in
            self?.tapCheckButton()
        }
        return button
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.layer.masksToBounds = true
        label.text = "View post"
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.isUserInteractionEnabled = false
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resultLabelTapped)))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let guessTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Enter word"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapCheckButton() {
        guard let word = guessTextField.text else { return }
        onCheck?(word)
    }
    
    func setButtonInteractionEnabled(_ enabled: Bool) {
        resultLabel.isUserInteractionEnabled = enabled
    }
    
    // Обработка тапа по результату
    @objc private func resultLabelTapped() {
        onResultLabelTapped?()
    }
    
    private func setupUI() {
        
        addSubview(checkGuessButton)
        addSubview(guessTextField)
        addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            guessTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            guessTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            guessTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            guessTextField.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.heightAnchor.constraint(equalToConstant: 50),
            resultLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            resultLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            resultLabel.bottomAnchor.constraint(equalTo: checkGuessButton.topAnchor, constant: -20),
            
            checkGuessButton.heightAnchor.constraint(equalToConstant: 50),
            checkGuessButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            checkGuessButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            checkGuessButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
