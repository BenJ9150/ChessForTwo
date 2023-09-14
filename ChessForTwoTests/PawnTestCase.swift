//
//  PawnTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class PawnTestCase: XCTestCase {

    // MARK: - Same position

    func testGivenPawnIsAt1x2_WhenMoveTo1x2_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Out of chess board

    func testGivenPawnIsAt1x2_WhenMoveTo1x9_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 9, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Valid move

    func testGivenWhitePawnJustInitAt1x2_WhenMoveTo1x4_ThenPosIs1x4AndIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 4, capture: false)

        XCTAssertEqual(pawn.currentFile, 1)
        XCTAssertEqual(pawn.currentRank, 4)
        XCTAssertTrue(valid)
    }

    func testGivenBlackPawnJustInitAt1x7_WhenMoveTo1x5_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 7, color: .black)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 5, capture: false)

        XCTAssertTrue(valid)
    }

    func testGivenBlackPawnJustInitAt1x7_WhenMoveTo1x6_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 7, color: .black)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 6, capture: false)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenWhitePawnJustInitAt1x2_WhenMoveTo2x2_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 2, andRank: 2, capture: false)

        XCTAssertFalse(valid)
    }

    func testGivenWhitePawnJustInitAt1x2_WhenMoveTo1x5_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 5, capture: false)

        XCTAssertFalse(valid)
    }

    // MARK: - Valid capture

    func testGivenWhitePawnIsAt1x2_WhenMoveTo2x3WithCapture_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 2, andRank: 3, capture: true)

        XCTAssertTrue(valid)
    }

    func testGivenBlackPawnIsAt2x7_WhenMoveTo1x6WithCapture_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 2, initialRank: 7, color: .black)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 6, capture: true)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid capture

    func testGivenWhitePawnIsAt1x2_WhenMoveTo1x3WithCapture_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 3, capture: true)

        XCTAssertFalse(valid)
    }
}
