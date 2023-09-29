//
//  King.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class King: Piece {

    // MARK: - Public properties

    let color: PieceColor
    var movingTwoSquaresAtMove: Int? = nil // just for protocol, use for pawn

    var currentFile: Int {
        return file
    }

    var currentRank: Int {
        return rank
    }

    var canCastling = true

    // initial positions : file, white rank
    static let initialWhitePos = [(5, 1)]

    // MARK: - Private properties

    private var file: Int
    private var rank: Int

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

extension King {

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool {
        let validMoves = getAllValidMoves()
        if !validMoves.contains(ChessBoard(file: newFile, rank: newRank)) { return false }

        // valid move
        file = newFile
        rank = newRank
        canCastling = false
        return true
    }

    func getAllValidMoves() -> [ChessBoard] {
        var validMoves: [ChessBoard] = []

        // vertical
        if let move = ChessBoard.getValidMovesUp(fromFile: file, andRank: rank, ofColor: color).first {
            validMoves.append(move)
        }
        if let move = ChessBoard.getValidMovesDown(fromFile: file, andRank: rank, ofColor: color).first {
            validMoves.append(move)
        }
        // horizontal
        if let move = ChessBoard.getValidMovesLeft(fromFile: file, andRank: rank, ofColor: color).first {
            validMoves.append(move)
        }
        if let move = ChessBoard.getValidMovesRight(fromFile: file, andRank: rank, ofColor: color).first {
            validMoves.append(move)
        }
        // first diagonal
        if let move = ChessBoard.getValidMovesUpRight(fromFile: file, andRank: rank, ofColor: color).first {
            validMoves.append(move)
        }
        if let move = ChessBoard.getValidMovesDownLeft(fromFile: file, andRank: rank, ofColor: color).first {
            validMoves.append(move)
        }
        // second diagonal
        if let move = ChessBoard.getValidMovesUpLeft(fromFile: file, andRank: rank, ofColor: color).first {
            validMoves.append(move)
        }
        if let move = ChessBoard.getValidMovesDownRight(fromFile: file, andRank: rank, ofColor: color).first {
            validMoves.append(move)
        }

        return validMoves
    }
}
