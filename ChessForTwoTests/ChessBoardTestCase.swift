//
//  ChessBoardTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 16/09/2023.
//

import XCTest
@testable import ChessForTwo

final class ChessBoardTestCase: XCTestCase {

    let queen = Queen(initialFile: 5, initialRank: 4, color: .white)

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        ChessBoard.initChessBoard()
    }

    // MARK: - Vertical white moves

    func testGivenPositionIs5x4ForWhite_WhenGoingUp_ThenValidPositionsCountIs3() {
        let validMoves = ChessBoard.getValidMovesUp(fromFile: 5, andRank: 4, ofColor: .white)

        XCTAssertEqual(validMoves.count, 3)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingDown_ThenValidPositionsCountIs1() {
        let validMoves = ChessBoard.getValidMovesDown(fromFile: 5, andRank: 4, ofColor: .white)

        XCTAssertEqual(validMoves.count, 1)
    }

    // MARK: - Horizontal white moves

    func testGivenPositionIs5x4ForWhite_WhenGoingLeft_ThenValidPositionsCountIs4() {
        let validMoves = ChessBoard.getValidMovesLeft(fromFile: 5, andRank: 4, ofColor: .white)

        XCTAssertEqual(validMoves.count, 4)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingRight_ThenValidPositionsCountIs1() {
        let validMoves = ChessBoard.getValidMovesRight(fromFile: 5, andRank: 4, ofColor: .white)

        XCTAssertEqual(validMoves.count, 3)
    }

    // MARK: - Diagonal white moves

    func testGivenPositionIs5x4ForWhite_WhenGoingUpLeft_ThenValidPositionsCountIs3() {
        let validMoves = ChessBoard.getValidMovesUpLeft(fromFile: 5, andRank: 4, ofColor: .white)

        XCTAssertEqual(validMoves.count, 3)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingUpRight_ThenValidPositionsCountIs3() {
        let validMoves = ChessBoard.getValidMovesUpRight(fromFile: 5, andRank: 4, ofColor: .white)

        XCTAssertEqual(validMoves.count, 3)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingDownLeft_ThenValidPositionsCountIs1() {
        let validMoves = ChessBoard.getValidMovesDownLeft(fromFile: 5, andRank: 4, ofColor: .white)

        XCTAssertEqual(validMoves.count, 1)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingDownRight_ThenValidPositionsCountIs1() {
        let validMoves = ChessBoard.getValidMovesDownRight(fromFile: 5, andRank: 4, ofColor: .white)

        XCTAssertEqual(validMoves.count, 1)
    }

    // MARK: - Vertical black moves

    func testGivenPositionIs4x5ForBlack_WhenGoingUp_ThenValidPositionsCountIs1() {
        let validMoves = ChessBoard.getValidMovesUp(fromFile: 4, andRank: 5, ofColor: .black)

        XCTAssertEqual(validMoves.count, 1)
    }

    func testGivenPositionIs4x5ForBlack_WhenGoingDown_ThenValidPositionsCountIs3() {
        let validMoves = ChessBoard.getValidMovesDown(fromFile: 4, andRank: 5, ofColor: .black)

        XCTAssertEqual(validMoves.count, 3)
    }

    // MARK: - Horizontal black moves

    func testGivenPositionIs5x2ForBlack_WhenGoingLeft_ThenValidPositionsCountIs1() {
        let validMoves = ChessBoard.getValidMovesLeft(fromFile: 5, andRank: 2, ofColor: .black)

        XCTAssertEqual(validMoves.count, 1)
    }

    func testGivenPositionIs5x2ForBlack_WhenGoingRight_ThenValidPositionsCountIs1() {
        let validMoves = ChessBoard.getValidMovesRight(fromFile: 5, andRank: 2, ofColor: .black)

        XCTAssertEqual(validMoves.count, 1)
    }

    // MARK: - Diagonal black moves

    func testGivenPositionIs4x5ForBlack_WhenGoingUpLeft_ThenValidPositionsCountIs1() {
        let validMoves = ChessBoard.getValidMovesUpLeft(fromFile: 4, andRank: 5, ofColor: .black)

        XCTAssertEqual(validMoves.count, 1)
    }

    func testGivenPositionIs6x4ForBlack_WhenGoingUpRight_ThenValidPositionsCountIs2() {
        let validMoves = ChessBoard.getValidMovesUpRight(fromFile: 6, andRank: 4, ofColor: .black)

        XCTAssertEqual(validMoves.count, 2)
    }

    func testGivenPositionIs4x5ForBlack_WhenGoingDownLeft_ThenValidPositionsCountIs3() {
        let validMoves = ChessBoard.getValidMovesDownLeft(fromFile: 4, andRank: 5, ofColor: .black)

        XCTAssertEqual(validMoves.count, 3)
    }

    func testGivenPositionIs4x5ForBlack_WhenGoingDownRight_ThenValidPositionsCountIs3() {
        let validMoves = ChessBoard.getValidMovesDownRight(fromFile: 4, andRank: 5, ofColor: .black)

        XCTAssertEqual(validMoves.count, 3)
    }

    // MARK: - Convert position

    func testGivenPositionIs7x6_WhenCheckingPosInInt_ThenPosInIntIs46() {
        XCTAssertEqual(ChessBoard.posToInt(file: 7, rank: 6), 46)
    }

    func testGivenPositionIs0_WhenCheckingIntToPos_ThenPosIs1x1() {
        let position = ChessBoard.intToPos(0)

        XCTAssertEqual(position.file, 1)
        XCTAssertEqual(position.rank, 1)
    }

    func testGivenPositionIs46_WhenCheckingIntToPos_ThenPosIs7x6() {
        let position = ChessBoard.intToPos(46)

        XCTAssertEqual(position.file, 7)
        XCTAssertEqual(position.rank, 6)
    }
}
