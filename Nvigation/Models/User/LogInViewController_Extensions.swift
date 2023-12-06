//
//  LogInViewController_Extensions.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 19.10.2023.
//

import UIKit

//MARK: - LogInViewController Extensions

extension LogInViewController: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
