//
//  KingTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class KingTestCase: XCTestCase {

    // MARK: - Same position

    func testGivenKingIsAt1x2_WhenMoveTo1x2_ThenIsNotValidMove() {
        let king = King(initialFile: 1, initialRank: 2, color: .white)

        let valid = king.setNewPosition(atFile: 1, andRank: 2)

        XCTAssertFalse(valid)
    }

    // MARK: - Out of chess board

    func testGivenKingIsAt1x2_WhenMoveTo9x10_ThenIsNotValidMove() {
        let king = King(initialFile: 1, initialRank: 2, color: .white)

        let valid = king.setNewPosition(atFile: 9, andRank: 10)

        XCTAssertFalse(valid)
    }

    // MARK: - Valid move

    func testGivenKingIsAt3x4_WhenMovingAt4x5_ThenPosIs4x5AndIsValidMove() {
        let king = King(initialFile: 3, initialRank: 4, color: .white)

        let valid = king.setNewPosition(atFile: 4, andRank: 5)

        XCTAssertEqual(king.currentFile, 4)
        XCTAssertEqual(king.currentRank, 5)
        XCTAssertTrue(valid)
    }

    func testGivenKingIsAt7x6_WhenMovingAt6x5_ThenIsValidMove() {
        let king = King(initialFile: 7, initialRank: 6, color: .white)

        let valid = king.setNewPosition(atFile: 6, andRank: 5)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenKingIsAt7x6_WhenMovingAt7x8_ThenIsNotValidMove() {
        let king = King(initialFile: 7, initialRank: 6, color: .white)

        let valid = king.setNewPosition(atFile: 7, andRank: 8)

        XCTAssertFalse(valid)
    }
}
