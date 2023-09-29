//
//  Pawn.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Pawn: Piece {

    // MARK: - Public properties

    let color: PieceColor

    var movingTwoSquaresAtMove: Int? {
        return movingTwoSqAtMove
    }

    var currentFile: Int {
        return file
    }

    var currentRank: Int {
        return rank
    }

    var hasNotMoved: Bool {
        return firstMove
    }

    // initial positions : file, white rank
    static let initialWhitePos = [(1, 2), (2, 2), (3, 2), (4, 2), (5, 2), (6, 2), (7, 2), (8, 2)]

    // MARK: - Private properties

    private var movingTwoSqAtMove: Int?
    private var file: Int
    private var rank: Int
    private var firstMove: Bool

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor) {
        self.file = initialFile
        self.rank = initialRank
        self.color = color
        self.movingTwoSqAtMove = nil
        self.firstMove = true
    }

    convenience init() {
        self.init(initialFile: 0, initialRank: 0, color: .white)
    }
}

// MARK: - Public methods

extension Pawn {

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool {
        let validMoves = getAllValidMoves()
        if !validMoves.contains(Square(file: newFile, rank: newRank)) { return false }

        // valid move, check if move of 2 squares
        if abs(rank - newRank) == 2 {
            movingTwoSqAtMove = ChessBoard.movesCount + 1 // +1 for this new move
        } else {
            movingTwoSqAtMove = nil
        }
        // update positions and move possibility
        file = newFile
        rank = newRank
        firstMove = false
        return true
    }

    func getAllValidMoves() -> [Square] {
        let validMoves: [Square]
        switch color {
        case .white:
            validMoves = getAllWhiteValidMoves()
        case .black:
            validMoves = getAllBlackValidMoves()
        }
        return validMoves
    }
}

// MARK: - Private methods for White

extension Pawn {

    private func getAllWhiteValidMoves() -> [Square] {
        var validMoves: [Square] = []

        // vertical and capture
        validMoves.append(contentsOf: getWhiteValidMovesUp())
        validMoves.append(contentsOf: getWhiteDiagonalValidMoves())

        return validMoves
    }

    private func getAllBlackValidMoves() -> [Square] {
        var validMoves: [Square] = []

        // vertical and capture
        validMoves.append(contentsOf: getBlackValidMovesDown())
        validMoves.append(contentsOf: getBlackDiagonalValidMoves())

        return validMoves
    }

    private func getWhiteValidMovesUp() -> [Square] {
        var validMoves: [Square] = []
        // vertical + 1
        if rank < ChessBoard.maxPosition {
            validMoves.append(contentsOf: getCoordinateIfEmptyAt(newFile: file, newRank: rank + 1))
        }
        // vertical + 2
        if hasNotMoved && validMoves.count == 1 && rank + 1 < ChessBoard.maxPosition {
            validMoves.append(contentsOf: getCoordinateIfEmptyAt(newFile: file, newRank: rank + 2))
        }
        return validMoves
    }

    private func getWhiteDiagonalValidMoves() -> [Square] {
        var validMoves: [Square] = []
        // Left - Up
        if rank < ChessBoard.maxPosition && file > ChessBoard.minPosition {
            validMoves.append(contentsOf: getCoordinateIfCaptureAt(newFile: file - 1, newRank: rank + 1))
        }
        // Right - Up
        if rank < ChessBoard.maxPosition && file < ChessBoard.maxPosition {
            validMoves.append(contentsOf: getCoordinateIfCaptureAt(newFile: file + 1, newRank: rank + 1))
        }
        return validMoves
    }
}

// MARK: - Private methods for Black

extension Pawn {

    private func getBlackValidMovesDown() -> [Square] {
        var validMoves: [Square] = []
        // vertical - 1
        if rank > ChessBoard.minPosition {
            validMoves.append(contentsOf: getCoordinateIfEmptyAt(newFile: file, newRank: rank - 1))
        }
        // vertical - 2
        if hasNotMoved && validMoves.count == 1 && rank - 1 > ChessBoard.minPosition {
            validMoves.append(contentsOf: getCoordinateIfEmptyAt(newFile: file, newRank: rank - 2))
        }
        return validMoves
    }

    private func getBlackDiagonalValidMoves() -> [Square] {
        var validMoves: [Square] = []
        // Left - Down
        if rank > ChessBoard.minPosition && file > ChessBoard.minPosition {
            validMoves.append(contentsOf: getCoordinateIfCaptureAt(newFile: file - 1, newRank: rank - 1))
        }
        // Right - Down
        if rank > ChessBoard.minPosition && file < ChessBoard.maxPosition {
            validMoves.append(contentsOf: getCoordinateIfCaptureAt(newFile: file + 1, newRank: rank - 1))
        }
        return validMoves
    }
}

// MARK: - Private common methods

extension Pawn {

    private func getCoordinateIfCaptureAt(newFile: Int, newRank: Int) -> [Square] {
        var validMoves: [Square] = []
        let chessBoard = Square(file: newFile, rank: newRank)

        // check if square is empty for capture in passing
        if ChessBoard.isEmpty(atPosition: chessBoard) {
            // check if capture in passing
            let chessBoardCapInPass = Square(file: newFile, rank: rank)
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

    private func getCoordinateIfEmptyAt(newFile: Int, newRank: Int) -> [Square] {
        var validMoves: [Square] = []
        let chessBoard = Square(file: newFile, rank: newRank)

        // check if square is empty
        if ChessBoard.isEmpty(atPosition: chessBoard) {
            validMoves.append(chessBoard)
        }
        return validMoves
    }
}
