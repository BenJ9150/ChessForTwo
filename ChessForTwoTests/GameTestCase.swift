//
//  GameTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 13/09/2023.
//

import XCTest
@testable import ChessForTwo

final class GameTestCase: XCTestCase {

    // MARK: - Private properties

    private var game = Game(playerOne: "player1", playerTwo: "player2")

    private let sqA7 = (1, 7)
    private let sqA6 = (1, 6)
    private let sqA5 = (1, 5)

    private let sqB2 = (2, 2)
    private let sqB4 = (2, 4)
    private let sqB5 = (2, 5)

    private let sqD2 = (4, 2)
    private let sqD4 = (4, 4)
    private let sqD5 = (4, 5)

    private let sqE2 = (5, 2)
    private let sqE4 = (5, 4)
    private let sqE5 = (5, 5)
    private let sqE7 = (5, 7)

    private let sqKg1 = (7, 1)
    private let sqKf3 = (6, 3)
    private let sqKb8 = (2, 8)
    private let sqKc6 = (3, 6)

    private let sqQd1 = (4, 1)
    private let sqQd3 = (4, 3)
    private let sqQd6 = (4, 6)
    private let sqQh3 = (8, 3)
    private let sqQh5 = (8, 5)

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        game = Game(playerOne: "player1", playerTwo: "player2")
        game.start()
    }

    // MARK: - Private methods

    private func movePiece(from: (file: Int, rank: Int), to end: (file: Int, rank: Int)) -> Bool {
        // coordinates
        let startingPos = ChessBoard.posToInt(file: from.file, rank: from.rank)
        let endingPos = ChessBoard.posToInt(file: end.file, rank: end.rank)
        return game.movePiece(fromInt: startingPos, toInt: endingPos)
    }

    private func scottishOpening() -> Bool {
        _ = movePiece(from: sqE2, to: sqE4) // e4
        _ = movePiece(from: sqE7, to: sqE5) // e5
        _ = movePiece(from: sqKg1, to: sqKf3) // Kf3
        _ = movePiece(from: sqKb8, to: sqKc6) // Kf6
        _ = movePiece(from: sqD2, to: sqD4) // d4
        return movePiece(from: sqE5, to: sqD4) // exd4
    }

    // MARK: - Start and pause

    func testGivenStartNewGame_WhenCheckingState_ThenIsStartedAndScoreIs0To0AndWhiteToPlay() {
        XCTAssertEqual(game.score(ofPlayer: .one), 0)
        XCTAssertEqual(game.score(ofPlayer: .two), 0)
        XCTAssertEqual(game.state, .isStarted)
        XCTAssertEqual(game.currentColor, .white)
    }

    func testGivenGameIsInPause_WhenMoveE4_ThenIsNotValidMoveAndGameIsInPauseAndCurrentColorIsNil() {
        game.pause()

        let move = movePiece(from: sqE2, to: sqE4)

        XCTAssertFalse(move)
        XCTAssertEqual(game.state, .inPause)
        XCTAssertNil(game.currentColor)
    }

    func testGivenGameIsInPause_WhenUnpause_ThenGameIsStartedAndWhiteToPlay() {
        game.pause()

        game.unpause()

        XCTAssertEqual(game.state, .isStarted)
        XCTAssertEqual(game.currentColor, .white)
    }

    // MARK: - Scores and is over

    func testGivenPlayerOneHasWon_WhenMoveE4_ThenScoresAre1To0AndGameIsOverAndCurrentColorIsNil() {
        game.incrementScore(forPlayer: .one)

        let move = movePiece(from: sqE2, to: sqE4)

        XCTAssertFalse(move)
        XCTAssertEqual(game.score(ofPlayer: .one), 1)
        XCTAssertEqual(game.score(ofPlayer: .two), 0)
        XCTAssertEqual(game.state, .isOver)
        XCTAssertNil(game.currentColor)
    }

    // MARK: - Valid move

    func testGivenScottishOpeningIsDone_WhenCheckingCapture_ThenOpeningIsValidWithOneCapturedPawnInD4() {
        let opening = scottishOpening()

        let capturedPiece = game.capturedPieces[0]

        XCTAssertTrue(opening)
        XCTAssertEqual(game.capturedPieces.count, 1)
        XCTAssertTrue(capturedPiece is Pawn)
        XCTAssertEqual(capturedPiece.currentFile, 4)
        XCTAssertEqual(capturedPiece.currentRank, 4)
    }

    // MARK: - Capture in passing

    func testGivenWhitePawnAtB5_WhenMoveA5AndCaptureInA6_ThenIsValidMove() {
        _ = movePiece(from: sqB2, to: sqB4)
        _ = movePiece(from: sqE7, to: sqE5)
        _ = movePiece(from: sqB4, to: sqB5)

        _ = movePiece(from: sqA7, to: sqA5)
        let capture = movePiece(from: sqB5, to: sqA6)

        XCTAssertTrue(capture)
    }

    // MARK: - Not valid move

    func testGivenStartNewGame_WhenMoveD2toD5_ThenIsNotValidMoveAndWhiteToPlay() {
        let move = movePiece(from: sqD2, to: sqD5)

        XCTAssertFalse(move)
        XCTAssertEqual(game.currentColor, .white)
    }

    func testGivenStartNewGame_WhenMoveD5_ThenIsNotValidMove() {
        let move = movePiece(from: sqD4, to: sqD5)

        XCTAssertFalse(move)
    }

    func testGivenStartNewGame_WhenMoveBlackPawn_ThenIsNotValidMove() {
        let move = movePiece(from: sqE7, to: sqE5)

        XCTAssertFalse(move)
    }
}
