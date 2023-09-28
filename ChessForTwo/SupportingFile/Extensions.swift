//
//  Extensions.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 17/09/2023.
//

import Foundation
import UIKit

// MARK: - Notification.Name

extension Notification.Name {
    // piece moved
    static let whiteMoved = Notification.Name("WhiteMoved")
    static let blackMoved = Notification.Name("BlackMoved")
}

extension UIView {
    @IBInspectable
    var rotation: Int {
        get {
            return 0
        } set {
            let radians = ((CGFloat.pi) * CGFloat(newValue) / CGFloat(180.0))
            self.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
}
