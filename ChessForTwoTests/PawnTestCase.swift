//
//  PawnTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class PawnTestCase: XCTestCase {

    // MARK: - Valid move

    func testGivenWhitePawnIsAt1x2_WhenMoveTo1x4_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 4)

        XCTAssertTrue(valid)
    }

    func testGivenBlackPawnIsAt1x7_WhenMoveTo1x5_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 7, color: .black)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 5)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenWhitePawnIsAt1x2_WhenMoveTo1x5_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 5)

        XCTAssertFalse(valid)
    }

    func testGivenBlackPawnIsAt1x7_WhenMoveTo1x4_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 7, color: .black)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 4)

        XCTAssertFalse(valid)
    }

    func testGivenWhitePawnIsAt1x2_WhenMoveTo1x3AndTo1x5_ThenFirstMoveIsValidAndSecondIsNot() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let move1 = pawn.setNewPosition(atFile: 1, andRank: 3)
        let move2 = pawn.setNewPosition(atFile: 1, andRank: 5)

        XCTAssertTrue(move1)
        XCTAssertFalse(move2)
    }

    func testGivenBlackPawnIsAt1x7_WhenMoveTo1x6AndTo1x4_ThenFirstMoveIsValidAndSecondIsNot() {
        let pawn = Pawn(initialFile: 1, initialRank: 7, color: .black)

        let move1 = pawn.setNewPosition(atFile: 1, andRank: 6)
        let move2 = pawn.setNewPosition(atFile: 1, andRank: 4)

        XCTAssertTrue(move1)
        XCTAssertFalse(move2)
    }

    // MARK: - Valid capture

    func testGivenWhitePawnIsAt1x6_WhenMoveTo2x7_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 6, color: .white)

        let valid = pawn.setNewPosition(atFile: 2, andRank: 7)

        XCTAssertTrue(valid)
    }

    func testGivenWhitePawnIsAt8x6_WhenMoveTo7x7_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 8, initialRank: 6, color: .white)

        let valid = pawn.setNewPosition(atFile: 7, andRank: 7)

        XCTAssertTrue(valid)
    }

    func testGivenBlackPawnIsAt1x3_WhenMoveTo2x2_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 3, color: .black)

        let valid = pawn.setNewPosition(atFile: 2, andRank: 2)

        XCTAssertTrue(valid)
    }

    func testGivenBlackPawnIsAt8x3_WhenMoveTo7x2_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 8, initialRank: 3, color: .black)

        let valid = pawn.setNewPosition(atFile: 7, andRank: 2)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid capture

    func testGivenWhitePawnIsAt1x2_WhenMoveTo2x3_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 2, andRank: 3)

        XCTAssertFalse(valid)
    }

    func testGivenBlackPawnIsAt1x7_WhenMoveTo2x6_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 7, color: .black)

        let valid = pawn.setNewPosition(atFile: 2, andRank: 6)

        XCTAssertFalse(valid)
    }
}
