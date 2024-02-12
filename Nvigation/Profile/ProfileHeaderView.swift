//
//  ProfileHeaderView.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 04.10.2023.
//

import UIKit

final class ProfileHeaderView: UIView {

    weak var profileVC: ProfileVIewControllerDelegate?
    
    weak var user: User? {
        didSet {
            setUserInfo()
        }
    }
    
    var avatarImageView = UIImageView()
    var returnAvatarButton = UIButton()
    var avatarBackground = UIView()
    
    private var statusTextField: String = ""
    
    private var avatarOriginPoint = CGPoint()
    
    //MARK: - UI Elements
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setStatusButton: CustomButton = {
        let button = CustomButton(title: "Set status", titleColor: .white) { [weak self] in
            self?.buttonPressed()
        }
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
    
    private func setUserInfo() {
        guard let currentUser = user else { return }
        fullNameLabel.text = currentUser.fullName
        statusLabel.text = currentUser.status
        avatarImageView.image = currentUser.avatar
    }
    
    
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
            
            NSLayoutConstraint.activate([
                avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
                avatarImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
                avatarImageView.widthAnchor.constraint(equalToConstant: 100),
                avatarImageView.heightAnchor.constraint(equalToConstant: 100),
                
                returnAvatarButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
                returnAvatarButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            ])
        
        }
    
    private func commonInit() {
        paddedTextField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(setStatusButton)
        addSubview(paddedTextField)
        
        setupAvatarImage()
        setupConstraints()
        setUserInfo()
    }
    
    //MARK: - Actions
    
    @objc private func tapOnAvatar() {
        profileVC?.scrollOff()

        // Animation
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
        profileVC?.scrollOn()
        
        UIImageView.animate(withDuration: 0.5) {
            UIImageView.animate(withDuration: 0.5) {
                self.returnAvatarButton.alpha = 0
                self.avatarImageView.center = self.avatarOriginPoint
                self.avatarImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                self.avatarBackground.alpha = 0
            }
        } completion: { _ in
            self.avatarImageView.isUserInteractionEnabled = true
        }
    }
    
    @objc func buttonPressed() {
            statusLabel.text = statusTextField
    }
    
    @objc func statusTextChanged(_ textField: UITextField) {
        statusTextField = textField.text ?? ""
    }
    
    //MARK: - Setting constraints
    
    private func setupConstraints() {
        let safeAreaGuide = self.safeAreaLayoutGuide
        
        setStatusButton.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(26)
            make.leading.equalTo(safeAreaGuide).offset(16)
            make.trailing.equalTo(safeAreaGuide).offset(-16)
            make.height.equalTo(50)
            make.bottom.equalTo(self).offset(-16)
        }
        
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaGuide).offset(27)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(safeAreaGuide).offset(-16)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.bottom.equalTo(setStatusButton.snp.top).offset(-64)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(safeAreaGuide).offset(-16)
        }
        
        paddedTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalTo(safeAreaGuide).offset(-16)
        }
    }
}


