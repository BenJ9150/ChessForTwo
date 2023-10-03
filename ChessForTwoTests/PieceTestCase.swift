//
//  PieceTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 03/10/2023.
//

import XCTest
@testable import ChessForTwo

final class PieceTestCase: XCTestCase {

    func testGivenPiece_WhenCheckingInitialWhitePos_ThenResultIs0x0() {
        XCTAssertEqual(Piece.initialWhitePos[0].0, 0)
        XCTAssertEqual(Piece.initialWhitePos[0].1, 0)
    }

    func testGivenCreatePiece_WhenMoveTo1x2_ThenIsNotValidMove() {
        let piece = Piece(initialFile: 1, initialRank: 1, color: .white)

        let move = piece.setNewPosition(atFile: 1, andRank: 2)

        XCTAssertFalse(move)
    }
}
