//
//  KnightTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class KnightTestCase: XCTestCase {

    // MARK: - Same position

    func testGivenKnightIsAt1x2_WhenMoveTo1x2_ThenIsNotValidMove() {
        let knight = Knight(initialFile: 1, initialRank: 2, color: .white)

        let valid = knight.setNewPosition(atFile: 1, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Out of chess board

    func testGivenKnightIsAt1x2_WhenMoveTo9x2_ThenIsNotValidMove() {
        let knight = Knight(initialFile: 1, initialRank: 2, color: .white)

        let valid = knight.setNewPosition(atFile: 9, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Valid move

    func testGivenKnightIsAt3x1_WhenMovingAt4x3_ThenPosIs4x3AndIsValidMove() {
        let knight = Knight(initialFile: 3, initialRank: 1, color: .white)

        let valid = knight.setNewPosition(atFile: 4, andRank: 3, capture: false)

        XCTAssertEqual(knight.currentFile, 4)
        XCTAssertEqual(knight.currentRank, 3)
        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenKnightIsAt3x1_WhenMovingAt4x4_ThenIsNotValidMove() {
        let knight = Knight(initialFile: 3, initialRank: 1, color: .white)

        let valid = knight.setNewPosition(atFile: 4, andRank: 4, capture: false)

        XCTAssertFalse(valid)
    }
}
