//
//  ExtensionHelper.swift
//  FruitsiOSApp
//
//  Created by kumaresh shrivastava on 27/02/2022.
//

import Foundation
import UIKit


// Extension to get String Value
extension LosslessStringConvertible {
    var string: String { .init(self) }
}

// Extension to get String Value from double in configurable digits places after decimal point
extension FloatingPoint where Self: CVarArg {
    func fixedFraction(digits: Int) -> String {
        .init(format: "%.*f", digits, self)
    }
}

/// Date extension to check for invalid data
extension Data {
    func isInValid() -> Bool {
        return self.count > 200 ? false : true
    }
}

/// A Helper to remove view from the superview
extension UIView {
    func remove() {
        self.removeFromSuperview()
    }
}

/// Extension of UIApplication to get the connected scene
extension UIApplication {
    var keyWindow: UIWindow? {
        /// Get connected scenes
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
