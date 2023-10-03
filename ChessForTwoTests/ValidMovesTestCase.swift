//
//  ValidMovesTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 02/10/2023.
//

import XCTest
@testable import ChessForTwo

final class ValidMovesTestCase: XCTestCase {

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        ChessBoard.initChessBoard()
    }
/*
    // MARK: - Vertical white moves

    func testGivenPositionIs5x4ForWhite_WhenGoingUp_ThenValidPositionsCountIs3() {
        let validMoves = ValidMoves.validUp(file: 5, rank: 4, color: .white)

        XCTAssertEqual(validMoves.count, 3)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingDown_ThenValidPositionsCountIs1() {
        let validMoves = ValidMoves.validDown(file: 5, rank: 4, color: .white)

        XCTAssertEqual(validMoves.count, 1)
    }

    // MARK: - Horizontal white moves

    func testGivenPositionIs5x4ForWhite_WhenGoingLeft_ThenValidPositionsCountIs4() {
        let validMoves = ValidMoves.validLeft(file: 5, rank: 4, color: .white)

        XCTAssertEqual(validMoves.count, 4)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingRight_ThenValidPositionsCountIs1() {
        let validMoves = ValidMoves.validRight(file: 5, rank: 4, color: .white)

        XCTAssertEqual(validMoves.count, 3)
    }

    // MARK: - Diagonal white moves

    func testGivenPositionIs5x4ForWhite_WhenGoingUpLeft_ThenValidPositionsCountIs3() {
        let validMoves = ValidMoves.validUpLeft(file: 5, rank: 4, color: .white)

        XCTAssertEqual(validMoves.count, 3)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingUpRight_ThenValidPositionsCountIs3() {
        let validMoves = ValidMoves.validUpRight(file: 5, rank: 4, color: .white)

        XCTAssertEqual(validMoves.count, 3)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingDownLeft_ThenValidPositionsCountIs1() {
        let validMoves = ValidMoves.validDownLeft(file: 5, rank: 4, color: .white)

        XCTAssertEqual(validMoves.count, 1)
    }

    func testGivenPositionIs5x4ForWhite_WhenGoingDownRight_ThenValidPositionsCountIs1() {
        let validMoves = ValidMoves.validDownRight(file: 5, rank: 4, color: .white)

        XCTAssertEqual(validMoves.count, 1)
    }

    // MARK: - Vertical black moves

    func testGivenPositionIs4x5ForBlack_WhenGoingUp_ThenValidPositionsCountIs1() {
        let validMoves = ValidMoves.validUp(file: 4, rank: 5, color: .black)

        XCTAssertEqual(validMoves.count, 1)
    }

    func testGivenPositionIs4x5ForBlack_WhenGoingDown_ThenValidPositionsCountIs3() {
        let validMoves = ValidMoves.validDown(file: 4, rank: 5, color: .black)

        XCTAssertEqual(validMoves.count, 3)
    }

    // MARK: - Horizontal black moves

    func testGivenPositionIs5x2ForBlack_WhenGoingLeft_ThenValidPositionsCountIs1() {
        let validMoves = ValidMoves.validLeft(file: 5, rank: 2, color: .black)

        XCTAssertEqual(validMoves.count, 1)
    }

    func testGivenPositionIs5x2ForBlack_WhenGoingRight_ThenValidPositionsCountIs1() {
        let validMoves = ValidMoves.validRight(file: 5, rank: 2, color: .black)

        XCTAssertEqual(validMoves.count, 1)
    }

    // MARK: - Diagonal black moves

    func testGivenPositionIs4x5ForBlack_WhenGoingUpLeft_ThenValidPositionsCountIs1() {
        let validMoves = ValidMoves.validUpLeft(file: 4, rank: 5, color: .black)

        XCTAssertEqual(validMoves.count, 1)
    }

    func testGivenPositionIs6x4ForBlack_WhenGoingUpRight_ThenValidPositionsCountIs2() {
        let validMoves = ValidMoves.validUpRight(file: 6, rank: 4, color: .black)

        XCTAssertEqual(validMoves.count, 2)
    }

    func testGivenPositionIs4x5ForBlack_WhenGoingDownLeft_ThenValidPositionsCountIs3() {
        let validMoves = ValidMoves.validDownLeft(file: 4, rank: 5, color: .black)

        XCTAssertEqual(validMoves.count, 3)
    }

    func testGivenPositionIs4x5ForBlack_WhenGoingDownRight_ThenValidPositionsCountIs3() {
        let validMoves = ValidMoves.validDownRight(file: 4, rank: 5, color: .black)

        XCTAssertEqual(validMoves.count, 3)
    }
*/
    // MARK: - Empty square

    func testGivenPawnInCenter_WhenCheckingAllDirections_ThenCountsAreGood() {
        let centerPawn = Pawn(initialFile: 5, initialRank: 4, color: .white)
        ChessBoard.add(centerPawn)
        let pawnE = Pawn(initialFile: 8, initialRank: 4, color: .white)
        ChessBoard.add(pawnE)
        let pawnW = Pawn(initialFile: 1, initialRank: 4, color: .white)
        ChessBoard.add(pawnW)

        let pawn = ChessBoard.piece(atPosition: Square(file: 5, rank: 4))!
        let pieceN = ChessBoard.piece(atPosition: Square(file: 5, rank: 7))!
        let pieceS = ChessBoard.piece(atPosition: Square(file: 5, rank: 2))!
        let pieceE = ChessBoard.piece(atPosition: Square(file: 8, rank: 4))!
        let pieceW = ChessBoard.piece(atPosition: Square(file: 1, rank: 4))!
        let pieceNE = ChessBoard.piece(atPosition: Square(file: 8, rank: 7))!
        let pieceNW = ChessBoard.piece(atPosition: Square(file: 2, rank: 7))!
        let pieceSE = ChessBoard.piece(atPosition: Square(file: 7, rank: 2))!
        let pieceSW = ChessBoard.piece(atPosition: Square(file: 3, rank: 2))!

        let toN = ValidMoves.emptySquaresBetween(pawn, and: pieceN)
        let toS = ValidMoves.emptySquaresBetween(pawn, and: pieceS)
        let toE = ValidMoves.emptySquaresBetween(pawn, and: pieceE)
        let toW = ValidMoves.emptySquaresBetween(pawn, and: pieceW)
        let toNE = ValidMoves.emptySquaresBetween(pawn, and: pieceNE)
        let toNW = ValidMoves.emptySquaresBetween(pawn, and: pieceNW)
        let toSE = ValidMoves.emptySquaresBetween(pawn, and: pieceSE)
        let toSW = ValidMoves.emptySquaresBetween(pawn, and: pieceSW)

        XCTAssertEqual(toN.count, 3) // capture is counted (different color)
        XCTAssertEqual(toS.count, 1)
        XCTAssertEqual(toE.count, 2)
        XCTAssertEqual(toW.count, 3)
        XCTAssertEqual(toNE.count, 3) // capture is counted (different color)
        XCTAssertEqual(toNW.count, 3) // capture is counted (different color)
        XCTAssertEqual(toSE.count, 1)
        XCTAssertEqual(toSW.count, 1)
    }

    func testGivenPawnInCenter_WhenCheckingSquaresWithKnight_ThenCountIs0() {
        let pawn = Pawn(initialFile: 5, initialRank: 4, color: .white)
        ChessBoard.add(pawn)
        let knight = ChessBoard.piece(atPosition: Square(file: 2, rank: 8))!

        let emptySquares = ValidMoves.emptySquaresBetween(pawn, and: knight)

        XCTAssertTrue(knight is Knight)
        XCTAssertEqual(emptySquares.count, 0)
    }

    func testGivenPawnInCenter_WhenCheckingNotStraightDirection_ThenCountIs0() {
        let pawn = Pawn(initialFile: 5, initialRank: 4, color: .white)
        ChessBoard.add(pawn)
        let piece = ChessBoard.piece(atPosition: Square(file: 6, rank: 7))!

        let emptySquares = ValidMoves.emptySquaresBetween(pawn, and: piece)

        XCTAssertEqual(emptySquares.count, 0)
    }
}
