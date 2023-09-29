//
//  KnightTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class KnightTestCase: XCTestCase {

    // MARK: - Valid move

    func testGivenKnightIsAt4x5_WhenMovingAt5x7_ThenIsValidMove() {
        let knight = Knight(initialFile: 4, initialRank: 5, color: .white)

        let valid = knight.setNewPosition(atFile: 5, andRank: 7)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenKnightIsAt3x1_WhenMovingAt4x4_ThenIsNotValidMove() {
        let knight = Knight(initialFile: 3, initialRank: 1, color: .white)

        let valid = knight.setNewPosition(atFile: 4, andRank: 4)

        XCTAssertFalse(valid)
    }
}
