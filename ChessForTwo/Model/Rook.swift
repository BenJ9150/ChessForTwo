//
//  Rook.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Rook: Piece {

    // MARK: - Public properties

    override class var initialWhitePos: [(Int, Int)] {
        return [(1, 1), (8, 1)]
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

        return validMoves
    }
}
