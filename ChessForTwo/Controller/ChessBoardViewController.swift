//
//  ChessBoardViewController.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 16/09/2023.
//

import UIKit

class ChessBoardViewController: UIViewController {

    // MARK: - Public properties

    static let nibName = "ChessBoardView"
    var viewOfColor: PieceColor?

    // MARK: - IBOutlet

    @IBOutlet var chessBoardView: ChessBoardView!
}

// MARK: - View did appear

extension ChessBoardViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initBoard() // in view did appear to have correct frames dimensions
    }
}

// MARK: - Public methods

extension ChessBoardViewController {

    func addPiece(_ image: UIImageView, atPosition position: Int) {
        chessBoardView.squaresView[position].addSubview(image)
    }

    func getLastAddedPiece(atPosition position: Int) -> UIImageView? {
        return chessBoardView.squaresView[position].subviews.last as? UIImageView
    }

    func removeFirstAddedPiece(atPosition position: Int) {
        if position < chessBoardView.squaresView.count {
            if chessBoardView.squaresView[position].subviews.count > 0 {
                // remove first view (last view may be the new piece)
                chessBoardView.squaresView[position].subviews[0].removeFromSuperview()
            }
        }
    }
}

// MARK: - Init board

extension ChessBoardViewController {

    private func initBoard() {
        chessBoardView.viewOfColor = viewOfColor // for notification of move

        // load piece
        for piece in ChessBoard.allPieces() {
            load(piece: piece, atSquare: ChessBoard.posToInt(file: piece.currentFile, rank: piece.currentRank))
        }

        // hide or hidden coordinates
        if viewOfColor == .white {
            chessBoardView.whiteCoordinates.isHidden = false
            chessBoardView.blackCoordinates.isHidden = true
        } else {
            chessBoardView.blackCoordinates.isHidden = false
            chessBoardView.whiteCoordinates.isHidden = true
        }
    }

    func load(piece: Pieces, atSquare square: Int) {
        let image: UIImageView
        switch piece {
        case is Pawn:
            image = UIImageView(image: UIImage(named: "ic_\(piece.color)Pawn"))
        case is Rook:
            image = UIImageView(image: UIImage(named: "ic_\(piece.color)Rook"))
        case is Knight:
            image = UIImageView(image: UIImage(named: "ic_\(piece.color)Knight"))
        case is Bishop:
            image = UIImageView(image: UIImage(named: "ic_\(piece.color)Bishop"))
        case is Queen:
            image = UIImageView(image: UIImage(named: "ic_\(piece.color)Queen"))
        case is King:
            image = UIImageView(image: UIImage(named: "ic_\(piece.color)King"))
        default:
            image = UIImageView()
        }
        // change dimension
        image.frame = chessBoardView.squaresView[0].bounds
        // add piece to view
        if viewOfColor == .black {
            image.image = image.image?.rotate()
        }
        chessBoardView.squaresView[square].addSubview(image)
    }
}
