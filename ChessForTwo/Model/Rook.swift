//
//  Rook.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Rook: Pieces {

    // MARK: - Public properties

    override class var initialWhitePos: [(Int, Int)] {
        return [(1, 1), (8, 1)]
    }

    // MARK: - Public methods

    override func getAllValidMoves() -> [Square] {
        var validMoves: [Square] = []

        // vertical
        validMoves.append(contentsOf: ChessBoard.validUp(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ChessBoard.validDown(file: currentFile, rank: currentRank, color: color))
        // horizontal
        validMoves.append(contentsOf: ChessBoard.validLeft(file: currentFile, rank: currentRank, color: color))
        validMoves.append(contentsOf: ChessBoard.validRight(file: currentFile, rank: currentRank, color: color))

        return validMoves
    }
}
