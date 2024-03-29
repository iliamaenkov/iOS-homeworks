//
//  User.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 20.11.2023.
//

import UIKit

public class User {
    
    var login: String
    var password: String
    var fullName: String
    var avatar: UIImage
    var status: String
    
    init(
        login: String,
        password: String,
        fullName: String,
        avatar: UIImage,
        status: String
    )
    {
        self.login = login
        self.password = password
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
    
}
