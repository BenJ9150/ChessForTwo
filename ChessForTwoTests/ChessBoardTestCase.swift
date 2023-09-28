//
//  ChessBoardTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 16/09/2023.
//

import XCTest
@testable import ChessForTwo

final class ChessBoardTestCase: XCTestCase {

    func testGivenPositionIs7x6_WhenCheckingPosInInt_ThenPosInIntIs46() {
        XCTAssertEqual(ChessBoard.posToInt(file: 7, rank: 6), 46)
    }

    func testGivenPositionIs0_WhenCheckingIntToPos_ThenPosIs1x1() {
        let position = ChessBoard.intToPos(0)

        XCTAssertEqual(position.file, 1)
        XCTAssertEqual(position.rank, 1)
    }

    func testGivenPositionIs46_WhenCheckingIntToPos_ThenPosIs7x6() {
        let position = ChessBoard.intToPos(46)

        XCTAssertEqual(position.file, 7)
        XCTAssertEqual(position.rank, 6)
    }
}
