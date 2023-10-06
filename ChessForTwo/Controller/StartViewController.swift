//
//  StartViewController.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 06/10/2023.
//

import UIKit

class StartViewController: UIViewController {

    // MARK: - Public properties

    static var currentGame = Game()

    // MARK: - Private properties

    var game: Game {
        get {
            return StartViewController.currentGame
        } set {
            StartViewController.currentGame = newValue
        }
    }

    // MARK: - IBOutlet

    @IBOutlet weak var playerOneTitle: UILabel!
    @IBOutlet weak var playerOneName: UITextField!
    @IBOutlet weak var playerTwoTitle: UILabel!
    @IBOutlet weak var playerTwoName: UITextField!

    // MARK: - IBAction

    @IBAction func startButton() {
        startButtonTap()
    }
}

// MARK: - View did load

extension StartViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Start game

extension StartViewController {

    private func startButtonTap() {
        // get player one name
        if let playerName = playerOneName.text {
            game.names[.one] = playerName
        } else {
            game.names[.one] = playerOneTitle.text
        }
        // get player two name
        if let playerName = playerTwoName.text {
            game.names[.one] = playerName
        } else {
            game.names[.one] = playerTwoTitle.text
        }
        // check if game in pause
        if game.state == .isOver {
            game.start()
        } else {
            game.unpause()
        }
        // push Main View Controller
        guard let mainVC = storyboard?.instantiateViewController(withIdentifier: MainViewController.storyBoardId)
                as? MainViewController else { return }

        navigationController?.pushViewController(mainVC, animated: true)
    }
}
