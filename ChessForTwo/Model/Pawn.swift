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

    override func getValidMoves() -> [Square] {
        let validMoves: [Square]
        switch color {
        case .white:
            validMoves = getWhiteDiagonalValidMoves() + getWhiteValidMovesUp()
        case .black:
            validMoves = getBlackDiagonalValidMoves() + getBlackValidMovesDown()
        }
        return validMoves
    }

    override func getAttackedSquares() -> [Square] {
        return color == .white ? getWhiteDiagonalAttack() : getBlackDiagonalAttack()
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

    private func getWhiteDiagonalAttack() -> [Square] {
        var validMoves: [Square] = []
        // Left - Up
        if currentRank < ChessBoard.maxPosition && currentFile > ChessBoard.minPosition {
            validMoves.append(Square(file: currentFile - 1, rank: currentRank + 1))
        }
        // Right - Up
        if currentRank < ChessBoard.maxPosition && currentFile < ChessBoard.maxPosition {
            validMoves.append(Square(file: currentFile + 1, rank: currentRank + 1))
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

    private func getBlackDiagonalAttack() -> [Square] {
        var validMoves: [Square] = []
        // Left - Down
        if currentRank > ChessBoard.minPosition && currentFile > ChessBoard.minPosition {
            validMoves.append(Square(file: currentFile - 1, rank: currentRank - 1))
        }
        // Right - Down
        if currentRank > ChessBoard.minPosition && currentFile < ChessBoard.maxPosition {
            validMoves.append(Square(file: currentFile + 1, rank: currentRank - 1))
        }
        return validMoves
    }
}

// MARK: - Private common methods

extension Pawn {

    private func squaresIfCaptureAt(newFile: Int, newRank: Int) -> [Square] {
        let square = Square(file: newFile, rank: newRank)

        // check if square is empty for capture in passing
        if ChessBoard.isEmpty(atPosition: square) {
            // check if capture in passing
            let chessBoardCapInPass = Square(file: newFile, rank: currentRank)
            if let pieceCapInPass = ChessBoard.piece(atPosition: chessBoardCapInPass) {
                // check if captured piece is Pawn and good color
                if pieceCapInPass is Pawn, pieceCapInPass.color != color {
                    // check if piece just move of 2 squares
                    if let moveTwo = pieceCapInPass.movingTwoSquaresAtMove, moveTwo == ChessBoard.movesCount {
                        return [square]
                    }
                }
            }
        }
        // check if capture
        if let piece = ChessBoard.piece(atPosition: square), piece.color != color {
            return [square]
        }
        return []
    }

    private func squaresIfEmptyAt(newFile: Int, newRank: Int) -> [Square] {
        let square = Square(file: newFile, rank: newRank)

        // check if square is empty
        if ChessBoard.isEmpty(atPosition: square) {
            return [square]
        }
        return []
    }
}
