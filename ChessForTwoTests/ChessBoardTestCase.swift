//
//  ChessBoardTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class ChessBoardTestCase: XCTestCase {

    func testGivenPieceIsAt4x6_WhenCheckingPosition_ThenIsOnTheBoard() {
        let outOfBoard = ChessBoard.isOutOfChessBoard(file: 4, rank: 6)

        XCTAssertFalse(outOfBoard)
    }

    func testGivenPieceIsAt9_WhenCheckingPosition_ThenIsOutOfTheBoard() {
        let outOfBoard = ChessBoard.isOutOfChessBoard(position: 9)

        XCTAssertTrue(outOfBoard)
    }
}
