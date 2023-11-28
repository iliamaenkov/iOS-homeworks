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

    // Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // Setup button
    
    private func setup() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        let backgroundImage = UIImage(named: "blue_pixel")
        let titleColor = UIColor.white
        autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        translatesAutoresizingMaskIntoConstraints = false
        setBackgroundImage(backgroundImage, for: .normal)
        setTitleColor(titleColor, for: .normal)
    }
}
