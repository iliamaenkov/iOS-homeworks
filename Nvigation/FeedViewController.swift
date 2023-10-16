//
//  FeedViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - Properties
    
    let postTitle = PostTitle(title: "New Post")
    
    // MARK: - UI Elements
    
    private lazy var stackView: UIStackView = { [weak self] in
        guard let self = self else { return UIStackView() }
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10.0
        
        stackView.addArrangedSubview(self.viewFirstButton)
        stackView.addArrangedSubview(self.viewSecondButton)
        
        return stackView
    }()
    
    private lazy var firstButton: UIButton = {
        let button = UIButton()
        button.setTitle("First Btn", for: .normal)
        button.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
                
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var viewFirstButton: UIView = {
        let view = UIView()
        view.addSubview(firstButton)
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return view
    }()
    
    private lazy var secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("Second Btn", for: .normal)
        button.addTarget(self, action: #selector(showPostButtonTapped), for: .touchUpInside)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 4
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.systemRed.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowOpacity = 0.7
        button.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
                
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var viewSecondButton: UIView = {
        let view = UIView()
        view.addSubview(secondButton)
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        return view
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray5
        self.title = "Feed"
        
        view.addSubview(stackView)
        setupConstraints()
    }
    
    // MARK: - Actions
    
    @objc func showPostButtonTapped() {
        let postViewController = PostViewController()
        postViewController.postTitle = postTitle
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    // MARK: - Setting constraints
    
    private func setupConstraints() {
        
        let safeAreaGuide = self.view.safeAreaLayoutGuide
        
        let safeAreaGuideView1 = self.viewFirstButton.safeAreaLayoutGuide
        let safeAreaGuideView2 = self.viewSecondButton.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            firstButton.centerYAnchor.constraint(equalTo: safeAreaGuideView1.centerYAnchor),
            firstButton.leadingAnchor.constraint(equalTo: safeAreaGuideView1.leadingAnchor, constant: 16),
            firstButton.trailingAnchor.constraint(equalTo: safeAreaGuideView1.trailingAnchor, constant: -16),
            firstButton.heightAnchor.constraint(equalToConstant: 50),
            
            secondButton.centerYAnchor.constraint(equalTo: safeAreaGuideView2.centerYAnchor),
            secondButton.leadingAnchor.constraint(equalTo: safeAreaGuideView2.leadingAnchor, constant: 16),
            secondButton.trailingAnchor.constraint(equalTo: safeAreaGuideView2.trailingAnchor, constant: -16),
            secondButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

