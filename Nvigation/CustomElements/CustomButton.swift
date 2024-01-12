//
//  CustomButton.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 12.10.2023.
//

import UIKit

// MARK: - CustomButton

final class CustomButton: UIButton {
    
    private let cornerRadius: CGFloat = 10
    
    typealias Action = () -> Void
    
    var buttonAction: Action

    init(title: String, titleColor: UIColor = .white, action: @escaping Action) {
            buttonAction = action
            super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        let backgroundImage = UIImage(named: "blue_pixel")
        let titleColor = UIColor.white
        autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        translatesAutoresizingMaskIntoConstraints = false
        setBackgroundImage(backgroundImage, for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        buttonAction()
    }
}
