//
//  Piece.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 13/09/2023.
//

import Foundation

enum PieceColor {
    case white
    case black
}

protocol Piece {

    // MARK: - Public properties

    var color: PieceColor { get }
    var currentFile: Int { get }
    var currentRank: Int { get }
    var oldFile: Int { get }
    var oldRank: Int { get }
    var hasNotMoved: Bool { get }
    var movingTwoSquaresAtMove: Int? { get } // just for pawn and capture in passing
    static var initialWhitePos: [(Int, Int)] { get }

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor)

    // MARK: - Public methods

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool
    func getAllValidMoves() -> [Square]
}

class Pieces: Piece {

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

    var oldFile: Int {
        return lastFile
    }

    var oldRank: Int {
        return lastRank
    }

    var hasNotMoved: Bool {
        return firstMove
    }

    // initial positions : file, white rank
    class var initialWhitePos: [(Int, Int)] {
        return [(0, 0)]
    }

    // MARK: - Private properties

    private var movingTwoSqAtMove: Int?
    private var file: Int
    private var rank: Int
    private var lastFile: Int
    private var lastRank: Int
    private var firstMove: Bool

    // MARK: - Init

    required init(initialFile: Int, initialRank: Int, color: PieceColor) {
        self.file = initialFile
        self.rank = initialRank
        self.lastFile = initialFile
        self.lastRank = initialRank
        self.color = color
        self.movingTwoSqAtMove = nil
        self.firstMove = true
    }

    convenience init() {
        self.init(initialFile: 0, initialRank: 0, color: .white)
    }

    // MARK: - Public methods

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool {
        let validMoves = getAllValidMoves() + getOtherMoves()
        if !validMoves.contains(Square(file: newFile, rank: newRank)) { return false }

        // valid move, check if move of 2 squares
        if abs(rank - newRank) == 2 {
            movingTwoSqAtMove = ChessBoard.movesCount + 1 // +1 for this new move
        } else {
            movingTwoSqAtMove = nil
        }

        // update positions and move possibility
        lastFile = file
        lastRank = rank
        file = newFile
        rank = newRank
        firstMove = false

        // update total moves count
        ChessBoard.movesCount += 1
        return true
    }

    // MARK: - Public methods to override

    func getAllValidMoves() -> [Square] {
        let validMoves: [Square] = []
        return validMoves
    }

    func getOtherMoves() -> [Square] {
        let validMoves: [Square] = []
        return validMoves
    }
}
