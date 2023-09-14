//
//  BishopTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class BishopTestCase: XCTestCase {

    // MARK: - Same position

    func testGivenBishopIsAt1x2_WhenMoveTo1x2_ThenIsNotValidMove() {
        let bishop = Bishop(initialFile: 1, initialRank: 2, color: .white)

        let valid = bishop.setNewPosition(atFile: 1, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Out of chess board

    func testGivenBishopIsAt1x2_WhenMoveTo1x9_ThenIsNotValidMove() {
        let bishop = Bishop(initialFile: 1, initialRank: 2, color: .white)

        let valid = bishop.setNewPosition(atFile: 1, andRank: 9, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Valid move

    func testGivenBishopIsAt2x1_WhenMovingAt7x6_ThenPosIs7x6AndIsValidMove() {
        let bishop = Bishop(initialFile: 2, initialRank: 1, color: .white)

        let valid = bishop.setNewPosition(atFile: 7, andRank: 6, capture: false)

        XCTAssertEqual(bishop.currentFile, 7)
        XCTAssertEqual(bishop.currentRank, 6)
        XCTAssertTrue(valid)
    }

    func testGivenBishopIsAt7x6_WhenMovingAt2x1_ThenIsValidMove() {
        let bishop = Bishop(initialFile: 7, initialRank: 6, color: .white)

        let valid = bishop.setNewPosition(atFile: 2, andRank: 1, capture: false)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenBishopIsAt7x6_WhenMovingAt2x2_ThenIsNotValidMove() {
        let bishop = Bishop(initialFile: 7, initialRank: 6, color: .white)

        let valid = bishop.setNewPosition(atFile: 2, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    func testGivenBishopIsAt7x6_WhenMovingAt2x6_ThenIsNotValidMove() {
        let bishop = Bishop(initialFile: 7, initialRank: 6, color: .white)

        let valid = bishop.setNewPosition(atFile: 2, andRank: 6, capture: false)

        XCTAssertFalse(valid)
    }
}
