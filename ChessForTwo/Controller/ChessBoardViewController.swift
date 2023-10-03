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

// MARK: - Init board

extension ChessBoardViewController {

    private func initBoard() {
        guard let viewOfColor = viewOfColor else { return }
        chessBoardView.viewOfColor = viewOfColor // for notification of move

        // load piece
        for piece in ChessBoard.allPieces() {
            load(piece: piece, atSquare: ChessBoard.posToInt(file: piece.currentFile, rank: piece.currentRank))
        }

        // hide or hidden coordinates
        switch viewOfColor {
        case .white:
            chessBoardView.whiteCoordinates.isHidden = false
            chessBoardView.blackCoordinates.isHidden = true
        case .black:
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
            image.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        chessBoardView.squaresView[square].addSubview(image)
    }
}
