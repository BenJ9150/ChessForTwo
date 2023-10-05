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
    @IBOutlet weak var containersEqualWidthsConstraint: NSLayoutConstraint!

    // MARK: - Private properties

    private let game = Game(playerOne: "", playerTwo: "")
    private var promotionPosition: Int?
    private var currentMove: (start: Int?, end: Int?)
    private var oldMove: (start: Int?, end: Int?)

    private lazy var whiteChessBoardVC: ChessBoardViewController = {
        return instantiateChessBoardVC(container: whiteContainer, withColor: .white)
    }()

    private lazy var blackChessBoardVC: ChessBoardViewController = {
        return instantiateChessBoardVC(container: blackContainer, withColor: .black)
    }()

    private var equalWidth: NSLayoutConstraint?
    private var whiteWidthUp: NSLayoutConstraint?
    private var blackWidthUp: NSLayoutConstraint?
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

        equalWidth = NSLayoutConstraint(item: blackContainer!, attribute: .width, relatedBy: .equal,
                                                    toItem: whiteContainer!, attribute: .width,
                                                    multiplier: 1, constant: 0)

        whiteWidthUp = NSLayoutConstraint(item: blackContainer!, attribute: .width, relatedBy: .equal,
                                                    toItem: whiteContainer!, attribute: .width,
                                          multiplier: 0.9, constant: 0)

        blackWidthUp = NSLayoutConstraint(item: blackContainer!, attribute: .width, relatedBy: .equal,
                                                    toItem: whiteContainer!, attribute: .width,
                                          multiplier: 1.1, constant: 0)

        containersEqualWidthsConstraint.isActive = false
        equalWidth!.isActive = true
        whiteWidthUp!.isActive = false
        blackWidthUp!.isActive = false
        view.addConstraints([equalWidth!, whiteWidthUp!, blackWidthUp!])

        startNewGame() // in view did appear to have correct frames dimensions
    }
}

// MARK: - Notification

extension MainViewController {

    private func addObserverForNotification() {
        // notification player move done
        NotificationCenter.default.addObserver(self, selector: #selector(moveDone(_:)),
                                               name: .moveDone, object: nil)
        // notification captured piece
        NotificationCenter.default.addObserver(self, selector: #selector(capturedPieceAtPosition(_:)),
                                               name: .capturedPieceAtPosition, object: nil)
        // notification waiting promotion
        NotificationCenter.default.addObserver(self, selector: #selector(promotion(_:)),
                                               name: .promotion, object: nil)
        // notification promotion has chosen
        NotificationCenter.default.addObserver(self, selector: #selector(promotionHasChosen(_:)),
                                               name: .promotionHasChosen, object: nil)
        // TODO: notification pour faire les roques
        // TODO: notification partie gagnée
        // TODO: notification partie nul
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

        switch game.currentColor {
        case .white:
            equalWidth?.isActive = false
            whiteWidthUp?.isActive = true
            blackWidthUp?.isActive = false
        case .black:
            equalWidth?.isActive = false
            whiteWidthUp?.isActive = false
            blackWidthUp?.isActive = true
        default:
            equalWidth?.isActive = true
            whiteWidthUp?.isActive = false
            blackWidthUp?.isActive = false
        }

        view.layoutIfNeeded()
        // update frame of pieces
        for square in whiteChessBoardVC.chessBoardView.squaresView {
            for subview in square.subviews {
                subview.frame = square.bounds
            }
        }
        for square in blackChessBoardVC.chessBoardView.squaresView {
            for subview in square.subviews {
                subview.frame = square.bounds
            }
        }
    }
}

// MARK: - Player moved

extension MainViewController {

