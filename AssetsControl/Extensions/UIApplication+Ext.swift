//
//  UIApplication+Ext.swift
//
//  Created by Igoryok
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
