//
//  QueenTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class QueenTestCase: XCTestCase {

    // MARK: - Same position

    func testGivenQueenIsAt1x2_WhenMoveTo1x2_ThenIsNotValidMove() {
        let queen = Queen(initialFile: 1, initialRank: 2, color: .white)

        let valid = queen.setNewPosition(atFile: 1, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Out of chess board

    func testGivenQueenIsAt1x2_WhenMoveToMinus1x2_ThenIsNotValidMove() {
        let queen = Queen(initialFile: 1, initialRank: 2, color: .white)

        let valid = queen.setNewPosition(atFile: -1, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Valid move

    func testGivenQueenIsAt3x4_WhenMovingAt5x6_ThenPosIs5x6AndIsValidMove() {
        let queen = Queen(initialFile: 3, initialRank: 4, color: .white)

        let valid = queen.setNewPosition(atFile: 5, andRank: 6, capture: false)

        XCTAssertEqual(queen.currentFile, 5)
        XCTAssertEqual(queen.currentRank, 6)
        XCTAssertTrue(valid)
    }

    func testGivenQueenIsAt7x6_WhenMovingAt2x1_ThenIsValidMove() {
        let queen = Queen(initialFile: 7, initialRank: 6, color: .white)

        let valid = queen.setNewPosition(atFile: 2, andRank: 1, capture: false)

        XCTAssertTrue(valid)
    }

    func testGivenQueenIsAt7x6_WhenMovingAt2x6_ThenIsValidMove() {
        let queen = Queen(initialFile: 7, initialRank: 6, color: .white)

        let valid = queen.setNewPosition(atFile: 2, andRank: 6, capture: false)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenQueenIsAt7x6_WhenMovingAt2x2_ThenIsNotValidMove() {
        let queen = Queen(initialFile: 7, initialRank: 6, color: .white)

        let valid = queen.setNewPosition(atFile: 2, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }
}
