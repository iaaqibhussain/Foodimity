//
//  NSObject+Extension.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 21.03.23.
//

import Foundation

extension NSObject {
    static var className: String {
        String(describing: self)
    }
}
