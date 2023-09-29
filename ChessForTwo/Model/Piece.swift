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
    var hasNotMoved: Bool { get }
    var movingTwoSquaresAtMove: Int? { get } // just for pawn and capture in passing
    static var initialWhitePos: [(Int, Int)] { get }

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor)

    // MARK: - Public methods

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool
    func getAllValidMoves() -> [Square]
}
