//
//  KingTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class KingTestCase: XCTestCase {

    // MARK: - Valid move

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
