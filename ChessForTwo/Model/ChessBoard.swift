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

    // MARK: - Private properties

    private static let minPosition = 1
    private static let maxPosition = 8
}

// MARK: - Public methods

extension ChessBoard {

    static func isOutOfChessBoard(file: Int, rank: Int) -> Bool {
        return file < minPosition || file > maxPosition || rank < minPosition || rank > maxPosition
    }

    static func posToInt(file: Int, rank: Int) -> Int {
        return file - 1 + (rank - 1) * maxPosition
    }
}
