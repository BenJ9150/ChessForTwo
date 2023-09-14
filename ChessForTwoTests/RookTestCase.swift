//
//  RookTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class RookTestCase: XCTestCase {

    // MARK: - Same position

    func testGivenRookIsAt1x2_WhenMoveTo1x2_ThenIsNotValidMove() {
        let rook = Rook(initialFile: 1, initialRank: 2, color: .white)

        let valid = rook.setNewPosition(atFile: 1, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Out of chess board

    func testGivenRookIsAt1x2_WhenMoveTo9x2_ThenIsNotValidMove() {
        let rook = Rook(initialFile: 1, initialRank: 2, color: .white)

        let valid = rook.setNewPosition(atFile: 9, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Valid move

    func testGivenRookIsAt1x1_WhenMovingAt7x1_ThenPosIs7x1AndIsValidMove() {
        let rook = Rook(initialFile: 1, initialRank: 1, color: .white)

        let valid = rook.setNewPosition(atFile: 7, andRank: 1, capture: false)

        XCTAssertEqual(rook.currentFile, 7)
        XCTAssertEqual(rook.currentRank, 1)
        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenRookIsAt1x1_WhenMovingAt7x2_ThenIsNotValidMove() {
        let rook = Rook(initialFile: 1, initialRank: 1, color: .white)

        let valid = rook.setNewPosition(atFile: 7, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }
}
