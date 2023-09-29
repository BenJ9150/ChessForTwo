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
    var movingTwoSquaresAtMove: Int? // just for protocol, use for pawn

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
    static let initialWhitePos = [(5, 1)]

    // MARK: - Private properties

    private var file: Int
    private var rank: Int
    private var firstMove: Bool

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor) {
        self.file = initialFile
        self.rank = initialRank
        self.color = color
        self.firstMove = true
    }

    convenience init() {
        self.init(initialFile: 0, initialRank: 0, color: .white)
    }
}

// MARK: - Public methods

extension King {

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool {
        var validMoves = getAllValidMoves()

        // check for castling
        if let leftCastlingPos = validMoveForCastling(atLeft: true) {
            validMoves.append(leftCastlingPos)
        }
        if let rightCastlingPos = validMoveForCastling(atLeft: false) {
            validMoves.append(rightCastlingPos)
        }

        // check valid move
        if !validMoves.contains(Square(file: newFile, rank: newRank)) { return false }

        // valid move
        file = newFile
        rank = newRank
        firstMove = false
        return true
    }

    func getAllValidMoves() -> [Square] {
        var validMoves: [Square] = []

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

// MARK: - Private methods

extension King {

    private func validMoveForCastling(atLeft leftMoves: Bool) -> Square? {
        // check if king has moved
        if !hasNotMoved { return nil }

        // check if there is piece at rook's square
        let piece: Piece?
        switch color {
        case .white:
            piece = ChessBoard.piece(atPosition: Square(file: leftMoves ? 1 : 8, rank: 1))
        case .black:
            piece = ChessBoard.piece(atPosition: Square(file: leftMoves ? 1 : 8, rank: 8))
        }

        // check if rook has moved
        guard let rook = piece, rook is Rook, rook.hasNotMoved else { return nil }

        // check if left squares are empty
        let moves: [Square]
        if leftMoves {
            moves = ChessBoard.getValidMovesLeft(fromFile: file, andRank: rank, ofColor: color)
        } else {
            moves = ChessBoard.getValidMovesRight(fromFile: file, andRank: rank, ofColor: color)
        }
        if moves.count != (leftMoves ? 3 : 2) { return nil }

        // get attacked position
        let attackedPositions = ChessBoard.getAttackedPositions(byColor: (color == .white ? .black : .white))

        // check if King is attacked
        if attackedPositions.contains(Square(file: file, rank: rank)) { return nil }

        // check if 2 left empty squares are attacked
        if attackedPositions.contains(moves[0]) || attackedPositions.contains(moves[1]) { return nil }

        // Castling is ok! return second position for castling
        return moves[1]
    }
}
