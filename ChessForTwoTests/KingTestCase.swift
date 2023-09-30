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

    // MARK: - Valid Castling

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

    // MARK: - Not valid Castling

    func testGivenPieceAtB8_WhenBlackBigCastling_ThenCastlingIsNotValid() {
        _ = initPieceAndAddToCB(Bishop(), file: 2, rank: 8, withColor: .black)

        let castling = moveAndUpdateChessBoard(piece: blackKing, atFile: 3, andRank: 8)

        XCTAssertFalse(castling)
    }

    func testGivenWhiteBishopAtG4_WhenBlackBigCastling_ThenCastlingIsNotValid() {
        _ = initPieceAndAddToCB(Bishop(), file: 7, rank: 4, withColor: .white)

        let castling = moveAndUpdateChessBoard(piece: blackKing, atFile: 3, andRank: 8)

        XCTAssertFalse(castling)
    }

    func testGivenWhiteQueenAtE3_WhenBlackBigCastling_ThenCastlingIsNotValid() {
        _ = initPieceAndAddToCB(Queen(), file: 5, rank: 3, withColor: .white)

        let castling = moveAndUpdateChessBoard(piece: blackKing, atFile: 3, andRank: 8)

        XCTAssertFalse(castling)
    }
}
