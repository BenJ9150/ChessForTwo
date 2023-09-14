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

    var currentFile: Int {
        return file
    }

    var currentRank: Int {
        return rank
    }

    // initial positions : file, white rank, black rank
    static let initialPos = [(3, 1, 8), (6, 1, 8)]

    // MARK: - Private properties

    private var file: Int
    private var rank: Int

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor) {
        self.file = initialFile
        self.rank = initialRank
        self.color = color
    }
}

// MARK: - Public methods

extension Bishop {

    func setNewPosition(atFile newFile: Int, andRank newRank: Int, capture: Bool) -> Bool {
        // same position
        if newFile == file && newRank == rank { return false }

        // out of chessboard
        if ChessBoard.isOutOfChessBoard(file: newFile, rank: newRank) { return false }

        // check move validity
        if !validMove(newFile: newFile, newRank: newRank) { return false }

        // valid move
        file = newFile
        rank = newRank
        return true
    }
}

// MARK: - Private methods

extension Bishop {

    private func validMove(newFile: Int, newRank: Int) -> Bool {
        // file difference
        let fileDiff: Int
        if newFile > file {
            fileDiff = newFile - file
        } else {
            fileDiff = file - newFile
        }

        // rank difference
        let rankDiff: Int
        if newRank > rank {
            rankDiff = newRank - rank
        } else {
            rankDiff = rank - newRank
        }

        // check horizontal
        if fileDiff == 0 || rankDiff == 0 { return false }

        // check diagonal
        return fileDiff == rankDiff
    }
}
