//
//  Extensions.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 17/09/2023.
//

import Foundation
import UIKit

// MARK: - NSLayoutConstraint

extension NSLayoutConstraint {

    func setMultiplier(_ multiplier: CGFloat, andRefresh viewToRefresh: UIView) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)

        newConstraint.priority = priority
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        viewToRefresh.layoutIfNeeded()
        return newConstraint
    }
}

// MARK: - String

extension String {

    // action sheet
    static let cancel = NSLocalizedString(String(localized: "cancel"), tableName: nil, comment: "")
    static let resumeGame = NSLocalizedString(String(localized: "resumeGame"), tableName: nil, comment: "")
    static let startNewGame = NSLocalizedString(String(localized: "startNewGame"), tableName: nil, comment: "")
    static let startAlertTitle = NSLocalizedString(String(localized: "startAlertTitle"), tableName: nil, comment: "")
    // result
    static let drawByRepetition = NSLocalizedString(String(localized: "drawByRepetition"), tableName: nil, comment: "")
    static let stalemate = NSLocalizedString(String(localized: "stalemate"), tableName: nil, comment: "")
    static let youLose = NSLocalizedString(String(localized: "youLose"), tableName: nil, comment: "")
    static let youWin = NSLocalizedString(String(localized: "youWin"), tableName: nil, comment: "")
}

// MARK: - Notification.Name

extension Notification.Name {

    // piece moved
    static let moveDone = Notification.Name("MoveDone")
    // captured piece
    static let capture = Notification.Name("Capture")
    // promotion
    static let promotion = Notification.Name("Promotion")
    static let promotionDone = Notification.Name("PromotionDone")
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

    static let imageNameKey = "assetName"

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

// MARK: UIImageView

extension UIImageView {

    static func getPieceImageView(piece: Pieces) -> UIImageView? {
        return UIImageView(image: UIImage(named: "ic_\(piece.color)\(String(describing: type(of: piece)))"))
    }
}

// MARK: - UIColor

extension UIColor {

    static let kingIsCheck = UIColor(named: "color_kingIsCheck")!
    static let kingIsCheckmate = UIColor(named: "color_kingIsCheckmate")!
    static let selectedSquare = UIColor(named: "color_selectedSquare")!
    static let blackSquare = UIColor(named: "color_blackSquare")!
    static let whiteSquare = UIColor(named: "color_whiteSquare")!
}
