//
//  QueenTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class QueenTestCase: XCTestCase {

    // MARK: - Valid move

    func testGivenQueenIsAt7x6_WhenMovingAt2x6_ThenIsValidMove() {
        let queen = Queen(initialFile: 7, initialRank: 6, color: .white)

        let valid = queen.setNewPosition(atFile: 2, andRank: 6)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenQueenIsAt7x6_WhenMovingAt2x2_ThenIsNotValidMove() {
        let queen = Queen(initialFile: 7, initialRank: 6, color: .white)

        let valid = queen.setNewPosition(atFile: 2, andRank: 2)

        XCTAssertFalse(valid)
    }
}
