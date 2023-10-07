//
//  ViewController.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Public properties

    static let storyBoardId = "MainViewController"

    // MARK: - IBOutlet

    @IBOutlet weak var whiteContainer: UIView!
    @IBOutlet weak var blackContainer: UIView!
    @IBOutlet weak var whiteCapturedPieces: UIStackView!
    @IBOutlet weak var whiteLosedPieces: UIStackView!
    @IBOutlet weak var blackCapturedPieces: UIStackView!
    @IBOutlet weak var blackLosedPieces: UIStackView!
    @IBOutlet weak var containersEqualWidthsConstraint: NSLayoutConstraint!

    // MARK: - IBAction

    @IBAction func backButton() {
        navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func cancelMoveButton() {
        cancelMoveButtonTap()
    }

    // MARK: - Private properties

    private var promotionPosition: Int?
    private var currentMove: (start: Int?, end: Int?)
    private var oldMove: (start: Int?, end: Int?)
    private var containersEqualWidth: NSLayoutConstraint?
    private var whiteContainersWidthUp: NSLayoutConstraint?
    private var blackContainersWidthUp: NSLayoutConstraint?

    private lazy var whiteChessBoardVC: ChessBoardViewController = {
        return instantiateChessBoardVC(container: whiteContainer, withColor: .white)
    }()

    private lazy var blackChessBoardVC: ChessBoardViewController = {
        return instantiateChessBoardVC(container: blackContainer, withColor: .black)
    }()

    private var game: Game {
        get {
            return StartViewController.currentGame
        } set {
            StartViewController.currentGame = newValue
        }
    }
}

// MARK: - View did load

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // notifications
        addObserverForNotification()
        // change containers constraints
        changeContainersConstraint()
        // update who is playing
        updateWhoIsPlaying()
    }
}

// MARK: - View will disappear

extension MainViewController {

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if game.state == .isStarted {
            game.pause()
        }
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
        // notification for castling
        NotificationCenter.default.addObserver(self, selector: #selector(castling(_:)),
                                               name: .castling, object: nil)
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

    private func changeContainersConstraint() {
        containersEqualWidth = NSLayoutConstraint(item: blackContainer!, attribute: .width, relatedBy: .equal,
                                                  toItem: whiteContainer!, attribute: .width,
                                                  multiplier: 1, constant: 0)

        whiteContainersWidthUp = NSLayoutConstraint(item: blackContainer!, attribute: .width, relatedBy: .equal,
                                                    toItem: whiteContainer!, attribute: .width,
                                                    multiplier: 0.9, constant: 0)

        blackContainersWidthUp = NSLayoutConstraint(item: blackContainer!, attribute: .width, relatedBy: .equal,
                                                    toItem: whiteContainer!, attribute: .width,
                                                    multiplier: 1.1, constant: 0)

        containersEqualWidthsConstraint.isActive = false
        containersEqualWidth!.isActive = true
        whiteContainersWidthUp!.isActive = false
        blackContainersWidthUp!.isActive = false
        view.addConstraints([containersEqualWidth!, whiteContainersWidthUp!, blackContainersWidthUp!])
    }

    private func updateContainersConstraint() {
        switch game.currentColor {
        case .white:
            containersEqualWidth?.isActive = false
            whiteContainersWidthUp?.isActive = true
            blackContainersWidthUp?.isActive = false
        case .black:
            containersEqualWidth?.isActive = false
            whiteContainersWidthUp?.isActive = false
            blackContainersWidthUp?.isActive = true
        default:
            containersEqualWidth?.isActive = true
            whiteContainersWidthUp?.isActive = false
            blackContainersWidthUp?.isActive = false
        }

        // update frame of pieces
        view.layoutIfNeeded()
        whiteChessBoardVC.updatePieceframes()
        blackChessBoardVC.updatePieceframes()
    }
}

// MARK: - Game

extension MainViewController {

    private func updateWhoIsPlaying() {
        whiteChessBoardVC.chessBoardView.whoIsPlaying = game.currentColor
        blackChessBoardVC.chessBoardView.whoIsPlaying = game.currentColor
        updateContainersConstraint()
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
            showKingState()
            return
        }
        // change view of current player
        hideOldMove(onBoard: player)

        // change view of second player
        movePiece(startingSq: start, endingSq: end, onBoard: (player == .white ? .black : .white), showMove: true)

        // save movement for later UI update (to do after UI boards update)
        oldMove = move

        // show king state
        showKingState()

        // update who is playing
        updateWhoIsPlaying()
    }

    private func getChessBoardVC(forColor chessBoardColor: PieceColor) -> ChessBoardViewController {
        return chessBoardColor == .white ? whiteChessBoardVC : blackChessBoardVC
    }

    private func cancelMove(fromEnd end: Int, toStart start: Int, onBoard color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // cancel
        guard let image = chessBoardVC.getLastAddedPiece(atPosition: end) else { return }
        image.removeFromSuperview()
        chessBoardVC.addPiece(image, atPosition: start)
        chessBoardVC.hideMove(start: start, end: end)
    }

    private func hideOldMove(onBoard color: PieceColor) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // hide last move
        chessBoardVC.hideMove(start: oldMove.start, end: oldMove.end == currentMove.end ? nil : oldMove.end)
    }

    private func movePiece(startingSq: Int, endingSq: Int, onBoard color: PieceColor, showMove: Bool) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // update move
        guard let image = chessBoardVC.getLastAddedPiece(atPosition: startingSq) else { return }
        image.removeFromSuperview()
        chessBoardVC.addPiece(image, atPosition: endingSq)

        if !showMove { return }

        // show move
        chessBoardVC.showMove(start: startingSq, end: endingSq)
        // hide last move
        hideOldMove(onBoard: color)
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

        // show king state
        showKingState()

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

// MARK: - castling

extension MainViewController {

    @objc private func castling(_ notif: NSNotification) {
        guard let rookMove = notif.object as? (start: Int, end: Int) else { return }
        movePiece(startingSq: rookMove.start, endingSq: rookMove.end, onBoard: .white, showMove: false)
        movePiece(startingSq: rookMove.start, endingSq: rookMove.end, onBoard: .black, showMove: false)
        // show king state
        showKingState()
    }
}

// MARK: - check or checkmate

extension MainViewController {

    private func showKingState() {
        // white king
        whiteChessBoardVC.updateStateOfKing(atPosition: game.whiteKingState.position, state: game.whiteKingState.state)
        blackChessBoardVC.updateStateOfKing(atPosition: game.whiteKingState.position, state: game.whiteKingState.state)
        // black king
        whiteChessBoardVC.updateStateOfKing(atPosition: game.blackKingState.position, state: game.blackKingState.state)
        blackChessBoardVC.updateStateOfKing(atPosition: game.blackKingState.position, state: game.blackKingState.state)
    }
}

// MARK: - Cancel move

extension MainViewController {

    private func cancelMoveButtonTap() {
        game.cancelLastMove()
        whiteChessBoardVC.reloadChessBoard()
        blackChessBoardVC.reloadChessBoard()
        updateWhoIsPlaying()
    }
}
