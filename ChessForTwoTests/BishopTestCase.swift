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

    func testGivenBishopIsAt2x1_WhenMovingAt7x6_ThenPosIs7x6AndIsValidMove() {
        let bishop = Bishop(initialFile: 2, initialRank: 1, color: .white)

        let valid = bishop.setNewPosition(atFile: 7, andRank: 6)

        XCTAssertEqual(bishop.currentFile, 7)
        XCTAssertEqual(bishop.currentRank, 6)
        XCTAssertTrue(valid)
    }

    func testGivenBishopIsAt7x6_WhenMovingAt2x1_ThenIsValidMove() {
        let bishop = Bishop(initialFile: 7, initialRank: 6, color: .white)

        let valid = bishop.setNewPosition(atFile: 2, andRank: 1)

        XCTAssertTrue(valid)
    }

/*
    // MARK: - Not valid move

    func testGivenBishopIsAt2x1_WhenMovingAt4x4_ThenIsNotValidMove() {
        let bishop = Bishop(initialFile: 2, initialRank: 1, color: .white)

        let valid = bishop.setNewPosition(atFile: 4, andRank: 4)

        XCTAssertFalse(valid)
    }

    // MARK: - Out of chess board

    func testGivenBishopIsAt8x8_WhenMovingAt9x8_ThenIsNotValidMove() {
        let bishop = Bishop(initialFile: 8, initialRank: 8, color: .white)

        let valid = bishop.setNewPosition(atFile: 9, andRank: 8)

        XCTAssertFalse(valid)
    }*/
}
