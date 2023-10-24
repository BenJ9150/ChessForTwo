//
//  ExtensionsTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 21/10/2023.
//

import XCTest
@testable import ChessForTwo

final class ExtensionsTestCase: XCTestCase {

    // MARK: - Rotation of view

    func testGivenThereIsAView_WhenRotateOf180_ThenRotationIs180() {
        let view = UIView()

        view.rotation = 180

        XCTAssertEqual(view.rotation, 0) // value not getted
    }

    func testGivenThereIsAViewWithConstraint_WhenChangeMultiplier_ThenMultiplierIsEqualTo2() {
        let view = UIView()
        let otherView = UIView()
        let superView = UIView()
        superView.addSubview(view)
        superView.addSubview(otherView)
        var constraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal,
                                            toItem: otherView, attribute: .width,
                                            multiplier: 1.0, constant: 0.0)

        constraint = constraint.setMultiplier(2, andRefresh: UIView())

        XCTAssertEqual(constraint.multiplier, 2)
    }

    // MARK: - get piece image

    func testGivenGetImageOfWhitePawn_WhenCheckResult_ThenIsNotNil() {
        let piece = Pawn(initialFile: 1, initialRank: 1, color: .white)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfWhiteRook_WhenCheckResult_ThenIsNotNil() {
        let piece = Rook(initialFile: 1, initialRank: 1, color: .white)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfWhiteKnight_WhenCheckResult_ThenIsNotNil() {
        let piece = Knight(initialFile: 1, initialRank: 1, color: .white)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfWhiteBishop_WhenCheckResult_ThenIsNotNil() {
        let piece = Bishop(initialFile: 1, initialRank: 1, color: .white)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfWhiteQueen_WhenCheckResult_ThenIsNotNil() {
        let piece = Queen(initialFile: 1, initialRank: 1, color: .white)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfWhiteKing_WhenCheckResult_ThenIsNotNil() {
        let piece = King(initialFile: 1, initialRank: 1, color: .white)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfBlackPawn_WhenCheckResult_ThenIsNotNil() {
        let piece = Pawn(initialFile: 1, initialRank: 1, color: .black)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfBlackRook_WhenCheckResult_ThenIsNotNil() {
        let piece = Rook(initialFile: 1, initialRank: 1, color: .black)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfBlackKnight_WhenCheckResult_ThenIsNotNil() {
        let piece = Knight(initialFile: 1, initialRank: 1, color: .black)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfBlackBishop_WhenCheckResult_ThenIsNotNil() {
        let piece = Bishop(initialFile: 1, initialRank: 1, color: .black)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfBlackQueen_WhenCheckResult_ThenIsNotNil() {
        let piece = Queen(initialFile: 1, initialRank: 1, color: .black)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }

    func testGivenGetImageOfBlackKing_WhenCheckResult_ThenIsNotNil() {
        let piece = King(initialFile: 1, initialRank: 1, color: .black)
        let pieceImage = UIImageView.getPieceImageView(piece: piece)

        XCTAssertNotNil(pieceImage)
    }
}
