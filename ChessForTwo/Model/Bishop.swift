//
//  Bishop.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Bishop: Pieces {

    // MARK: - Public properties

    override class var initialWhitePos: [(Int, Int)] {
        return [(3, 1), (6, 1)]
    }

    // MARK: - Public methods

    override func getAllValidMoves() -> [Square] {
        var validMoves: [Square] = []

        // first diagonal
        validMoves.append(contentsOf: ChessBoard.validUpRight(fromFile: currentFile,
                                                                      andRank: currentRank, ofColor: color))
        validMoves.append(contentsOf: ChessBoard.validDownLeft(fromFile: currentFile,
                                                                       andRank: currentRank, ofColor: color))
        // second diagonal
        validMoves.append(contentsOf: ChessBoard.validUpLeft(fromFile: currentFile,
                                                                     andRank: currentRank, ofColor: color))
        validMoves.append(contentsOf: ChessBoard.validDownRight(fromFile: currentFile,
                                                                        andRank: currentRank, ofColor: color))

        return validMoves
    }
}
