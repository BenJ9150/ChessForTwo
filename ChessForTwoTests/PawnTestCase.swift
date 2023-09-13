//
//  PawnTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class PawnTestCase: XCTestCase {

    // MARK: - Starting position

    func testGivenBlackPawnJustInitAt1x7_WhenMoveTo1x6_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 7, color: .black)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 6, withCapture: false)

        XCTAssertTrue(valid)
    }

    func testGivenWhitePawnJustInitAt1x2_WhenMoveTo1x5_ThenPosIs1x2AndIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 5, withCapture: false)

        XCTAssertEqual(pawn.currentFile, 1)
        XCTAssertEqual(pawn.currentRank, 2)
        XCTAssertFalse(valid)
    }

    // MARK: - Capture

    func testGivenWhitePawnIsAt1x2_WhenMoveTo2x3WithCapture_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 2, andRank: 3, withCapture: true)

        XCTAssertTrue(valid)
    }

    func testGivenBlackPawnIsAt2x7_WhenMoveTo1x6WithCapture_ThenIsValidMove() {
        let pawn = Pawn(initialFile: 2, initialRank: 7, color: .black)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 6, withCapture: true)

        XCTAssertTrue(valid)
    }

    /*
        func testGivenWhitePawnJustInitAt1x2_WhenMoveTo1x4_ThenPosIs1x4AndIsValidMove() {
            let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

            let valid = pawn.setNewPosition(atFile: 1, andRank: 4, withCapture: false)

            XCTAssertEqual(pawn.currentFile, 1)
            XCTAssertEqual(pawn.currentRank, 4)
            XCTAssertTrue(valid)
        }
    */
    /*
        // MARK: - Out of chess board

        func testGivenWhitePawnIsAt1x8_WhenMoveTo1x9_ThenIsNotValidMove() {
            let pawn = Pawn(initialFile: 1, initialRank: 8, color: .white)

            let valid = pawn.setNewPosition(atFile: 1, andRank: 9, withCapture: false)

            XCTAssertFalse(valid)
        }
    */
/*
    func testGivenWhitePawnIsAt1x2_WhenMoveTo1x3WithCapture_ThenIsNotValidMove() {
        let pawn = Pawn(initialFile: 1, initialRank: 2, color: .white)

        let valid = pawn.setNewPosition(atFile: 1, andRank: 3, withCapture: true)

        XCTAssertFalse(valid)
    }*/
}
