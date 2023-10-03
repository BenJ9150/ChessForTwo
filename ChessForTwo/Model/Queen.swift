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

    override func getValidMoves() -> [Square] {
        var validMoves: [Square] = []

        // vertical
        validMoves.append(contentsOf: ValidMoves.validUp(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ValidMoves.validDown(file: currentFile, rank: currentRank, color: color))
        // horizontal
        validMoves.append(contentsOf: ValidMoves.validLeft(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ValidMoves.validRight(file: currentFile, rank: currentRank, color: color))
        // first diagonal
        validMoves.append(contentsOf: ValidMoves.validUpRight(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ValidMoves.validDownLeft(file: currentFile, rank: currentRank, color: color))
        // second diagonal
        validMoves.append(contentsOf: ValidMoves.validUpLeft(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ValidMoves.validDownRight(file: currentFile, rank: currentRank, color: color))

        return validMoves
    }
}
