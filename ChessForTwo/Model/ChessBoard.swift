//
//  ChessBoard.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

struct ChessBoard: Hashable {

    // MARK: - Public properties

    var file: Int
    var rank: Int
    static let maxPosition = 8

    // MARK: - Private properties

    private static let minPosition = 1
    private static let startingRank = [0, 8, 16, 24, 32, 40, 48, 56]
}

// MARK: - Public methods

extension ChessBoard {

    static func isOutOfChessBoard(file: Int, rank: Int) -> Bool {
        return file < minPosition || file > maxPosition || rank < minPosition || rank > maxPosition
    }

    static func posToInt(file: Int, rank: Int) -> Int {
        return file - 1 + (rank - 1) * maxPosition
    }

    static func intToPos(_ int: Int) -> (file: Int, rank: Int) {
        if int == 0 { return (1, 1) }
        // get rank
        let rank: Int
        if let optRank = ChessBoard.startingRank.firstIndex(where: { $0 > int }) {
            rank = optRank
        } else {
            // up to 56
            rank = 8
        }
        // get file
        let file = int - (rank - 1) * maxPosition + 1
        return (file, rank)
    }
}
