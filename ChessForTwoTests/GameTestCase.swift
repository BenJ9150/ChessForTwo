//
//  GameTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 13/09/2023.
//

import XCTest
@testable import ChessForTwo

final class GameTestCase: XCTestCase {

    private let player1 = "player1"
    private let player2 = "player2"

    // MARK: - Scores

    func testGivenStartNewGame_WhenPlayerOneHasWon_ThenScoresAre1To0() {
        let game = Game(playerOne: player1, playerTwo: player2)

        game.incrementScore(forPlayer: .one)

        XCTAssertEqual(game.score(ofPlayer: .one), 1)
        XCTAssertEqual(game.score(ofPlayer: .two), 0)
    }

    // MARK: - Restart

    func testGivenGameIsLaunched_WhenRestart_ThenScoresAre0To0AndNamesDontChange() {
        let game = Game(playerOne: player1, playerTwo: player2)
        game.incrementScore(forPlayer: .one)
        game.incrementScore(forPlayer: .two)

        game.restart()

        XCTAssertEqual(game.score(ofPlayer: .one), 0)
        XCTAssertEqual(game.score(ofPlayer: .two), 0)
        XCTAssertEqual(game.names[.one], player1)
        XCTAssertEqual(game.names[.two], player2)
    }

    // MARK: - Pieces on chess board

    func testGivenStartNewGame_WhenCheckingAt1x2_ThenThereIsPawn() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let piece = game.piece(atFile: 1, andRank: 2)

        XCTAssertTrue(piece is Pawn)
    }

    func testGivenStartNewGame_WhenCheckingAt1x1_ThenThereIsRook() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let piece = game.piece(atFile: 1, andRank: 1)

        XCTAssertTrue(piece is Rook)
    }

    func testGivenStartNewGame_WhenCheckingAt2x1_ThenThereIsKnight() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let piece = game.piece(atFile: 2, andRank: 1)

        XCTAssertTrue(piece is Knight)
    }

    func testGivenStartNewGame_WhenCheckingAt3x1_ThenThereIsBishop() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let piece = game.piece(atFile: 3, andRank: 1)

        XCTAssertTrue(piece is Bishop)
    }

    func testGivenStartNewGame_WhenCheckingAt4x1_ThenThereIsQueen() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let piece = game.piece(atFile: 4, andRank: 1)

        XCTAssertTrue(piece is Queen)
    }

    func testGivenStartNewGame_WhenCheckingAt5x1_ThenThereIsKing() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let piece = game.piece(atFile: 5, andRank: 1)

        XCTAssertTrue(piece is King)
    }

    // MARK: - Not valid move

    func testGivenStartNewGame_WhenMove1x2To1x5_ThenIsNotValidMove() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let move = game.movePiece(from: (1, 2), toPos: (1, 5))

        XCTAssertFalse(move)
    }

    func testGivenStartNewGame_WhenMove1x3To1x4_ThenIsNotValidMove() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let move = game.movePiece(from: (1, 3), toPos: (1, 4))

        XCTAssertFalse(move)
    }

    // MARK: - Capture

    func testGivenE4D5_WhenCaptureE5_ThenThereIsWhitePawnAtE5AndOneCapturedPiece() {
        let game = Game(playerOne: player1, playerTwo: player2)
        _ = game.movePiece(from: (5, 2), toPos: (5, 4))
        _ = game.movePiece(from: (4, 7), toPos: (4, 5))
        _ = game.movePiece(from: (5, 4), toPos: (4, 5))

        let piece = game.piece(atFile: 4, andRank: 5)

        XCTAssertTrue(piece is Pawn)
        XCTAssertEqual(piece?.color, .white)
        XCTAssertEqual(game.board.count, 31)
        XCTAssertEqual(game.capturedPieces.count, 1)
    }

    func testGivenE4E5Kc3Kf6_WhenKe4_ThenIsNotValidMove() {
        let game = Game(playerOne: player1, playerTwo: player2)
        let move1 = game.movePiece(from: (5, 2), toPos: (5, 4))
        let move2 = game.movePiece(from: (5, 7), toPos: (5, 5))
        let move3 = game.movePiece(from: (2, 1), toPos: (3, 3))
        let move4 = game.movePiece(from: (7, 8), toPos: (6, 6))

        let move5 = game.movePiece(from: (3, 3), toPos: (5, 4))

        XCTAssertTrue(move1)
        XCTAssertTrue(move2)
        XCTAssertTrue(move3)
        XCTAssertTrue(move4)
        XCTAssertFalse(move5)
    }

    // MARK: - Capture with not valid move

    func testGivenE4E5_WhenE5_ThenIsNotValidMove() {
        let game = Game(playerOne: player1, playerTwo: player2)
        let move1 = game.movePiece(from: (5, 2), toPos: (5, 4))
        let move2 = game.movePiece(from: (5, 7), toPos: (5, 5))

        let move3 = game.movePiece(from: (5, 4), toPos: (5, 5))

        XCTAssertTrue(move1)
        XCTAssertTrue(move2)
        XCTAssertFalse(move3)
    }

    // MARK: Move piece with Int

    func testGivenStartNewGame_WhenMove0To16_ThenIsValidMove() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let move = game.movePiece(fromInt: 0, toInt: 16)

        XCTAssertTrue(move)
    }

    func testGivenStartNewGame_WhenMove7To63_ThenIsValidMove() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let move = game.movePiece(fromInt: 7, toInt: 63)

        XCTAssertTrue(move)
    }

    func testGivenStartNewGame_WhenMoveLess1To16_ThenIsNotValidMove() {
        let game = Game(playerOne: player1, playerTwo: player2)

        let move = game.movePiece(fromInt: -1, toInt: 16)

        XCTAssertFalse(move)
    }
}
