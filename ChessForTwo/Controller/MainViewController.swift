//
//  MainViewController.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var whiteContainer: UIView!
    @IBOutlet weak var blackContainer: UIView!
    @IBOutlet weak var containersWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelMoveButton: UIButton!
    @IBOutlet weak var newRoundButton: UIButton!
    @IBOutlet weak var safeView: UIView!
    @IBOutlet weak var whiteBackground: UIView!
    @IBOutlet weak var blackBackground: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var playerOneName: UILabel!
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var whiteLosedPiecesTV: UITableView!
    @IBOutlet weak var whiteCapturedPiecesTV: UITableView!
    @IBOutlet weak var blackLosedPiecesTV: UITableView!
    @IBOutlet weak var blackCapturedPiecesTV: UITableView!

    // MARK: - IBAction

    @IBAction func backButtonTap() {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func cancelMoveTap() {
        cancelMoveTapAction()
    }
    @IBAction func newRoundTap() {
        newRoundTapAction()
    }

    // MARK: - Properties

    static let storyBoardId = "MainViewController"
    private var promotionPosition: Int?
    private var currentMove: (start: Int?, end: Int?)
    private var oldMove: (start: Int?, end: Int?)
    private let minCaptureWidth: CGFloat = 16
    private let maxContainerZoom: CGFloat = 48

    private var game: Game {
        get {
            return StartViewController.currentGame
        } set {
            StartViewController.currentGame = newValue
        }
    }

    private lazy var whiteChessBoardVC: ChessBoardViewController = {
        return instantiateChessBoardVC(container: whiteContainer, withColor: .white)
    }()

    private lazy var blackChessBoardVC: ChessBoardViewController = {
        return instantiateChessBoardVC(container: blackContainer, withColor: .black)
    }()

    private lazy var containersZoom: (up: CGFloat, down: CGFloat) = {
        // check if enough place for captured pieces
        if whiteLosedPiecesTV.superview!.bounds.width > minCaptureWidth {
            // check max width difference between containers
            let zoom: CGFloat
            if (whiteLosedPiecesTV.superview!.bounds.width - minCaptureWidth)*2 < maxContainerZoom {
                zoom = (whiteLosedPiecesTV.superview!.bounds.width - minCaptureWidth)*2
            } else {
                zoom = maxContainerZoom
            }
            let maxZoom = whiteContainer.bounds.width + zoom
            let minZoom = whiteContainer.bounds.width - zoom
            return (maxZoom / minZoom, minZoom / maxZoom)
        } else {
            return (1, 1)
        }
    }()
}

// MARK: - View did load

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // notifications
        NotificationCenter.default.addObserver(self, selector: #selector(moveDone(_:)), name: .moveDone, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(promotion(_:)), name: .promotion, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(castling(_:)), name: .castling, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(capture(_:)), name: .capture, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(promotionDone(_:)),
                                               name: .promotionDone, object: nil)
    }
}

// MARK: - View appear and disappear

extension MainViewController {

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        // Update layout to have correct frames dimensions
        view.layoutIfNeeded()
        playerOneName.text = game.names[.one]
        playerTwoName.text = game.names[.two]
        updateViewOrientation()
        updateWhoIsPlayingAndUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // put game in pause
        if game.state == .isStarted {
            game.pause()
        }
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

    private func updateContainersConstraint() {
        switch game.currentColor {
        case .white:
            containersWidthConstraint = containersWidthConstraint.setMultiplier(containersZoom.up, andRefresh: view)
        case .black:
            containersWidthConstraint = containersWidthConstraint.setMultiplier(containersZoom.down, andRefresh: view)
        default: // pause
            containersWidthConstraint = containersWidthConstraint.setMultiplier(1, andRefresh: view)
        }
        // update frame of pieces
        whiteChessBoardVC.updatePieceframes()
        blackChessBoardVC.updatePieceframes()
    }

    private func getChessBoardVC(forColor chessBoardColor: PieceColor) -> ChessBoardViewController {
        return chessBoardColor == .white ? whiteChessBoardVC : blackChessBoardVC
    }
}

// MARK: - Player actions

extension MainViewController {

    private func cancelMoveTapAction() {
        game.cancelLastMove()
        reloadChessBoard()
    }

    private func newRoundTapAction() {
        game.newRound()
        updateViewOrientation()
        reloadChessBoard()
    }

    @objc private func moveDone(_ notif: NSNotification) {
        // get notification object
        guard let move = notif.object as? (start: Int?, end: Int?), let start = move.start, let end = move.end,
              let player = game.currentColor else {
            // move is nil or player nil, something wrong, reinit
            reloadChessBoard()
            return
        }
        // check validity
        currentMove = move
        if !game.movePiece(fromInt: start, toInt: end) {
            errorSound?.play()
            cancelMove(fromEnd: end, toStart: start, onBoard: player)
            showKingState()
            return
        }
        // hide old move and move piece on opponent chessboard
        hideOldMove(onBoard: player)
        movePiece(startingSq: start, endingSq: end, onBoard: (player == .white ? .black : .white), showMove: true)
        // save movement for later UI update (to do after UI boards update)
        oldMove = move
        updateWhoIsPlayingAndUI()
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
        chessBoardVC.hideMove(start: oldMove.start, end: oldMove.end == currentMove.end ? nil : oldMove.end)
    }

