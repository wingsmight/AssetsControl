//
//  UIApplication+Ext.swift
//  Splus
//
//  Created by Igoryok on 12.02.2023.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        windows
            .filter(\.isKeyWindow)
            .first?
            .endEditing(force)
    }
}
