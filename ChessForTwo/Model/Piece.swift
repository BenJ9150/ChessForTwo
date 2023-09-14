//
//  Piece.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 13/09/2023.
//

import Foundation

enum PieceColor {
    case white
    case black
}

protocol Piece {

    // MARK: - Public properties

    var color: PieceColor { get }

    // MARK: - Public methods

    func setNewPosition(atFile newFile: Int, andRank newRank: Int, capture: Bool) -> Bool
}
