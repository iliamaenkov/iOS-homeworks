//
//  CustomButton.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 12.10.2023.
//

import UIKit

// MARK: - CustomButton

class CustomButton: UIButton {
    
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

    // Private Methods
    
    private func setup() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        let backgroundImage = UIImage(named: "blue_pixel")
        setBackgroundImage(backgroundImage, for: .normal)
    }
}
