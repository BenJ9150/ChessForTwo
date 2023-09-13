//
//  ChessBoard.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

enum PieceColor {
    case white
    case black
}

struct ChessBoard {

    // MARK: - Public properties

    // static let columnName = ["A", "B", "C", "D", "E", "F", "G", "H"]

    // MARK: - Private properties

    private static let minPosition = 1
    private static let maxPosition = 8
}

// MARK: - Public methods

extension ChessBoard {

    static func isOutOfChessBoard(file: Int, rank: Int) -> Bool {
        return file < minPosition || file > maxPosition || rank < minPosition || rank > maxPosition
    }

    static func isOutOfChessBoard(position: Int) -> Bool {
        return position < minPosition || position > maxPosition
    }
}
