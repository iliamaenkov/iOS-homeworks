//
//  BreakScreenViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 29.12.2023.
//

import UIKit

class BreakScreenViewController: UIViewController {

    private lazy var breakImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "sad_tiger"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Пора заняться делом и выполнить оставшиеся задания!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("ОК", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(breakImageView)
        view.addSubview(infoLabel)
        view.addSubview(closeButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        breakImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height).multipliedBy(0.5)
        }

        infoLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(breakImageView.snp.bottom).offset(20)
            make.right.equalTo(view.snp.right).offset(-12)
            make.left.equalTo(view.snp.left).offset(12)
        }

        closeButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
