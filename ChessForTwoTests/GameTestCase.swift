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
    private var movesResult = true

    private let sqA1 = (1, 1), sqA2 = (1, 2), sqA3 = (1, 3), sqA5 = (1, 5), sqA6 = (1, 6), sqA7 = (1, 7), sqA8 = (1, 8)
    private let sqB1 = (2, 1), sqB2 = (2, 2), sqB4 = (2, 4), sqB5 = (2, 5), sqB6 = (2, 6), sqB8 = (2, 8)
    private let sqC2 = (3, 2), sqC3 = (3, 3), sqC4 = (3, 4), sqC6 = (3, 6), sqC7 = (3, 7)
    private let sqD1 = (4, 1), sqD2 = (4, 2), sqD3 = (4, 3), sqD4 = (4, 4)
    private let sqD5 = (4, 5), sqD6 = (4, 6), sqD7 = (4, 7), sqD8 = (4, 8)
    private let sqE2 = (5, 2), sqE4 = (5, 4), sqE5 = (5, 5), sqE6 = (5, 6), sqE7 = (5, 7), sqE8 = (5, 8)
    private let sqF1 = (6, 1), sqF2 = (6, 2), sqF3 = (6, 3), sqF6 = (6, 6), sqF7 = (6, 7), sqF8 = (6, 8)
    private let sqG1 = (7, 1), sqG2 = (7, 2), sqG4 = (7, 4), sqG5 = (7, 5), sqG6 = (7, 6), sqG7 = (7, 7), sqG8 = (7, 8)
    private let sqH3 = (8, 3), sqH4 = (8, 4), sqH5 = (8, 5)

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        movesResult = true
        game = Game(playerOne: "player1", playerTwo: "player2")
        game.start()
    }

    // MARK: - Private methods

    private func initPieceAndAddToCB<T: Pieces>(_: T, at pos: (file: Int, rank: Int), withColor color: PieceColor) {
        // init piece
        let piece = T(initialFile: pos.file, initialRank: pos.rank, color: color)
        // add to chessboard
        ChessBoard.add(piece)
    }

    private func movePiece(from: (file: Int, rank: Int), to end: (file: Int, rank: Int)) {
        // coordinates
        let startingPos = ChessBoard.posToInt(file: from.file, rank: from.rank)
        let endingPos = ChessBoard.posToInt(file: end.file, rank: end.rank)
        let move = game.movePiece(fromInt: startingPos, toInt: endingPos)
        if !move {
            movesResult = false
        }
    }

    private func scottishOpening() {
        movePiece(from: sqE2, to: sqE4) // e4
        movePiece(from: sqE7, to: sqE5) // e5
        movePiece(from: sqG1, to: sqF3) // Nf3
        movePiece(from: sqB8, to: sqC6) // Nc6
        movePiece(from: sqD2, to: sqD4) // d4
    }

    private func scandinavianOpening() {
        movePiece(from: sqE2, to: sqE4) // e4
        movePiece(from: sqD7, to: sqD5) // d5
        movePiece(from: sqE4, to: sqD5) // exd5
        movePiece(from: sqD8, to: sqD5) // Qxd5
        movePiece(from: sqB1, to: sqC3) // Nc3
        movePiece(from: sqD5, to: sqA5) // Qa5
        movePiece(from: sqB2, to: sqB4) // b4
        movePiece(from: sqA5, to: sqB4) // Qxb4
        movePiece(from: sqC3, to: sqB5) // Nb5
        movePiece(from: sqB4, to: sqA5) // Qa5
        movePiece(from: sqF1, to: sqC4) // Bc4
        movePiece(from: sqC7, to: sqC6) // c6
        movePiece(from: sqC4, to: sqF7) // Bxf7
        movePiece(from: sqE8, to: sqF7) // Kxf7
    }

    // MARK: - Valid move

    func testGivenScottishOpeningIsDone_WhenExD4_ThenOpeningIsValidWithOneCapturedPawnInD4() {
        scottishOpening()

        movePiece(from: sqE5, to: sqD4) // exd4

        let capturedPiece = ChessBoard.allCapturedPieces().first!
        XCTAssertTrue(movesResult)
        XCTAssertEqual(ChessBoard.allCapturedPieces().count, 1)
        XCTAssertTrue(capturedPiece is Pawn)
        XCTAssertEqual(capturedPiece.currentFile, 4)
        XCTAssertEqual(capturedPiece.currentRank, 4)
    }

    // MARK: - Capture in passing

    func testGivenWhitePawnAtB5_WhenMoveA5AndCaptureInA6_ThenA5IsEmptyAndIsValidMove() {
        movePiece(from: sqB2, to: sqB4)
        movePiece(from: sqE7, to: sqE5)
        movePiece(from: sqB4, to: sqB5)

        movePiece(from: sqA7, to: sqA5)
        movePiece(from: sqB5, to: sqA6)

        XCTAssertTrue(ChessBoard.isEmpty(atPosition: Square(file: 1, rank: 5)))
        XCTAssertTrue(movesResult)
    }

    // MARK: - Not valid move

    func testGivenStartNewGame_WhenMoveD2toD5_ThenIsNotValidMoveAndWhiteToPlay() {
        movePiece(from: sqD2, to: sqD5)

        XCTAssertFalse(movesResult)
        XCTAssertEqual(game.currentColor, .white)
    }

    func testGivenStartNewGame_WhenMoveD5_ThenIsNotValidMove() {
        movePiece(from: sqD4, to: sqD5)

        XCTAssertFalse(movesResult)
    }

    func testGivenStartNewGame_WhenMoveBlackPawn_ThenIsNotValidMove() {
        movePiece(from: sqE7, to: sqE5)

        XCTAssertFalse(movesResult)
    }

    // MARK: - Check

    func testGivenScandinavianDefense_WhenQh5checkAndg6ToAvoidCheck_gameIsStartedAndWhiteToPlay() {
        scandinavianOpening()

        movePiece(from: sqD1, to: sqH5) // Qh5 check
        movePiece(from: sqG7, to: sqG6) // g6

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.currentColor, .white)
        XCTAssertEqual(game.state, .isStarted)
    }

    func testGivenScottishOpeningAndBishopAtB4_WhenA3_ThenIsNotValidMoveAndA3IsEmpty() {
        scottishOpening()
        movePiece(from: sqF8, to: sqB4)

        movePiece(from: sqA2, to: sqA3)

        XCTAssertFalse(movesResult)
        XCTAssertTrue(ChessBoard.isEmpty(atPosition: Square(file: 1, rank: 3)))
    }

    func testGivenBlackKingIsCheck_WhenE7_ThenIsValidMove() {
        movePiece(from: sqE2, to: sqE4) // e4
        movePiece(from: sqE7, to: sqE5) // e5
        movePiece(from: sqD1, to: sqG4) // Qg4
        movePiece(from: sqA7, to: sqA6) // a6
        movePiece(from: sqG4, to: sqE6) // Qe6

        movePiece(from: sqG8, to: sqE7) // Ne7

        XCTAssertTrue(movesResult)
    }

    func testGivenBlackKingCantMove_WhenIsCheck_ThenCaptureOpponentPieceToSaveCheckmate() {
        movePiece(from: sqB1, to: sqC3) // Nc3
        movePiece(from: sqC7, to: sqC6) // c6
        movePiece(from: sqE2, to: sqE4) // e4
        movePiece(from: sqG8, to: sqF6) // Nf6
        movePiece(from: sqD1, to: sqG4) // Qg4
        movePiece(from: sqF6, to: sqE4) // Nxe4
        movePiece(from: sqC3, to: sqE4) // Nxe4
        movePiece(from: sqA7, to: sqA6) // a6
        movePiece(from: sqE4, to: sqD6) // Nd6 check

        movePiece(from: sqE7, to: sqD6) // exd6

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.state, .isStarted)
    }

    func testGivenBlackKingIsCheck_WhenMoving_ThenIsNotCheckmate() {
        ChessBoard.removeAllPieces()
        initPieceAndAddToCB(King(), at: sqA8, withColor: .black)
        initPieceAndAddToCB(Rook(), at: sqB1, withColor: .white)
        movePiece(from: sqB1, to: sqA1)

        movePiece(from: sqA8, to: sqB8)

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.state, .isStarted)
    }

    // MARK: - Checkmate

    func testGivenBarnesOpening_WhenQueenH4_ThenBlackWin2PointsGameIsOverAndCurrentColorIsNil() {
        movePiece(from: sqF2, to: sqF3) // f3
        movePiece(from: sqE7, to: sqE5) // e5
        movePiece(from: sqG2, to: sqG4) // g4

        movePiece(from: sqD8, to: sqH4) // Qh4#

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.score(ofPlayer: .two), 2)
        XCTAssertEqual(game.score(ofPlayer: .one), 0)
        XCTAssertEqual(game.state, .isOver)
        XCTAssertNil(game.currentColor)
    }

    func testGivenPlayerOneHasBlack_WhenBackRankMate_ThenBlackWin2Points() {
        ChessBoard.removeAllPieces()
        game.whoPlayWithWhite = .two

        initPieceAndAddToCB(King(), at: sqA8, withColor: .white)
        initPieceAndAddToCB(Rook(), at: sqB1, withColor: .black)
        initPieceAndAddToCB(Rook(), at: sqC2, withColor: .black)
        movePiece(from: sqA8, to: sqA7) // Ka7
        movePiece(from: sqC2, to: sqA2) // Ra2#

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.score(ofPlayer: .two), 0)
        XCTAssertEqual(game.score(ofPlayer: .one), 2)
    }

    func testGivenBlackKingCantMove_WhenIsCheck_ThenGameIsOver() {
        movePiece(from: sqB1, to: sqC3) // Nc3
        movePiece(from: sqC7, to: sqC6) // c6
        movePiece(from: sqE2, to: sqE4) // e4
        movePiece(from: sqG8, to: sqF6) // Nf6
        movePiece(from: sqD1, to: sqE2) // Qe2
        movePiece(from: sqF6, to: sqE4) // Nxe4
        movePiece(from: sqC3, to: sqE4) // Nxe4
        movePiece(from: sqA7, to: sqA6) // a6

        movePiece(from: sqE4, to: sqD6) // Nd6#

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.state, .isOver)
    }

    func testGivenBlackKingIsCheck_WhenQf7_ThenGameIsOver() {
        movePiece(from: sqE2, to: sqE4) // e4
        movePiece(from: sqE7, to: sqE5) // e5
        movePiece(from: sqD1, to: sqG4) // Qg4
        movePiece(from: sqA7, to: sqA6) // a6
        movePiece(from: sqG4, to: sqE6) // Qe6
        movePiece(from: sqG8, to: sqE7) // Ne7
        movePiece(from: sqF1, to: sqC4) // Bc4
        movePiece(from: sqA6, to: sqA5) // a5

        movePiece(from: sqE6, to: sqF7) // Qf7#

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.state, .isOver)
    }

    // MARK: - Draw per repetition

    func testGivenPosWasRepeated2times_WhenRepeat3rdTime_ThenIsDrawPlayersWin1GameIsOverAndColorIsNil() {
        movePiece(from: sqE2, to: sqE4) // e4
        movePiece(from: sqE7, to: sqE5) // e5 - first position
        movePiece(from: sqD1, to: sqE2) // Qe2
        movePiece(from: sqD8, to: sqE7) // Qe7
        movePiece(from: sqE2, to: sqD1) // Qd1
        movePiece(from: sqE7, to: sqD8) // Qd8 - 2 repeat
        movePiece(from: sqD1, to: sqG4) // Qg4
        movePiece(from: sqD8, to: sqG5) // Qg5
        movePiece(from: sqG4, to: sqD1) // Qd1

        movePiece(from: sqG5, to: sqD8) // Qd8 3 repeat

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.score(ofPlayer: .one), 1)
        XCTAssertEqual(game.score(ofPlayer: .two), 1)
        XCTAssertEqual(game.state, .isOver)
        XCTAssertNil(game.currentColor)
    }

    // MARK: - Stalemate

    func testGivenBlackCantMoveAndNoCheck_WhenCheckingGame_ThenIsDrawByStalemate() {
        ChessBoard.removeAllPieces()
        initPieceAndAddToCB(Pawn(), at: sqE4, withColor: .white)
        initPieceAndAddToCB(Pawn(), at: sqE5, withColor: .black)
        initPieceAndAddToCB(King(), at: sqA1, withColor: .white)
        initPieceAndAddToCB(King(), at: sqA8, withColor: .black)
        initPieceAndAddToCB(Queen(), at: sqB2, withColor: .white)
        movePiece(from: sqB2, to: sqB6)

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.score(ofPlayer: .one), 1)
        XCTAssertEqual(game.score(ofPlayer: .two), 1)
        XCTAssertEqual(game.state, .isOver)
        XCTAssertNil(game.currentColor)
    }

    // MARK: - Promotion

    func testGivenWhitePawnIsAtD7_WhenMoveToD8_ThenGameIsPauseAndColorNilForWaightPromotionChoice() {
        ChessBoard.removeAllPieces()
        initPieceAndAddToCB(Pawn(), at: sqD7, withColor: .white)

        movePiece(from: sqD7, to: sqD8) // d8, wait promotion

        XCTAssertTrue(movesResult)
        XCTAssertEqual(game.state, .inPause)
        XCTAssertNil(game.currentColor)
    }

    func testGivenWhiteChooseQueenPromotion_WhenCheckingPiece_ThenIsQueenGameIsStartedAndCurrentColorIsBlack() {
        ChessBoard.removeAllPieces()
        initPieceAndAddToCB(Pawn(), at: sqD7, withColor: .white)
        movePiece(from: sqD7, to: sqD8) // d8, wait promotion

        game.promotion(chosenPiece: Queen())

        XCTAssertTrue(ChessBoard.piece(atPosition: Square(file: 4, rank: 8)) is Queen)
        XCTAssertEqual(game.state, .isStarted)
        XCTAssertEqual(game.currentColor, .black)
    }
}
