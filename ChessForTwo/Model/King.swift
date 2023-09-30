//
//  King.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class King: Pieces {

    // MARK: - Public properties

    override class var initialWhitePos: [(Int, Int)] {
        return [(5, 1)]
    }

    // MARK: - Public methods

    override func getAllValidMoves() -> [Square] {
        var validMoves: [Square] = []

        // vertical
        if let move = ChessBoard.validUp(fromFile: currentFile,
                                                 andRank: currentRank, ofColor: color).first {
            validMoves.append(move)
        }
        if let move = ChessBoard.validDown(fromFile: currentFile,
                                                   andRank: currentRank, ofColor: color).first {
            validMoves.append(move)
        }
        // horizontal
        if let move = ChessBoard.validLeft(fromFile: currentFile,
                                                   andRank: currentRank, ofColor: color).first {
            validMoves.append(move)
        }
        if let move = ChessBoard.validRight(fromFile: currentFile,
                                                    andRank: currentRank, ofColor: color).first {
            validMoves.append(move)
        }
        // first diagonal
        if let move = ChessBoard.validUpRight(fromFile: currentFile,
                                                      andRank: currentRank, ofColor: color).first {
            validMoves.append(move)
        }
        if let move = ChessBoard.validDownLeft(fromFile: currentFile,
                                                       andRank: currentRank, ofColor: color).first {
            validMoves.append(move)
        }
        // second diagonal
        if let move = ChessBoard.validUpLeft(fromFile: currentFile,
                                                     andRank: currentRank, ofColor: color).first {
            validMoves.append(move)
        }
        if let move = ChessBoard.validDownRight(fromFile: currentFile,
                                                        andRank: currentRank, ofColor: color).first {
            validMoves.append(move)
        }

        return validMoves
    }

    override func getOtherMoves() -> [Square] {
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
            moves = ChessBoard.validLeft(fromFile: currentFile, andRank: currentRank, ofColor: color)
        } else {
            moves = ChessBoard.validRight(fromFile: currentFile, andRank: currentRank, ofColor: color)
        }
        if moves.count != (leftMoves ? 3 : 2) { return nil }

        // get attacked position
        let attackedPositions = ChessBoard.getAttackedPositions(byColor: (color == .white ? .black : .white))

        // check if King is attacked
        if attackedPositions.contains(Square(file: currentFile, rank: currentRank)) { return nil }

        // check if 2 left empty squares are attacked
        if attackedPositions.contains(moves[0]) || attackedPositions.contains(moves[1]) { return nil }

        // Castling is ok! return second position for castling
        return moves[1]
    }
}
