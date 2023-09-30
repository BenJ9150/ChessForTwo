//
//  Knight.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Knight: Piece {

    // MARK: - Public properties

    let color: PieceColor
    var movingTwoSquaresAtMove: Int? // just for protocol, use for pawn
    let hasNotMoved = false // just for protocol, use for pawn, rook and king

    var currentFile: Int {
        return file
    }

    var currentRank: Int {
        return rank
    }

    var oldFile: Int {
        return lastFile
    }

    var oldRank: Int {
        return lastRank
    }

    // initial positions : file, white rank
    static let initialWhitePos = [(2, 1), (7, 1)]

    // MARK: - Private properties

    private var file: Int
    private var rank: Int
    private var lastFile: Int
    private var lastRank: Int

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor) {
        self.file = initialFile
        self.rank = initialRank
        self.lastFile = initialFile
        self.lastRank = initialRank
        self.color = color
    }

    convenience init() {
        self.init(initialFile: 0, initialRank: 0, color: .white)
    }
}

// MARK: - Public methods

extension Knight {

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool {
        let validMoves = getAllValidMoves()
        if !validMoves.contains(Square(file: newFile, rank: newRank)) { return false }

        // valid move
        lastFile = file
        lastRank = rank
        file = newFile
        rank = newRank

        // update total moves count
        ChessBoard.movesCount += 1
        return true
    }

    func getAllValidMoves() -> [Square] {
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
