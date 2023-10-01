//
//  PawnTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class PawnTestCase: XCTestCase {

    private func initPieceAndAddToCB<T: Pieces>(_: T, file: Int, rank: Int, withColor color: PieceColor) -> T {
        // init piece
        let piece = T(initialFile: file, initialRank: rank, color: color)
        // add to chessboard
        ChessBoard.add(piece: piece, atPosition: Square(file: file, rank: rank))
        return piece
    }

    private func moveAndUpdateChessBoard(piece: Pieces, atFile newFile: Int, andRank newRank: Int) -> Bool {
        // move piece
        let move = piece.setNewPosition(atFile: newFile, andRank: newRank)
        // update chessboard
        ChessBoard.moveAfterSetPosition(piece: piece)
        return move
    }

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        ChessBoard.initChessBoard()
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

    // MARK: - Capture in passing

    func testGivenBlackIsAt1x7WhiteIsAt2x5_WhenMoveTo1x5AndTo1x6_ThenAreValidMoves() {
        let blackPawn = initPieceAndAddToCB(Pawn(), file: 1, rank: 7, withColor: .black)
        let whitePawn = initPieceAndAddToCB(Pawn(), file: 2, rank: 5, withColor: .white)

        let blackMove = moveAndUpdateChessBoard(piece: blackPawn, atFile: 1, andRank: 5)
        let whiteMove = moveAndUpdateChessBoard(piece: whitePawn, atFile: 1, andRank: 6)

        XCTAssertTrue(blackMove)
        XCTAssertTrue(whiteMove)
    }

    func testGivenBlackIsAt1x7WhiteIsAt2x5_WhenMoveTo1x5AndOtherMovesAndTo1x6_ThenFinalMoveNotValid() {
        let blackPawn1 = initPieceAndAddToCB(Pawn(), file: 1, rank: 7, withColor: .black)
        let whitePawn1 = initPieceAndAddToCB(Pawn(), file: 2, rank: 5, withColor: .white)
        let blackPawn2 = initPieceAndAddToCB(Pawn(), file: 8, rank: 7, withColor: .black)
        let whitePawn2 = initPieceAndAddToCB(Pawn(), file: 8, rank: 2, withColor: .white)

        _ = moveAndUpdateChessBoard(piece: blackPawn1, atFile: 1, andRank: 5)
        let whiteMove1 = moveAndUpdateChessBoard(piece: whitePawn2, atFile: 8, andRank: 4)
        let blackMove2 = moveAndUpdateChessBoard(piece: blackPawn2, atFile: 8, andRank: 6)
        let whiteMove2 = moveAndUpdateChessBoard(piece: whitePawn1, atFile: 1, andRank: 6)

        XCTAssertTrue(whiteMove1)
        XCTAssertTrue(blackMove2)
        XCTAssertFalse(whiteMove2)
    }
}
