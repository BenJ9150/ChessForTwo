//
//  ViewController.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var whiteContainer: UIView!
    @IBOutlet weak var blackContainer: UIView!
    @IBOutlet weak var whiteCapturedPieces: UIStackView!
    @IBOutlet weak var whiteLosedPieces: UIStackView!
    @IBOutlet weak var blackCapturedPieces: UIStackView!
    @IBOutlet weak var blackLosedPieces: UIStackView!

    // MARK: - Private properties

    let game = Game(playerOne: "", playerTwo: "")

    private lazy var whiteChessBoardVC: ChessBoardViewController = {
        return instantiateChessBoardVC(container: whiteContainer, withColor: .white)
    }()

    private lazy var blackChessBoardVC: ChessBoardViewController = {
        return instantiateChessBoardVC(container: blackContainer, withColor: .black)
    }()
}

// MARK: - View did load

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // reload board view to get good frame dimensions
        whiteChessBoardVC.chessBoardView.reloadInputViews()
        blackChessBoardVC.chessBoardView.reloadInputViews()

        // notification player one moved
        NotificationCenter.default.addObserver(self, selector: #selector(whiteMoved(_:)),
                                               name: .whiteMoved, object: nil)
        // notification player two moved
        NotificationCenter.default.addObserver(self, selector: #selector(blackMoved(_:)),
                                               name: .blackMoved, object: nil)
    }
}

// MARK: - View did appear

extension MainViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startNewGame() // in view did appear to have correct frames dimensions
    }
}

// MARK: - ChessBoard VC

extension MainViewController {

    private func instantiateChessBoardVC(container: UIView, withColor color: PieceColor) -> ChessBoardViewController {
        // Instantiate View Controller
        let childVC = ChessBoardViewController(nibName: ChessBoardViewController.nibName, bundle: .main)
        // Add Child View Controller
        addChild(childVC)
        // Add Child View as Subview
        childVC.view.frame = container.bounds
        childVC.chessBoardView.viewOfColor = color
        container.addSubview(childVC.view)
        // Notify Child View Controller
        childVC.didMove(toParent: self)
        return childVC
    }
}

// MARK: - Game

extension MainViewController {

    private func startNewGame() {
        initBoard()
        game.start()
        updateWhoIsPlaying()
    }

    private func updateWhoIsPlaying() {
        whiteChessBoardVC.chessBoardView.whoIsPlaying = game.currentColor
        blackChessBoardVC.chessBoardView.whoIsPlaying = game.currentColor
    }
}

// MARK: - Init board

extension MainViewController {

    private func initBoard() {
        for (_, piece) in game.board {

            load(piece: piece,
                 atSquare: ChessBoard.posToInt(file: piece.currentFile, rank: piece.currentRank),
                 forPlayer: .one)

            load(piece: piece,
                 atSquare: ChessBoard.posToInt(file: piece.currentFile, rank: piece.currentRank),
                 forPlayer: .two)
        }
    }

    private func load(piece: Piece, atSquare square: Int, forPlayer player: Player) {
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
        image.frame = whiteChessBoardVC.chessBoardView.squaresView[0].bounds
        // add piece to view
        switch player {
        case .one:
            whiteChessBoardVC.chessBoardView.squaresView[square].addSubview(image)
        case .two:
            image.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            blackChessBoardVC.chessBoardView.squaresView[square].addSubview(image)
        }
    }
}

// MARK: - Player moved

extension MainViewController {

    @objc private func whiteMoved(_ notif: NSNotification) {
        pieceMoved(notif, pieceColor: .white)
    }

    @objc private func blackMoved(_ notif: NSNotification) {
        pieceMoved(notif, pieceColor: .black)
    }

    private func pieceMoved(_ notif: NSNotification, pieceColor: PieceColor) {
        guard let movement = notif.object as? (start: Int?, end: Int?) else { return }
        // get start and end movement
        guard let start = movement.start else { return }
        guard let end = movement.end else { return }
        // check validity
        let result = game.movePiece(fromInt: start, toInt: end)
        if !result.isValid {
            cancelMove(fromEnd: end, toStart: start, onChessBoardColor: pieceColor)
            return
        }
        // check if capture
        if result.capture {
            removeCapturedPiece(atPosition: end, onChessBoardColor: .white)
            removeCapturedPiece(atPosition: end, onChessBoardColor: .black)
        }
        // change view of second player
        switch pieceColor {
        case .white:
            updateMove(fromStart: start, toEnd: end, onChessBoardColor: .black)
        case .black:
            updateMove(fromStart: start, toEnd: end, onChessBoardColor: .white)
        }
        // update who is playing
        updateWhoIsPlaying()
    }

    private func getChessBoardVC(forColor chessBoardColor: PieceColor) -> ChessBoardViewController {
        switch chessBoardColor {
        case .white:
            return whiteChessBoardVC
        case .black:
            return blackChessBoardVC
        }
    }

    private func cancelMove(fromEnd end: Int, toStart start: Int, onChessBoardColor color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // cancel
        guard let image = chessBoardVC.chessBoardView.squaresView[end].subviews.last else { return }
        image.removeFromSuperview()
        chessBoardVC.chessBoardView.squaresView[start].addSubview(image)
    }

    private func updateMove(fromStart start: Int, toEnd end: Int, onChessBoardColor color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // update
        guard let image = chessBoardVC.chessBoardView.squaresView[start].subviews.last else { return }
        image.removeFromSuperview()
        chessBoardVC.chessBoardView.squaresView[end].addSubview(image)
    }

    private func removeCapturedPiece(atPosition position: Int, onChessBoardColor color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // delete
        chessBoardVC.chessBoardView.squaresView[position].subviews[0].removeFromSuperview()
    }
}
