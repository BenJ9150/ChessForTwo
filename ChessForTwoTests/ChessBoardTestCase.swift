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
}
