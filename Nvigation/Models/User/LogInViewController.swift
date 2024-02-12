//
//  LogInViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 09.10.2023.
//

import UIKit
import FirebaseAuth
import SnapKit

protocol LoginViewControllerDelegate {
    func check(login email: String, password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
    func signUp(_ login: String, _ password: String, completion: @escaping (Result<Void, AuthError>) -> Void)
}

final class LogInViewController: UIViewController {
    
    var viewModel: ProfileViewModel
    var loginDelegate: LoginViewControllerDelegate?
    
    //MARK: - UI Elements
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.systemGray4.cgColor
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logInTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "User email"
        textField.keyboardType = .emailAddress
       
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true

        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var logInButton: CustomButton = {
        let button = CustomButton(title: "Log In", titleColor: .white) { [weak self] in
            self?.tapLogIn()
        }
        return button
    }()
    
    private lazy var signUpButton: CustomButton = {
        let button = CustomButton(title: "Sign Up", titleColor: .white) { [weak self] in
            self?.tapSignUp()
        }
        return button
    }()
    
    // MARK: - Init
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        addSubviews()
        setupConstraints()
        
        logInTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    //MARK: - Private
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(logInButton)
        contentView.addSubview(signUpButton)
        stackView.addArrangedSubview(logInTextField)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(passwordTextField)
    }
    
    //MARK: - Setting constraints
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }

        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(150)
            make.centerX.equalTo(scrollView)
            make.width.height.equalTo(100)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(120)
            make.leading.trailing.equalTo(scrollView).inset(16)
            make.height.equalTo(100)
        }

        logInButton.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(scrollView).inset(16)
            make.height.equalTo(50)
        }

        signUpButton.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView)
            make.top.equalTo(logInButton.snp.bottom).offset(8)
            make.leading.trailing.equalTo(scrollView).inset(16)
            make.height.equalTo(50)
            make.bottom.equalTo(scrollView)
        }

        logInTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        separatorView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
        
    }
    
    // MARK: - Actions
    
    private func tapLogIn() {
        guard let userLogin = logInTextField.text, !userLogin.isEmpty else {
            return displayErrorAlert(message: "Введите логин")
        }
        guard let userPassword = passwordTextField.text, !userPassword.isEmpty else {
            return displayErrorAlert(message: "Введите пароль")
        }
        
        loginDelegate?.check(login: userLogin, password: userPassword) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("User Login:", userLogin)
                print("User Password:", userPassword)
                
                let currentUser = User(login: userLogin, password: userPassword, fullName: "Kenobi", avatar: UIImage(named: "Kenobi")!, status: "Online")
                self.viewModel.currentUser = currentUser
                self.viewModel.showProfile?()
                
            case .failure(let error):
                switch error {
                case .invalidCredential:
                    self.displayErrorAlert(message: "Некорректные данные")
                case .unknown:
                    self.displayErrorAlert(message: "Ошибка аутентификации")
                }
            }
        }
    }


    private func tapSignUp() {
        guard let userLogin = logInTextField.text, !userLogin.isEmpty else {
            return displayErrorAlert(message: "Введите логин")
        }
        guard let userPassword = passwordTextField.text, !userPassword.isEmpty else {
            return displayErrorAlert(message: "Введите пароль")
        }
        
        loginDelegate?.signUp(userLogin, userPassword) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                let currentUser = User(login: userLogin, password: userPassword, fullName: "Kenobi", avatar: UIImage(named: "Kenobi")!, status: "Online")
                self.viewModel.currentUser = currentUser
                self.viewModel.showProfile?()
                
            case .failure(let error):
                switch error {
                case .invalidCredential:
                    self.displayErrorAlert(message: "Некорректные данные")
                case .unknown:
                    self.displayErrorAlert(message: "Ошибка аутентификации")
                }
            }
        }
    }



    public func displayErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    ///Keyboard
    @objc func willShowKeyboard(_ notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
        scrollView.scrollIndicatorInsets = .zero
    }
    
}

//MARK: - LogInViewController Extensions

extension LogInViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
