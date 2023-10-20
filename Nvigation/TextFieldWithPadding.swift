//
//  TextFieldWithPadding.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 06.10.2023.
//

import UIKit

// MARK: - TextFieldWithPadding

final class TextFieldWithPadding: UITextField {
    
    // Properties
    
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )
    
    // Text Field Rect Overrides
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}
