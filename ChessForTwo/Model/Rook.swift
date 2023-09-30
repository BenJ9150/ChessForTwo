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
        validMoves.append(contentsOf: ChessBoard.validUp(fromFile: currentFile,
                                                         andRank: currentRank, ofColor: color))
        validMoves.append(contentsOf: ChessBoard.validDown(fromFile: currentFile,
                                                           andRank: currentRank, ofColor: color))
        // horizontal
        validMoves.append(contentsOf: ChessBoard.validLeft(fromFile: currentFile,
                                                           andRank: currentRank, ofColor: color))
        validMoves.append(contentsOf: ChessBoard.validRight(fromFile: currentFile,
                                                            andRank: currentRank, ofColor: color))

        return validMoves
    }
}
