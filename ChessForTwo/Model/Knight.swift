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

    var currentFile: Int {
        return file
    }

    var currentRank: Int {
        return rank
    }

    // initial positions : file, white rank
    static let initialWhitePos = [(2, 1), (7, 1)]

    // MARK: - Private properties

    private var file: Int
    private var rank: Int

    private var possibleMoves: [(file: Int, rank: Int)] {
        return [(currentFile - 2, currentRank - 1), (currentFile - 2, currentRank + 1),
                (currentFile - 1, currentRank - 2), (currentFile - 1, currentRank + 2),
                (currentFile + 1, currentRank - 2), (currentFile + 1, currentRank + 2),
                (currentFile + 2, currentRank - 1), (currentFile + 2, currentRank + 1)]
    }

    // MARK: - Init

    init(initialFile: Int, initialRank: Int, color: PieceColor) {
        self.file = initialFile
        self.rank = initialRank
        self.color = color
    }

    convenience init() {
        self.init(initialFile: 0, initialRank: 0, color: .white)
    }
}

// MARK: - Public methods

extension Knight {

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

extension Knight {

    private func validMove(newFile: Int, newRank: Int) -> Bool {
        for (file, rank) in possibleMoves where newFile == file && newRank == rank {
            return true
        }
        return false
    }
}
