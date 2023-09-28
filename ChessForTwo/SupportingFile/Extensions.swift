//
//  Extensions.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 17/09/2023.
//

import Foundation

// MARK: - Notification.Name

extension Notification.Name {
    // piece moved
    static let whiteMoved = Notification.Name("WhiteMoved")
    static let blackMoved = Notification.Name("BlackMoved")
}
