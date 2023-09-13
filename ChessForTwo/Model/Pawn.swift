//
//  Pawn.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Pawn {

    // MARK: - Public properties

    var currentFile: Int {
        return file
    }

    var currentRank: Int {
        return rank
    }

    // MARK: - Private properties

    private let initialFile: Int
    private let initialRank: Int
    private var file: Int
    private var rank: Int
    private let color: PieceColor

    private var isAtInitialPosition: Bool {
        return initialFile == file && initialRank == rank
    }

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor) {
        self.initialFile = initialFile
        self.initialRank = initialRank
        self.file = initialFile
        self.rank = initialRank
        self.color = color
    }
}

// MARK: - Public methods

extension Pawn {

    func setNewPosition(atFile newFile: Int, andRank newRank: Int, withCapture capture: Bool) -> Bool {
        // if out of chessboard, return false
        if ChessBoard.isOutOfChessBoard(file: newFile, rank: newRank) { return false }

        if capture {
            // capture, just diagonal move
            if !validDiagonalMove(newFile: newFile, newRank: newRank) { return false }
        } else {
            // no capture, just vertical move
            if !validVerticalMove(newFile: newFile, newRank: newRank) { return false }
        }

        // valid move
        file = newFile
        rank = newRank
        return true
    }
}

// MARK: - Private methods

extension Pawn {

    private func validVerticalMove(newFile: Int, newRank: Int) -> Bool {
        if newFile != file { return false }

        switch color {
        case .white:
            if isAtInitialPosition && newRank == rank + 2 { return true }
            return newRank == rank + 1
        case .black:
            if isAtInitialPosition && newRank == rank - 2 { return true }
            return newRank == rank - 1
        }
    }

    private func validDiagonalMove(newFile: Int, newRank: Int) -> Bool {
        let validFile = newFile == file + 1 || newFile == file - 1

        switch color {
        case .white:
            return validFile && newRank == rank + 1
        case .black:
            return validFile && newRank == rank - 1
        }
    }
}
