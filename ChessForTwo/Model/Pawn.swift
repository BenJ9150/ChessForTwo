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

    var currentFile: Int {
        return file
    }

    var currentRank: Int {
        return rank
    }

    // initial positions : file, white rank
    static let initialWhitePos = [(1, 2), (2, 2), (3, 2), (4, 2), (5, 2), (6, 2), (7, 2), (8, 2)]

    // MARK: - Private properties

    private var file: Int
    private var rank: Int
    private var canMoveTwoSquares = true

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor) {
        self.file = initialFile
        self.rank = initialRank
        self.color = color
    }

    convenience init() {
        self.init(initialFile: 0, initialRank: 0, color: .white)
    }
}

// MARK: - Public methods

extension Pawn {

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool {
        let validMoves: [ChessBoard]
        switch color {
        case .white:
            validMoves = getAllWhiteValidMoves()
        case .black:
            validMoves = getAllBlackValidMoves()
        }
        if !validMoves.contains(ChessBoard(file: newFile, rank: newRank)) { return false }

        // valid move
        file = newFile
        rank = newRank
        canMoveTwoSquares = false
        return true
    }

    func getAllWhiteValidMoves() -> [ChessBoard] {
        var validMoves: [ChessBoard] = []

        // vertical and capture
        validMoves.append(contentsOf: getWhiteValidMovesUp())
        validMoves.append(contentsOf: getWhiteDiagonalValidMoves())

        return validMoves
    }

    func getAllBlackValidMoves() -> [ChessBoard] {
        var validMoves: [ChessBoard] = []

        // vertical and capture
        validMoves.append(contentsOf: getBlackValidMovesDown())
        validMoves.append(contentsOf: getBlackDiagonalValidMoves())

        return validMoves
    }
}

// MARK: - Private methods for White

extension Pawn {

    private func getWhiteValidMovesUp() -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        // vertical + 1
        if rank < ChessBoard.maxPosition {
            let chessBoard = ChessBoard(file: file, rank: rank + 1)
            // check if square is empty
            if ChessBoard.board[chessBoard] == nil {
                validMoves.append(chessBoard)
            }
        }
        // vertical + 2
        if canMoveTwoSquares && validMoves.count == 1 && rank + 1 < ChessBoard.maxPosition {
            let chessBoard = ChessBoard(file: file, rank: rank + 2)
            // check if square is empty
            if ChessBoard.board[chessBoard] == nil {
                validMoves.append(chessBoard)
            }
        }
        return validMoves
    }

    private func getWhiteDiagonalValidMoves() -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        // Left - Up
        if rank < ChessBoard.maxPosition && file > ChessBoard.minPosition {
            let chessBoard = ChessBoard(file: file - 1, rank: rank + 1)
            // check if capture
            if let piece = ChessBoard.board[chessBoard], piece.color != color {
                validMoves.append(chessBoard)
            }
        }
        // Right - Up
        if rank < ChessBoard.maxPosition && file < ChessBoard.maxPosition {
            let chessBoard = ChessBoard(file: file + 1, rank: rank + 1)
            // check if capture
            if let piece = ChessBoard.board[chessBoard], piece.color != color {
                validMoves.append(chessBoard)
            }
        }
        return validMoves
    }
}

// MARK: - Private methods for Black

extension Pawn {

    private func getBlackValidMovesDown() -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        // vertical - 1
        if rank > ChessBoard.minPosition {
            let chessBoard = ChessBoard(file: file, rank: rank - 1)
            // check if square is empty
            if ChessBoard.board[chessBoard] == nil {
                validMoves.append(chessBoard)
            }
        }
        // vertical - 2
        if canMoveTwoSquares && validMoves.count == 1 && rank - 1 > ChessBoard.minPosition {
            let chessBoard = ChessBoard(file: file, rank: rank - 2)
            // check if square is empty
            if ChessBoard.board[chessBoard] == nil {
                validMoves.append(chessBoard)
            }
        }
        return validMoves
    }

    private func getBlackDiagonalValidMoves() -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        // Left - Down
        if rank > ChessBoard.minPosition && file > ChessBoard.minPosition {
            let chessBoard = ChessBoard(file: file - 1, rank: rank - 1)
            // check if capture
            if let piece = ChessBoard.board[chessBoard], piece.color != color {
                validMoves.append(chessBoard)
            }
        }
        // Right - Down
        if rank > ChessBoard.minPosition && file < ChessBoard.maxPosition {
            let chessBoard = ChessBoard(file: file + 1, rank: rank - 1)
            // check if capture
            if let piece = ChessBoard.board[chessBoard], piece.color != color {
                validMoves.append(chessBoard)
            }
        }
        return validMoves
    }
}
