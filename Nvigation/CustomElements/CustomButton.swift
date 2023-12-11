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
    private var action: (() -> Void)?

    init(title: String, titleColor: UIColor, action: (() -> Void)?) {
        super.init(frame: .zero)
        
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.action = action
        
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
        action?()
    }
}
