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
    @IBOutlet weak var promotionChoose: UIView!
    @IBOutlet weak var promotionQueen: UIButton!
    @IBOutlet weak var promotionRook: UIButton!
    @IBOutlet weak var promotionBishop: UIButton!
    @IBOutlet weak var promotionKnight: UIButton!

    // MARK: - IBAction

    @IBAction func promotionQueenTap() {
        NotificationCenter.default.post(name: .promotionHasChosen, object: Queen(viewOfColor))
    }

    @IBAction func promotionRookTap() {
        NotificationCenter.default.post(name: .promotionHasChosen, object: Rook(viewOfColor))
    }

    @IBAction func promotionBishopTap() {
        NotificationCenter.default.post(name: .promotionHasChosen, object: Bishop(viewOfColor))
    }

    @IBAction func promotionKnightTap() {
        NotificationCenter.default.post(name: .promotionHasChosen, object: Knight(viewOfColor))
    }
}

// MARK: - View did appear

extension ChessBoardViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initBoard() // in view did appear to have correct frames dimensions
        updatePromotionButtons()
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

// MARK: - Public methods

extension ChessBoardViewController {

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

    private func updatePromotionButtons() {
        guard let color = viewOfColor else { return }
        switch color {
        case .white:
            promotionQueen.setBackgroundImage(UIImage(named: "ic_whiteQueen"), for: .normal)
            promotionRook.setBackgroundImage(UIImage(named: "ic_whiteRook"), for: .normal)
            promotionBishop.setBackgroundImage(UIImage(named: "ic_whiteBishop"), for: .normal)
            promotionKnight.setBackgroundImage(UIImage(named: "ic_whiteKnight"), for: .normal)
        case .black:
            promotionQueen.setBackgroundImage(UIImage(named: "ic_blackQueen")?.rotate(), for: .normal)
            promotionRook.setBackgroundImage(UIImage(named: "ic_blackRook")?.rotate(), for: .normal)
            promotionBishop.setBackgroundImage(UIImage(named: "ic_blackBishop")?.rotate(), for: .normal)
            promotionKnight.setBackgroundImage(UIImage(named: "ic_blackKnight")?.rotate(), for: .normal)
        }
    }
}
