//
//  Rook.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Rook: Piece {

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
    static let initialWhitePos = [(1, 1), (8, 1)]

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

extension Rook {

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool {
        let validMoves = getAllValidMoves()
        if !validMoves.contains(Square(file: newFile, rank: newRank)) { return false }

        // valid move
        file = newFile
        rank = newRank
        firstMove = false

        // update total moves count
        ChessBoard.movesCount += 1
        return true
    }

    func getAllValidMoves() -> [Square] {
        var validMoves: [Square] = []

        // vertical
        validMoves.append(contentsOf: ChessBoard.getValidMovesUp(fromFile: file, andRank: rank, ofColor: color))
        validMoves.append(contentsOf: ChessBoard.getValidMovesDown(fromFile: file, andRank: rank, ofColor: color))
        // horizontal
        validMoves.append(contentsOf: ChessBoard.getValidMovesLeft(fromFile: file, andRank: rank, ofColor: color))
        validMoves.append(contentsOf: ChessBoard.getValidMovesRight(fromFile: file, andRank: rank, ofColor: color))

        return validMoves
    }
}