    @objc private func moveDone(_ notif: NSNotification) {
        // get notification object
        guard let move = notif.object as? (start: Int?, end: Int?) else { return }
        currentMove = move

        // get start and end movement
        guard let start = move.start, let end = move.end else { return }

        // who is playing
        guard let player = game.currentColor else { return}

        // check validity
        if !game.movePiece(fromInt: start, toInt: end) {
            cancelMove(fromEnd: end, toStart: start, onBoard: player)
            return
        }
        // change view of current player
        updatePlayerUI(onBoard: player)

        // change view of second player
        updateOpponentUI(startingSq: start, endingSq: end, onBoard: (player == .white ? .black : .white))

        // save movement for later UI update (to do after UI boards update)
        oldMove = move

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

    private func cancelMove(fromEnd end: Int, toStart start: Int, onBoard color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // cancel
        guard let image = chessBoardVC.getLastAddedPiece(atPosition: end) else { return }
        image.removeFromSuperview()
        chessBoardVC.addPiece(image, atPosition: start)
        chessBoardVC.chessBoardView.hiddenMove(startSquare: start, endSquare: end)
    }

    private func updatePlayerUI(onBoard color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // hidden last move
        if oldMove.end == currentMove.end {
            chessBoardVC.chessBoardView.hiddenMove(startSquare: oldMove.start, endSquare: nil)
        } else {
            chessBoardVC.chessBoardView.hiddenMove(startSquare: oldMove.start, endSquare: oldMove.end)
        }
    }

    private func updateOpponentUI(startingSq: Int, endingSq: Int, onBoard color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // update move
        guard let image = chessBoardVC.getLastAddedPiece(atPosition: startingSq) else { return }
        image.removeFromSuperview()
        chessBoardVC.addPiece(image, atPosition: endingSq)
        // show move
        chessBoardVC.chessBoardView.showMove(startSquare: startingSq, endSquare: endingSq)
        // hidden last move
        if oldMove.end == currentMove.end {
            chessBoardVC.chessBoardView.hiddenMove(startSquare: oldMove.start, endSquare: nil)
        } else {
            chessBoardVC.chessBoardView.hiddenMove(startSquare: oldMove.start, endSquare: oldMove.end)
        }
    }
}

// MARK: - Player capture

extension MainViewController {

    @objc private func capturedPieceAtPosition(_ notif: NSNotification) {
        guard let position = notif.object as? Int else { return }
        removePiece(atPosition: position, onChessBoardColor: .white)
        removePiece(atPosition: position, onChessBoardColor: .black)
    }

    private func removePiece(atPosition position: Int, onChessBoardColor color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        chessBoardVC.removeFirstAddedPiece(atPosition: position)
    }
}

// MARK: - Promotion

extension MainViewController {

    @objc private func promotion(_ notif: NSNotification) {
        guard let object = notif.object as? (color: PieceColor, position: Int) else { return }
        promotionPosition = object.position
        // display piece choice for promotion
        let chessBoardVC = getChessBoardVC(forColor: object.color)
        chessBoardVC.promotionChoose.isHidden = false
    }

    @objc private func promotionHasChosen(_ notif: NSNotification) {
        guard let pieces = notif.object as? Pieces else { return }
        promotionChoice(pieces)
    }

    private func promotionChoice(_ piece: Pieces) {
        guard let position = promotionPosition else { return }
        game.promotion(chosenPiece: piece)

        // get player color (game is restarted)
        guard let playerColor = game.currentColor else { return }

        // remove old and load new
        removePiece(atPosition: position, onChessBoardColor: .white)
        removePiece(atPosition: position, onChessBoardColor: .black)
        loadNewPiece(piece, atPosition: position, onChessBoardColor: .white)
        loadNewPiece(piece, atPosition: position, onChessBoardColor: .black)

        // hide piece choice for promotion and update who is playing
        let chessBoardVC = getChessBoardVC(forColor: playerColor == .white ? .black : .white)
        chessBoardVC.promotionChoose.isHidden = true
        updateWhoIsPlaying()
    }

    private func loadNewPiece(_ piece: Pieces, atPosition position: Int, onChessBoardColor color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        chessBoardVC.load(piece: piece, atSquare: position)
    }
}
