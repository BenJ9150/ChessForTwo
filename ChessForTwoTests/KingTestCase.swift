//
//  KingTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class KingTestCase: XCTestCase {

    var whiteKing = King()
    var blackKing = King()
    var whiteRookH1 = Rook()
    var blackRookA8 = Rook()

    private func initPieceAndAddToCB<T: Piece>(_: T, file: Int, rank: Int, withColor color: PieceColor) -> T {
        // init piece
        let piece = T(initialFile: file, initialRank: rank, color: color)
        // add to chessboard
        ChessBoard.add(piece: piece, atPosition: Square(file: file, rank: rank))
        return piece
    }

    private func moveAndUpdateChessBoard(piece: Piece, atFile newFile: Int, andRank newRank: Int) -> Bool {
        let startFile = piece.currentFile
        let startRank = piece.currentRank
        // move piece
        let move = piece.setNewPosition(atFile: newFile, andRank: newRank)
        // update chessboard
        ChessBoard.move(piece: piece, fromPosition: Square(file: startFile, rank: startRank),
                        toPosition: Square(file: newFile, rank: newRank))
        ChessBoard.movesCount += 1
        return move
    }

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        ChessBoard.removeAllPieces()
        whiteKing = initPieceAndAddToCB(King(), file: 5, rank: 1, withColor: .white)
        blackKing = initPieceAndAddToCB(King(), file: 5, rank: 8, withColor: .black)
        whiteRookH1 = initPieceAndAddToCB(Rook(), file: 8, rank: 1, withColor: .white)
        blackRookA8 = initPieceAndAddToCB(Rook(), file: 1, rank: 8, withColor: .black)
    }

    // MARK: - Valid move
/*
    func testGivenKingIsAt7x6_WhenMovingAt6x5_ThenIsValidMove() {
        let king = King(initialFile: 7, initialRank: 6, color: .white)

        let valid = king.setNewPosition(atFile: 6, andRank: 5)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenKingIsAt7x6_WhenMovingAt7x8_ThenIsNotValidMove() {
        let king = King(initialFile: 7, initialRank: 6, color: .white)

        let valid = king.setNewPosition(atFile: 7, andRank: 8)

        XCTAssertFalse(valid)
    }*/

    // MARK: - Little Castling

    func testGivenKingAndRookNotMoved_WhenLittleCastling_ThenCastlingIsValid() {
        let castling = moveAndUpdateChessBoard(piece: whiteKing, atFile: 7, andRank: 1)

        XCTAssertTrue(castling)
    }

    func testGivenKingHasMoved_WhenLittleCastling_ThenCastlingIsNotValid() {
        let move1 = moveAndUpdateChessBoard(piece: whiteKing, atFile: 5, andRank: 2)
        let move2 = moveAndUpdateChessBoard(piece: whiteKing, atFile: 5, andRank: 1) // initial pos

        let castling = moveAndUpdateChessBoard(piece: whiteKing, atFile: 7, andRank: 1)

        XCTAssertTrue(move1)
        XCTAssertTrue(move2)
        XCTAssertFalse(castling)
    }

    func testGivenKingAndRookNotMoved_WhenBigCastling_ThenCastlingIsValid() {
        let castling = moveAndUpdateChessBoard(piece: blackKing, atFile: 3, andRank: 8)

        XCTAssertTrue(castling)
    }

    // MARK: - Big Castling

    // Roque impossible :

    // le roi a bougé, roque impossible
    // le roi est attaqué, roque impossible
    // la tour a1 a bougé, grand roque blanc impossible
    // la tour a8 a bougé, petit roque blanc impossible
    // une pièce est en f1 ou g1, petit roque blanc impossible
    // une pièce est en b1, c1 ou d1, grand roque blanc impossible
    // une pièce attaque la case c1 ou d1, grand roque impossible
    // une pièce attaque la case f1 ou g1, petit roque impossible

    // Petit roque blanc possible :
    // le roi n'est pas attaqué
    // + ni le roi ni la tour h1 n'a bougé
    // + aucune pièce en f1 et g1
    // + les cases f1 et g1 ne sont pas attaquées

    // Grand roque blanc possible :
    // le roi n'est pas attaqué
    // + ni le roi ni la tour a1 n'a bougé
    // + aucune pièce en b1, c1 et d1
    // + les cases c1 et d1 ne sont pas attaquées
}
