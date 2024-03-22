//
//  Extensions.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 22.03.2024.
//

import Foundation

extension String {
    var localize: String {
        NSLocalizedString(self, tableName: "LocalizableDict", comment: "")
    }
}
