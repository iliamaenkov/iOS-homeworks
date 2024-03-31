//
//  UIColor.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 31.03.2024.
//

import UIKit

extension UIColor {
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .dark ? darkMode : lightMode
        }
    }
}

public let lightDark = UIColor.createColor(lightMode: .black, darkMode: .white)
public let inverseLightDark = UIColor.createColor(lightMode: .white, darkMode: .black)
