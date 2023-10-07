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

// MARK: - Public methods for chessBoardView

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

    func showMove(start: Int, end: Int) {
        chessBoardView.selectSquare(atPosition: start)
        chessBoardView.selectSquare(atPosition: end)
    }

    func hideMove(start: Int?, end: Int?) {
        chessBoardView.unselectSquare(atPosition: start)
        chessBoardView.unselectSquare(atPosition: end)
    }

    func updatePieceframes() {
        for square in chessBoardView.squaresView where square.subviews.count > 0 {
            square.subviews[0].frame = square.bounds
        }
    }

    func updateStateOfKing(atPosition position: Int?, state: KingState) {
        guard let pos = position, pos < chessBoardView.squaresView.count else { return }
        if chessBoardView.squaresView[pos].subviews.count != 1 { return }
        // get king with position
        let king = chessBoardView.squaresView[pos].subviews[0]
        // update background
        switch state {
        case .isFree:
            king.backgroundColor = .clear
        case .isCheck:
            king.backgroundColor = .kingIsCheck
        case .isCheckmate:
            king.backgroundColor = .kingIsCheckmate
        }
    }
}

// MARK: - Public methods: load piece

extension ChessBoardViewController {

    func load(piece: Pieces, atSquare square: Int) {
        let imageView: UIImageView
        switch piece {
        case is Pawn:
            imageView = UIImageView(image: UIImage(named: "ic_\(piece.color)Pawn"))
        case is Rook:
            imageView = UIImageView(image: UIImage(named: "ic_\(piece.color)Rook"))
        case is Knight:
            imageView = UIImageView(image: UIImage(named: "ic_\(piece.color)Knight"))
        case is Bishop:
            imageView = UIImageView(image: UIImage(named: "ic_\(piece.color)Bishop"))
        case is Queen:
            imageView = UIImageView(image: UIImage(named: "ic_\(piece.color)Queen"))
        case is King:
            imageView = UIImageView(image: UIImage(named: "ic_\(piece.color)King"))
        default:
            imageView = UIImageView()
        }
        // change dimension
        imageView.frame = chessBoardView.squaresView[0].bounds
        // add piece to view
        if viewOfColor == .black {
            imageView.image = ChessBoard.rotatePiece(image: imageView.image)
        }
        chessBoardView.squaresView[square].addSubview(imageView)
    }

    func reloadChessBoard() {
        for squareView in chessBoardView.squaresView {
            for image in squareView.subviews {
                image.removeFromSuperview()
            }
        }
        initBoard()
    }
}

// MARK: - Init board

extension ChessBoardViewController {

    private func initBoard() {
        chessBoardView.viewOfColor = viewOfColor // for notification of move

        // load piece
        for piece in ChessBoard.board {
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
