//
//  RookTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class RookTestCase: XCTestCase {

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        ChessBoard.removeAllPieces()
    }

    // MARK: - Valid move

    func testGivenRookIsAt1x1_WhenMovingAt7x1_ThenIsValidMove() {
        let rook = Rook(initialFile: 1, initialRank: 3, color: .white)

        let valid = rook.setNewPosition(atFile: 7, andRank: 3)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenRookIsAt1x1_WhenMovingAt7x2_ThenIsNotValidMove() {
        let rook = Rook(initialFile: 1, initialRank: 1, color: .white)

        let valid = rook.setNewPosition(atFile: 7, andRank: 2)

        XCTAssertFalse(valid)
    }
}
