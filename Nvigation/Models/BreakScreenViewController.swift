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

        NSLayoutConstraint.activate([
            breakImageView.topAnchor.constraint(equalTo: view.topAnchor),
            breakImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            breakImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            breakImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: breakImageView.bottomAnchor, constant: 20),
            infoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12),
            infoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12),

            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 120),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
