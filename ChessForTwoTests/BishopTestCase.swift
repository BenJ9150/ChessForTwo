//
//  BishopTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class BishopTestCase: XCTestCase {

    // MARK: - Valid move

    func testGivenBishopIsAt7x6_WhenMovingAt4x3_ThenIsValidMove() {
        let bishop = Bishop(initialFile: 7, initialRank: 6, color: .white)

        let valid = bishop.setNewPosition(atFile: 4, andRank: 3)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenBishopIsAt7x6_WhenMovingAt2x2_ThenIsNotValidMove() {
        let bishop = Bishop(initialFile: 7, initialRank: 6, color: .white)

        let valid = bishop.setNewPosition(atFile: 2, andRank: 2)

        XCTAssertFalse(valid)
    }
}
