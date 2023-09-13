//
//  Queen.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

final class Queen {

    // MARK: - Public properties

    var currentFile: Int {
        return file
    }

    var currentRank: Int {
        return rank
    }

    // MARK: - Private properties

    private var file: Int
    private var rank: Int
    private let color: PieceColor

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor) {
        self.file = initialFile
        self.rank = initialRank
        self.color = color
    }
}

// MARK: - Public methods

extension Queen {

    func setNewPosition(atFile newFile: Int, andRank newRank: Int) -> Bool {
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

extension Queen {

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
        if fileDiff == 0 || rankDiff == 0 { return true }

        // check diagonal
        return fileDiff == rankDiff
    }
}
