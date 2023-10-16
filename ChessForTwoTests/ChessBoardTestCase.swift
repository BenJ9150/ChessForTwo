//
//  ChessBoardTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 16/09/2023.
//

import XCTest
@testable import ChessForTwo

final class ChessBoardTestCase: XCTestCase {

    // MARK: - Setup

    override func setUp() {
        super.setUp()
        ChessBoard.initChessBoard()
    }

    // MARK: - Convert position

    func testGivenPositionIs7x6_WhenCheckingPosInInt_ThenPosInIntIs46() {
        XCTAssertEqual(ChessBoard.posToInt(file: 7, rank: 6), 46)
    }

    func testGivenPositionIs0_WhenCheckingIntToPos_ThenPosIs1x1() {
        let position = ChessBoard.intToSquare(0)

        XCTAssertEqual(position.file, 1)
        XCTAssertEqual(position.rank, 1)
    }

    func testGivenPositionIs46_WhenCheckingIntToPos_ThenPosIs7x6() {
        let position = ChessBoard.intToSquare(46)

        XCTAssertEqual(position.file, 7)
        XCTAssertEqual(position.rank, 6)
    }

    // MARK: - Rotation of view

    func testGivenThereIsAView_WhenRotateOf180_ThenRotationIs180() {
        let view = UIView()

        view.rotation = 180

        XCTAssertEqual(view.rotation, 0) // value not getted
    }

    func testGivenThereIsAUIImage_WhenRotateOf180_ThenReturnNotNilWithSameName() {
        let imageView = UIImageView(image: UIImage(named: "ic_whitePawn"))

        imageView.image = ChessBoard.rotatePiece(image: imageView.image)
        let imageName = imageView.image?.imageAsset?.value(forKey: UIImage.imageNameKey) as? String

        XCTAssertNotNil(imageView.image)
        XCTAssertEqual(imageName!, "ic_whitePawn")
    }

    // MARK: - Pieces

    func testGivenGetPieceAt1x3_WhenCheckingResult_ThenIsNil() {
        let piece = ChessBoard.piece(atPosition: Square(file: 1, rank: 3))

        XCTAssertNil(piece)
    }

    func testGivenColorIsNilWhenGameInPause_WhenGettingPieceAt1x1_ThenIsNil() {
        let piece = ChessBoard.piece(atPosition: Square(file: 1, rank: 1), ofColor: nil)

        XCTAssertNil(piece)
    }

    func testGivenDeletePieceAt1x2_WhenGettingPieceAt1x2_ThenIsNil() {
        let piece = ChessBoard.piece(atPosition: Square(file: 1, rank: 2))
        XCTAssertNotNil(piece)
        ChessBoard.remove(piece)

        let oldPiece = ChessBoard.piece(atPosition: Square(file: 1, rank: 2))

        XCTAssertNil(oldPiece)
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

        let toN = ChessBoard.emptySquaresBetween(pawn, and: pieceN)
        let toS = ChessBoard.emptySquaresBetween(pawn, and: pieceS)
        let toE = ChessBoard.emptySquaresBetween(pawn, and: pieceE)
        let toW = ChessBoard.emptySquaresBetween(pawn, and: pieceW)
        let toNE = ChessBoard.emptySquaresBetween(pawn, and: pieceNE)
        let toNW = ChessBoard.emptySquaresBetween(pawn, and: pieceNW)
        let toSE = ChessBoard.emptySquaresBetween(pawn, and: pieceSE)
        let toSW = ChessBoard.emptySquaresBetween(pawn, and: pieceSW)

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

        let emptySquares = ChessBoard.emptySquaresBetween(pawn, and: knight)

        XCTAssertTrue(knight is Knight)
        XCTAssertEqual(emptySquares.count, 0)
    }

    func testGivenPawnInCenter_WhenCheckingNotStraightDirection_ThenCountIs0() {
        let pawn = Pawn(initialFile: 5, initialRank: 4, color: .white)
        ChessBoard.add(pawn)
        let piece = ChessBoard.piece(atPosition: Square(file: 6, rank: 7))!

        let emptySquares = ChessBoard.emptySquaresBetween(pawn, and: piece)

        XCTAssertEqual(emptySquares.count, 0)
    }
}
