//
//  RookTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class RookTestCase: XCTestCase {

    // MARK: - Valid move

    func testGivenRookIsAt1x1_WhenMovingAt7x1_ThenPosIs7x1AndIsValidMove() {
        let rook = Rook(initialFile: 1, initialRank: 1, color: .white)

        let valid = rook.setNewPosition(atFile: 7, andRank: 1)

        XCTAssertEqual(rook.currentFile, 7)
        XCTAssertEqual(rook.currentRank, 1)
        XCTAssertTrue(valid)
    }

    func testGivenRookIsAt7x6_WhenMovingAt7x1_ThenIsValidMove() {
        let rook = Rook(initialFile: 7, initialRank: 6, color: .white)

        let valid = rook.setNewPosition(atFile: 7, andRank: 1)

        XCTAssertTrue(valid)
    }
}
