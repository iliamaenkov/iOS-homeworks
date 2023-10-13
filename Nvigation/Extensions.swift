//
//  Exyensions.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 13.10.2023.
//
import UIKit

extension TextFieldWithPadding: UITextFieldDelegate {}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