    private func movePiece(startingSq: Int, endingSq: Int, onBoard color: PieceColor, showMove: Bool) {
        let chessBoardVC = getChessBoardVC(forColor: color)
        // update move
        guard let image = chessBoardVC.getLastAddedPiece(atPosition: startingSq) else { return }
        image.removeFromSuperview()
        chessBoardVC.addPiece(image, atPosition: endingSq)
        if !showMove { return }
        // show move and hide last move
        chessBoardVC.showMove(start: startingSq, end: endingSq)
        hideOldMove(onBoard: color)
    }
}

// MARK: - Player capture

extension MainViewController {

    @objc private func capture(_ notif: NSNotification) {
        guard let result = notif.object as? (position: Int, captureInPassing: Bool) else { return }
        if result.captureInPassing {
            captureSound?.play()
        }
        removePiece(atPosition: result.position, onChessBoardColor: .white)
        removePiece(atPosition: result.position, onChessBoardColor: .black)
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
        chessBoardVC.showPromotionChoice()
    }

    @objc private func promotionDone(_ notif: NSNotification) {
        guard let piece = notif.object as? Pieces else { return }
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
        chessBoardVC.hidePromotionChoiceOrResultPanel()
        updateWhoIsPlayingAndUI()
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
        if game.currentColor == .black { // TODO: Add sound for castling
            whiteSound?.play()
        } else {
            blackSound?.play()
        }
        movePiece(startingSq: rookMove.start, endingSq: rookMove.end, onBoard: .white, showMove: false)
        movePiece(startingSq: rookMove.start, endingSq: rookMove.end, onBoard: .black, showMove: false)
        // show king state
        showKingState()
    }
}

// MARK: - Game UI

extension MainViewController {

    private func reloadChessBoard() {
        whiteChessBoardVC.reloadChessBoard()
        blackChessBoardVC.reloadChessBoard()
        updateWhoIsPlayingAndUI()
    }

    private func updateViewOrientation() {
        // player one always at bottom of screen
        switch game.whoPlayWithWhite {
        case .one:
            whiteBackground.backgroundColor = UIColor.blackSquare
            blackBackground.backgroundColor = UIColor.whiteSquare
            safeView.transform = .identity
            buttonsView.transform = .identity
        case .two:
            whiteBackground.backgroundColor = UIColor.whiteSquare
            blackBackground.backgroundColor = UIColor.blackSquare
            safeView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            buttonsView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }

    private func updateWhoIsPlayingAndUI() {
        showKingState()
        whiteChessBoardVC.chessBoardView.whoIsPlaying = game.currentColor
        blackChessBoardVC.chessBoardView.whoIsPlaying = game.currentColor
        updateContainersConstraint()
        updateGameUI()
        whiteLosedPiecesTV.reloadData()
        blackCapturedPiecesTV.reloadData()
        whiteCapturedPiecesTV.reloadData()
        blackLosedPiecesTV.reloadData()
    }

    private func showKingState() {
        // white king
        whiteChessBoardVC.updateStateOfKing(atPosition: game.whiteKingState.position, state: game.whiteKingState.state)
        blackChessBoardVC.updateStateOfKing(atPosition: game.whiteKingState.position, state: game.whiteKingState.state)
        // black king
        whiteChessBoardVC.updateStateOfKing(atPosition: game.blackKingState.position, state: game.blackKingState.state)
        blackChessBoardVC.updateStateOfKing(atPosition: game.blackKingState.position, state: game.blackKingState.state)
    }

    private func updateGameUI() {
        // get state of game
        guard let gameState = game.state else { return }
        switch gameState {
        case .isStarted:
            gameIsStarted()
        case .inPause:
            gameIsStarted() // TODO: à implémenter avec les futurs minuteurs
        case .checkmate:
            displayCheckmate()
        case .stalemate:
            displayDraw(cause: String.stalemate)
        case .drawByRepetition:
            displayDraw(cause: String.drawByRepetition)
        }
    }

    private func gameIsStarted() {
        whiteChessBoardVC.hidePromotionChoiceOrResultPanel()
        blackChessBoardVC.hidePromotionChoiceOrResultPanel()
        cancelMoveButton.isHidden = false
        newRoundButton.isHidden = true
    }

    private func displayCheckmate() {
        // check king state
        if game.whiteKingState.state == .isCheckmate {
            // black has won, get score
            whiteChessBoardVC.showResult(result: String.youLose, score: game.scores(forColor: .white))
            blackChessBoardVC.showResult(result: String.youWin, score: game.scores(forColor: .black))
        } else if game.blackKingState.state == .isCheckmate {
            // white has won
            whiteChessBoardVC.showResult(result: String.youWin, score: game.scores(forColor: .white))
            blackChessBoardVC.showResult(result: String.youLose, score: game.scores(forColor: .black))
        } else {
            return
        }
        cancelMoveButton.isHidden = true
        newRoundButton.isHidden = false
    }

    private func displayDraw(cause: String) {
        cancelMoveButton.isHidden = true
        newRoundButton.isHidden = false
        whiteChessBoardVC.showResult(result: cause, score: game.scores(forColor: .white))
        blackChessBoardVC.showResult(result: cause, score: game.scores(forColor: .black))
    }
}
