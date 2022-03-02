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
        return self.count > 40 ? false : true
    }
}

/// Date extension to check for eempty data
extension Data {
    func isEmptyData() -> Bool {
        return self.count == 0 ? true : false
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

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: reloadData)
            { _ in completion() }
    }
}

extension Date {
    
    static var startApiDate: Date?
    static var startAppDate: Date?

    static func appViewStarted () -> Void {
        startAppDate = Self()
    }
    
    static func currentDate() -> Void {
        startApiDate = Self()
    }

    static func timelapsedSinceApiHit() -> Double {
        guard let starDateMS = startApiDate else {return 0.0}
        return fabs( starDateMS.timeIntervalSinceNow) * 1000
    }
    
    static func appViewLoadedComplete() -> Double {
        guard let starDateMS = startAppDate else {return 0.0}
        return fabs( starDateMS.timeIntervalSinceNow) * 1000
    }
    
}
