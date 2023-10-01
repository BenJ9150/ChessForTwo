//
//  Bishop.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Bishop: Piece {

    // MARK: - Public properties

    override class var initialWhitePos: [(Int, Int)] {
        return [(3, 1), (6, 1)]
    }

    // MARK: - Public methods

    override func getAttackedSquares() -> [Square] {
        var validMoves: [Square] = []

        // first diagonal
        validMoves.append(contentsOf: ChessBoard.validUpRight(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ChessBoard.validDownLeft(file: currentFile, rank: currentRank, color: color))
        // second diagonal
        validMoves.append(contentsOf: ChessBoard.validUpLeft(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ChessBoard.validDownRight(file: currentFile, rank: currentRank, color: color))

        return validMoves
    }
}
