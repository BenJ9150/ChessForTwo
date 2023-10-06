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
    static let moveDone = Notification.Name("MoveDone")
    // captured piece
    static let capturedPieceAtPosition = Notification.Name("CapturedPieceAtPosition")
    // promotion
    static let promotion = Notification.Name("Promotion")
    static let promotionHasChosen = Notification.Name("PromotionHasChosen")
    // castling
    static let castling = Notification.Name("Castling")
}

// MARK: - UIView

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

// MARK: - UIImage

extension UIImage {

    public func rotate() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        context.translateBy(x: self.size.width/2, y: self.size.height/2)
        context.scaleBy(x: -1.0, y: -1.0)
        context.translateBy(x: -self.size.width/2, y: -self.size.height/2)

        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

// MARK: - UIColor

extension UIColor {

    static let kingIsCheck = UIColor(named: "color_KingIsCheck")!
    static let kingIsCheckmate = UIColor(named: "color_kingIsCheckmate")!
    static let selectedSquare = UIColor(named: "color_selectedSquare")!
}
