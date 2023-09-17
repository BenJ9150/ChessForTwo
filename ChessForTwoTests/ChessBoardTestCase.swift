//
//  ChessBoardTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 16/09/2023.
//

import XCTest
@testable import ChessForTwo

final class ChessBoardTestCase: XCTestCase {

    func testGivenPositionIs7x6_WhenCheckingPosInInt_ThenPosInIntIs46() {
        XCTAssertEqual(ChessBoard.posToInt(file: 7, rank: 6), 46)
    }
}
