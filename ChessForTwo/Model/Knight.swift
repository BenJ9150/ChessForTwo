//
//  Knight.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Knight: Pieces {

    // MARK: - Public properties

    override class var initialWhitePos: [(Int, Int)] {
        return [(2, 1), (7, 1)]
    }

    // MARK: - Public methods

    override func getAllValidMoves() -> [Square] {
        var validMoves: [Square] = []

        validMoves.append(contentsOf: checkValidMoveAt(file: currentFile - 2, rank: currentRank - 1))
        validMoves.append(contentsOf: checkValidMoveAt(file: currentFile - 2, rank: currentRank + 1))
        validMoves.append(contentsOf: checkValidMoveAt(file: currentFile - 1, rank: currentRank - 2))
        validMoves.append(contentsOf: checkValidMoveAt(file: currentFile - 1, rank: currentRank + 2))
        validMoves.append(contentsOf: checkValidMoveAt(file: currentFile + 1, rank: currentRank - 2))
        validMoves.append(contentsOf: checkValidMoveAt(file: currentFile + 1, rank: currentRank + 2))
        validMoves.append(contentsOf: checkValidMoveAt(file: currentFile + 2, rank: currentRank - 1))
        validMoves.append(contentsOf: checkValidMoveAt(file: currentFile + 2, rank: currentRank + 1))

        return validMoves
    }
}

// MARK: - Private methods

extension Knight {

    private func checkValidMoveAt(file: Int, rank: Int) -> [Square] {
        var validMoves: [Square] = []

        if rank < ChessBoard.maxPosition && file > ChessBoard.minPosition {
            let chessBoard = Square(file: file, rank: rank)
            // check if there is a piece
            if let piece = ChessBoard.piece(atPosition: chessBoard) {
                if piece.color != color { validMoves.append(chessBoard) }
                return validMoves
            }
            // empty square
            validMoves.append(chessBoard)
        }
        return validMoves
    }
}
