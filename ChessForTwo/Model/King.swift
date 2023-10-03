//
//  King.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class King: Piece {

    // MARK: - Public properties

    override class var initialWhitePos: [(Int, Int)] {
        return [(5, 1)]
    }

    // MARK: - Public methods

    override func getValidMoves() -> [Square] {
        return getValidMovesWithoutCastling() + getMovesForCastling()
    }

    override func getAttackedSquares() -> [Square] {
        return getValidMovesWithoutCastling()
    }
}

// MARK: - Private methods

extension King {

    private func getValidMovesWithoutCastling() -> [Square] {
        var validMoves: [Square] = []

        // vertical
        if let move = ValidMoves.validUp(file: currentFile, rank: currentRank, color: color).first {
            validMoves.append(move)
        }
        if let move = ValidMoves.validDown(file: currentFile, rank: currentRank, color: color).first {
            validMoves.append(move)
        }
        // horizontal
        if let move = ValidMoves.validLeft(file: currentFile, rank: currentRank, color: color).first {
            validMoves.append(move)
        }
        if let move = ValidMoves.validRight(file: currentFile, rank: currentRank, color: color).first {
            validMoves.append(move)
        }
        // first diagonal
        if let move = ValidMoves.validUpRight(file: currentFile, rank: currentRank, color: color).first {
            validMoves.append(move)
        }
        if let move = ValidMoves.validDownLeft(file: currentFile, rank: currentRank, color: color).first {
            validMoves.append(move)
        }
        // second diagonal
        if let move = ValidMoves.validUpLeft(file: currentFile, rank: currentRank, color: color).first {
            validMoves.append(move)
        }
        if let move = ValidMoves.validDownRight(file: currentFile, rank: currentRank, color: color).first {
            validMoves.append(move)
        }

        return validMoves
    }

    private func getMovesForCastling() -> [Square] {
        var validMoves: [Square] = []
        // check for castling
        if let leftCastlingPos = validMoveForCastling(atLeft: true) {
            validMoves.append(leftCastlingPos)
        }
        if let rightCastlingPos = validMoveForCastling(atLeft: false) {
            validMoves.append(rightCastlingPos)
        }
        return validMoves
    }

    private func validMoveForCastling(atLeft leftMoves: Bool) -> Square? {
        // check if king has moved
        if !hasNotMoved { return nil }

        // check if there is piece at rook's square
        let piece: Pieces?
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
            moves = ValidMoves.validLeft(file: currentFile, rank: currentRank, color: color)
        } else {
            moves = ValidMoves.validRight(file: currentFile, rank: currentRank, color: color)
        }
        if moves.count != (leftMoves ? 3 : 2) { return nil }

        // get attacked position
        let attackedSquares = ChessBoard.attackedSquares(byColor: (color == .white ? .black : .white))

        // check if King is attacked
        if attackedSquares.contains(square) { return nil }

        // check if 2 left empty squares are attacked
        if attackedSquares.contains(moves[0]) || attackedSquares.contains(moves[1]) { return nil }

        // Castling is ok! return second position for castling
        return moves[1]
    }
}
