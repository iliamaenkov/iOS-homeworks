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
        let button = CustomButton(title: NSLocalizedString("Check", comment: "Проверить"), titleColor: .white) { [weak self] in
            self?.tapCheckButton()
        }
        return button
    }()
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = lightDark
        label.layer.masksToBounds = true
        label.text = NSLocalizedString("View post", comment: "Посмотреть пост")
        label.textColor = inverseLightDark
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.isUserInteractionEnabled = false
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resultLabelTapped)))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let guessTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
//        textField.placeholder = "Enter word"
        textField.text = "12"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.systemGray4.cgColor
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

        guessTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(50)
        }

        resultLabel.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(checkGuessButton.snp.top).offset(-20)
        }

        checkGuessButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
