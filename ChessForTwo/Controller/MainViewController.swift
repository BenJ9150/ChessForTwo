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

        // notifications
        addObserverForNotification()
    }
}

// MARK: - View did appear

extension MainViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startNewGame() // in view did appear to have correct frames dimensions
    }
}

// MARK: - Notification

extension MainViewController {

    private func addObserverForNotification() {
        // notification player one moved
        NotificationCenter.default.addObserver(self, selector: #selector(whiteMoved(_:)),
                                               name: .whiteMoved, object: nil)
        // notification player two moved
        NotificationCenter.default.addObserver(self, selector: #selector(blackMoved(_:)),
                                               name: .blackMoved, object: nil)
        // notification captured piece
        NotificationCenter.default.addObserver(self, selector: #selector(capturedPieceAtPosition(_:)),
                                               name: .capturedPieceAtPosition, object: nil)
    }
}

// MARK: - ChessBoard VC

extension MainViewController {

    private func instantiateChessBoardVC(container: UIView, withColor color: PieceColor) -> ChessBoardViewController {
        // Instantiate View Controller
        let childVC = ChessBoardViewController(nibName: ChessBoardViewController.nibName, bundle: .main)
        childVC.viewOfColor = color
        // Add Child View Controller
        addChild(childVC)
        // Add Child View as Subview
        childVC.view.frame = container.bounds
        container.addSubview(childVC.view)
        // Notify Child View Controller
        childVC.didMove(toParent: self)
        return childVC
    }
}

// MARK: - Game

extension MainViewController {

    private func startNewGame() {
        game.start()
        updateWhoIsPlaying()
    }

    private func updateWhoIsPlaying() {
        whiteChessBoardVC.chessBoardView.whoIsPlaying = game.currentColor
        blackChessBoardVC.chessBoardView.whoIsPlaying = game.currentColor
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
        if !game.movePiece(fromInt: start, toInt: end) {
            cancelMove(fromEnd: end, toStart: start, onChessBoardColor: pieceColor)
            return
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
}

// MARK: - Player capture

extension MainViewController {

    @objc private func capturedPieceAtPosition(_ notif: NSNotification) {
        guard let position = notif.object as? Int else { return }
        removeCapturedPiece(atPosition: position, onChessBoardColor: .white)
        removeCapturedPiece(atPosition: position, onChessBoardColor: .black)
    }

    private func removeCapturedPiece(atPosition position: Int, onChessBoardColor color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // delete
        if chessBoardVC.chessBoardView.squaresView[position].subviews.count > 0 {
            chessBoardVC.chessBoardView.squaresView[position].subviews[0].removeFromSuperview()
        }
    }
}
