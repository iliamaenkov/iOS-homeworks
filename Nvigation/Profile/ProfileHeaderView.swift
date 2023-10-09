//
//  ProfileHeaderView.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 04.10.2023.
//

import UIKit

class ProfileHeaderView: UIView {
    
    private var statusText: String = ""
    
    //MARK: - Creating UI Elements
    
    private let avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Kenobi")
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jedi Master Obi-Van Kenobi"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .black
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "May the Force be with you..."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let statusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        return button
    }()
    
    private let paddedTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Set status..."
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    private func commonInit() {
        statusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        paddedTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        
        addSubview(avatarImage)
        addSubview(profileNameLabel)
        addSubview(statusLabel)
        addSubview(statusButton)
        addSubview(paddedTextField)
    }
    
    @objc func buttonPressed() {
        statusLabel.text = statusText
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
    
    //MARK: - Setting constraints
    
    private func setupConstraints() {
        let safeAreaInsets = self.safeAreaInsets
        let viewWidth = self.bounds.size.width
        let viewHeight = self.bounds.size.height
        let padding: CGFloat = 16
        let paddingOrientation: CGFloat = viewWidth > viewHeight ? 100 : 0
        
        avatarImage.frame = CGRect(
            x: safeAreaInsets.left + padding,
            y: safeAreaInsets.top + padding,
            width: 100,
            height: 100
        )
        
        statusButton.frame = CGRect(
            x: safeAreaInsets.left + padding,
            y: avatarImage.frame.maxY + padding + 20,
            width: viewWidth - padding * 2 - paddingOrientation,
            height: 50
        )
        
        profileNameLabel.frame = CGRect(
            x: avatarImage.frame.maxX + padding,
            y: safeAreaInsets.top + 27,
            width: viewWidth - avatarImage.frame.maxX - 2 * padding,
            height: profileNameLabel.font.lineHeight
        )
        
        statusLabel.frame = CGRect(
            x: avatarImage.frame.maxX + padding,
            y: statusButton.frame.minY - 54 - statusLabel.font.lineHeight,
            width: profileNameLabel.frame.width,
            height: statusLabel.font.lineHeight
        )
        
        paddedTextField.frame = CGRect(
            x: avatarImage.frame.maxX + padding,
            y: statusButton.frame.minY - 50,
            width: profileNameLabel.frame.width,
            height: 40
        )
    }
}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}

