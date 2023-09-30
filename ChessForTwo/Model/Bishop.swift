//
//  Bishop.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Bishop: Piece {

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
    static let initialWhitePos = [(3, 1), (6, 1)]

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

extension Bishop {

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

        // first diagonal
        validMoves.append(contentsOf: ChessBoard.getValidMovesUpRight(fromFile: file, andRank: rank, ofColor: color))
        validMoves.append(contentsOf: ChessBoard.getValidMovesDownLeft(fromFile: file, andRank: rank, ofColor: color))
        // second diagonal
        validMoves.append(contentsOf: ChessBoard.getValidMovesUpLeft(fromFile: file, andRank: rank, ofColor: color))
        validMoves.append(contentsOf: ChessBoard.getValidMovesDownRight(fromFile: file, andRank: rank, ofColor: color))

        return validMoves
    }
}
