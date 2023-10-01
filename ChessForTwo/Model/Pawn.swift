//
//  Pawn.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Pawn: Piece {

    // MARK: - Public properties

    override class var initialWhitePos: [(Int, Int)] {
        return [(1, 2), (2, 2), (3, 2), (4, 2), (5, 2), (6, 2), (7, 2), (8, 2)]
    }

    // MARK: - Public methods

    override func getAttackedSquares() -> [Square] {
        let validMoves: [Square]
        switch color {
        case .white:
            validMoves = getWhiteDiagonalValidMoves()
        case .black:
            validMoves = getBlackDiagonalValidMoves()
        }
        return validMoves
    }

    override func getOtherValidMoves() -> [Square] {
        let validMoves: [Square]
        switch color {
        case .white:
            validMoves = getWhiteValidMovesUp()
        case .black:
            validMoves = getBlackValidMovesDown()
        }
        return validMoves
    }
}

// MARK: - Private methods for White

extension Pawn {

    private func getWhiteValidMovesUp() -> [Square] {
        var validMoves: [Square] = []
        // vertical + 1
        if currentRank < ChessBoard.maxPosition {
            validMoves.append(contentsOf: squaresIfEmptyAt(newFile: currentFile, newRank: currentRank + 1))
        }
        // vertical + 2
        if hasNotMoved && validMoves.count == 1 && currentRank + 1 < ChessBoard.maxPosition {
            validMoves.append(contentsOf: squaresIfEmptyAt(newFile: currentFile, newRank: currentRank + 2))
        }
        return validMoves
    }

    private func getWhiteDiagonalValidMoves() -> [Square] {
        var validMoves: [Square] = []
        // Left - Up
        if currentRank < ChessBoard.maxPosition && currentFile > ChessBoard.minPosition {
            validMoves.append(contentsOf: squaresIfCaptureAt(newFile: currentFile - 1, newRank: currentRank + 1))
        }
        // Right - Up
        if currentRank < ChessBoard.maxPosition && currentFile < ChessBoard.maxPosition {
            validMoves.append(contentsOf: squaresIfCaptureAt(newFile: currentFile + 1, newRank: currentRank + 1))
        }
        return validMoves
    }
}

// MARK: - Private methods for Black

extension Pawn {

    private func getBlackValidMovesDown() -> [Square] {
        var validMoves: [Square] = []
        // vertical - 1
        if currentRank > ChessBoard.minPosition {
            validMoves.append(contentsOf: squaresIfEmptyAt(newFile: currentFile, newRank: currentRank - 1))
        }
        // vertical - 2
        if hasNotMoved && validMoves.count == 1 && currentRank - 1 > ChessBoard.minPosition {
            validMoves.append(contentsOf: squaresIfEmptyAt(newFile: currentFile, newRank: currentRank - 2))
        }
        return validMoves
    }

    private func getBlackDiagonalValidMoves() -> [Square] {
        var validMoves: [Square] = []
        // Left - Down
        if currentRank > ChessBoard.minPosition && currentFile > ChessBoard.minPosition {
            validMoves.append(contentsOf: squaresIfCaptureAt(newFile: currentFile - 1, newRank: currentRank - 1))
        }
        // Right - Down
        if currentRank > ChessBoard.minPosition && currentFile < ChessBoard.maxPosition {
            validMoves.append(contentsOf: squaresIfCaptureAt(newFile: currentFile + 1, newRank: currentRank - 1))
        }
        return validMoves
    }
}

// MARK: - Private common methods

extension Pawn {

    private func squaresIfCaptureAt(newFile: Int, newRank: Int) -> [Square] {
        var validMoves: [Square] = []
        let chessBoard = Square(file: newFile, rank: newRank)

        // check if square is empty for capture in passing
        if ChessBoard.isEmpty(atPosition: chessBoard) {
            // check if capture in passing
            let chessBoardCapInPass = Square(file: newFile, rank: currentRank)
            if let pieceCapInPass = ChessBoard.piece(atPosition: chessBoardCapInPass), pieceCapInPass.color != color {
                // check if piece just move of 2 squares
                if let justMoveTwoSq = pieceCapInPass.movingTwoSquaresAtMove, justMoveTwoSq == ChessBoard.movesCount {
                    validMoves.append(chessBoard)
                    return validMoves
                }
            }
        }

        // check if capture
        if let piece = ChessBoard.piece(atPosition: chessBoard), piece.color != color {
            validMoves.append(chessBoard)
        }
        return validMoves
    }

    private func squaresIfEmptyAt(newFile: Int, newRank: Int) -> [Square] {
        var validMoves: [Square] = []
        let chessBoard = Square(file: newFile, rank: newRank)

        // check if square is empty
        if ChessBoard.isEmpty(atPosition: chessBoard) {
            validMoves.append(chessBoard)
        }
        return validMoves
    }
}
