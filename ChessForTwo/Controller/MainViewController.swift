//
//  ViewController.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var playerOneContainer: UIView!
    @IBOutlet weak var playerTwoContainer: UIView!

    // MARK: - Private properties

    private lazy var chessBoardVC: ChessBoardViewController = {
        return instantiateAndAddToContainer(playerOneContainer)
    }()
}

// MARK: - View did load

extension MainViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // reload board view to get good frame dimensions
        chessBoardVC.chessBoardView.reloadInputViews()
    }
}

// MARK: - View did appear

extension MainViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initBoard()
    }
}

// MARK: - ChessBoard VC

extension MainViewController {

    private func instantiateAndAddToContainer(_ container: UIView) -> ChessBoardViewController {
        // Instantiate View Controller
        let childVC = ChessBoardViewController(nibName: ChessBoardViewController.nibName, bundle: .main)
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

// MARK: - Init board

extension MainViewController {

    private func initBoard() {
        let game = Game(playerOne: "Ben", playerTwo: "Bob")

        for (_, piece) in game.board {
            load(piece: piece, atSquare: ChessBoard.posToInt(file: piece.currentFile, rank: piece.currentRank))
        }
    }

    private func load(piece: Piece, atSquare square: Int) {
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
        image.frame = chessBoardVC.chessBoardView.squaresView[0].bounds
        // add piece to view
        chessBoardVC.chessBoardView.squaresView[square].addSubview(image)
    }
}
