//
//  ProfileHeaderView.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 04.10.2023.
//

import UIKit
import SnapKit

final class ProfileHeaderView: UIView {
    
    var avatarImageView = UIImageView()
    var returnAvatarButton = UIButton()
    var avatarBackground = UIView()
    
    private var statusTextField: String = ""
    
    private var avatarOriginPoint = CGPoint()
    
    //MARK: - UI Elements
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Obi-Van Kenobi"
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "May the Force be with you..."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let setStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show status", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
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
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: - Private
    
    private func setupAvatarImage() {
            avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            avatarImageView.image = UIImage(named: "Kenobi")
            avatarImageView.layer.cornerRadius = 50
            avatarImageView.layer.borderWidth = 3
            avatarImageView.layer.borderColor = UIColor.white.cgColor
            avatarImageView.clipsToBounds = true
            
            // Guesture recognizer for avatar
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnAvatar))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            avatarImageView.isUserInteractionEnabled = true
            avatarImageView.addGestureRecognizer(tapGesture)
            
            // Cancel button
            returnAvatarButton.translatesAutoresizingMaskIntoConstraints = false
            returnAvatarButton.alpha = 0
            returnAvatarButton.backgroundColor = .clear
            returnAvatarButton.contentMode = .scaleToFill
            returnAvatarButton.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22))?.withTintColor(.black, renderingMode: .automatic), for: .normal)
            returnAvatarButton.tintColor = .black
            returnAvatarButton.addTarget(self, action: #selector(returnAvatarToOrigin), for: .touchUpInside)
            
            // Set background
            avatarBackground = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            avatarBackground.backgroundColor = .darkGray
            avatarBackground.isHidden = true
            avatarBackground.alpha = 0
            
        addSubview(avatarBackground)
        addSubview(avatarImageView)
        addSubview(returnAvatarButton)
        
        }
    
    private func commonInit() {
        
        setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        paddedTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)

        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(setStatusButton)
        addSubview(paddedTextField)
        
        setupAvatarImage()
        setupConstraints()
    }
    
    //MARK: - Actions
    
    @objc private func tapOnAvatar() {
        // Animation
        avatarImageView.isUserInteractionEnabled = false
        
//        ProfileViewController.tableView.isScrollEnabled = false
//        ProfileViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = false
        
        avatarOriginPoint = avatarImageView.center
        let scale = UIScreen.main.bounds.width / avatarImageView.bounds.width
        
        UIView.animate(withDuration: 0.5) {
            self.avatarImageView.center = CGPoint(x: UIScreen.main.bounds.midX,
                                                  y: UIScreen.main.bounds.midY - self.avatarOriginPoint.y)
            self.avatarImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.avatarImageView.layer.cornerRadius = 0
            self.avatarBackground.isHidden = false
            self.avatarBackground.alpha = 0.7
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.returnAvatarButton.alpha = 1
            }
        }
    }
    
    @objc private func returnAvatarToOrigin() {
        UIImageView.animate(withDuration: 0.5) {
            UIImageView.animate(withDuration: 0.5) {
                self.returnAvatarButton.alpha = 0
                self.avatarImageView.center = self.avatarOriginPoint
                self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                self.avatarBackground.alpha = 0
            }
        } completion: { _ in
//            ProfileViewController.tableView.isScrollEnabled = true
//            ProfileViewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.isUserInteractionEnabled = true
            self.avatarImageView.isUserInteractionEnabled = true
        }
    }
    
    @objc func buttonPressed() {
            statusLabel.text = statusTextField
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        statusTextField = textField.text ?? ""
    }
    
    //MARK: - SnapKit constraints
    
    private func setupConstraints() {
        
        let safeArea = self.safeAreaLayoutGuide
        
        ///avatarImage
        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(safeArea.snp.left).inset(16)
            make.top.equalTo(safeArea.snp.top).inset(16)
            make.width.equalTo(100)
            make.height.equalTo(avatarImageView.snp.width)
        }
        ///returnButton
        returnAvatarButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
        ///statusButton
        setStatusButton.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).inset(-26)
            make.left.equalTo(safeArea.snp.left).inset(16)
            make.right.equalTo(safeArea.snp.right).inset(16)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(16)
        }
        ///fullName
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(27)
            make.left.equalTo(avatarImageView.snp.right).inset(-16)
            make.right.equalTo(safeArea.snp.right).inset(16)
        }
        ///statusLabel
        statusLabel.snp.makeConstraints { make in
            make.bottom.equalTo(setStatusButton.snp.top).inset(-64)
            make.left.equalTo(avatarImageView.snp.right).inset(-16)
            make.right.equalTo(safeArea.snp.right).inset(16)
        }
        ///textField
        paddedTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).inset(-10)
            make.left.equalTo(avatarImageView.snp.right).inset(-16)
            make.right.equalTo(safeArea.snp.right).inset(16)
        }
            
    }
}


