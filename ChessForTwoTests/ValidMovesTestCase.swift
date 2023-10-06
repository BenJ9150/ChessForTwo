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
