//
//  Queen.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Queen: Piece {

    // MARK: - Public properties

    override class var initialWhitePos: [(Int, Int)] {
        return [(4, 1)]
    }

    // MARK: - Public methods

    override func getAttackedSquares() -> [Square] {
        var validMoves: [Square] = []

        // vertical
        validMoves.append(contentsOf: ChessBoard.validUp(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ChessBoard.validDown(file: currentFile, rank: currentRank, color: color))
        // horizontal
        validMoves.append(contentsOf: ChessBoard.validLeft(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ChessBoard.validRight(file: currentFile, rank: currentRank, color: color))
        // first diagonal
        validMoves.append(contentsOf: ChessBoard.validUpRight(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ChessBoard.validDownLeft(file: currentFile, rank: currentRank, color: color))
        // second diagonal
        validMoves.append(contentsOf: ChessBoard.validUpLeft(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ChessBoard.validDownRight(file: currentFile, rank: currentRank, color: color))

        return validMoves
    }
}
