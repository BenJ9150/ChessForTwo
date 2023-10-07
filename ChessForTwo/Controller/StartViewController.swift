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

    private var game: Game {
        get {
            return StartViewController.currentGame
        } set {
            StartViewController.currentGame = newValue
        }
    }

    // MARK: - IBOutlet

    @IBOutlet weak var playerOneTitle: UILabel!
    @IBOutlet weak var playerOneTextField: UITextField!
    @IBOutlet weak var playerTwoTitle: UILabel!
    @IBOutlet weak var playerTwoTextField: UITextField!

    // MARK: - IBAction

    @IBAction func dismissKeyboardOutsideTap(_ sender: Any) {
        dismissKeyboardOutsideTapAction()
    }

    @IBAction func startButton() {
        startButtonTap()
    }

    // MARK: - Deinit

    deinit {
        NotificationCenter.default.removeObserver(self)
   }
}

// MARK: - View did load

extension StartViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        // keyboard will show notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        // keyboard will hide notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Start game

extension StartViewController {

    private func startButtonTap() {
        // new game, start
        if game.state == .isOver && game.score(ofPlayer: .one) + game.score(ofPlayer: .two) == 0 {
            setPlayersName()
            game.start()
            pushMainVC()
            return
        }

        // game already started, alert to resume or restart new game
        let alert = UIAlertController(title: String.startAlertTitle, message: "", preferredStyle: .actionSheet)
        // resume game button
        let resume = UIAlertAction(title: String.resumeGame, style: .default) { _ in
            self.resumeGame()
        }
        // start new game button
        let newGame = UIAlertAction(title: String.startNewGame, style: .destructive) { _ in
            self.startNewGame()
        }
        // add buttons to alert and present
        alert.addAction(resume)
        alert.addAction(newGame)
        alert.addAction(UIAlertAction(title: String.cancel, style: .cancel))
        present(alert, animated: true)
    }

    private func setPlayersName() {
        // get player one name
        if let playerName = playerOneTextField.text {
            game.names[.one] = playerName
        } else {
            game.names[.one] = playerOneTitle.text
        }
        // get player two name
        if let playerName = playerTwoTextField.text {
            game.names[.one] = playerName
        } else {
            game.names[.one] = playerTwoTitle.text
        }
    }

    private func resumeGame() {
        if game.state == .isOver {
            game.start() // TODO: commencer une nouvelle manche à la place
        } else {
            game.unpause()
        }
        pushMainVC()
    }

    private func startNewGame() {
        game = Game()
        setPlayersName()
        game.start()
        pushMainVC()
    }

    private func pushMainVC() {
        guard let mainVC = storyboard?.instantiateViewController(withIdentifier: MainViewController.storyBoardId)
                as? MainViewController else { return }
        navigationController?.pushViewController(mainVC, animated: true)
    }
}

// MARK: - Keyboard and Textfield

extension StartViewController: UITextFieldDelegate {

    private func dismissKeyboardOutsideTapAction() {
        playerOneTextField.resignFirstResponder()
        playerTwoTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }

    @objc private func keyboardWillShowNotification(_ notif: NSNotification) {
        guard let keyboardFrame = notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let marginBelowTextField = marginBelowPlayerOneTextField()

        // Move up the player one textField
        if playerOneTextField.isEditing && keyboardHeight > marginBelowTextField {
            // get keyboard animation
            guard let animationCurve = notif.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
                  let animationDuration = notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]
                    as? Double else { return }

            // Convert the animation curve constant to animation options
            let animationOptions = UIView.AnimationOptions(rawValue: animationCurve << 16)

            // Perform animation
            UIView.animate(withDuration: animationDuration, delay: 0, options: animationOptions) {
                self.view.transform = CGAffineTransform(translationX: 0, y: marginBelowTextField - keyboardHeight)
            }
        }
    }

    @objc private func keyboardWillHideNotification(_ notif: NSNotification) {
        view.transform = .identity
    }

    private func marginBelowPlayerOneTextField() -> CGFloat {
        // get margin below textField
        var textFieldBottom = playerOneTextField.frame.origin.y + playerOneTextField.bounds.height
        var nextSuperView = playerOneTextField.superview
        while nextSuperView != nil {
            textFieldBottom += nextSuperView!.frame.origin.y
            print(nextSuperView!.frame.origin.y)
            nextSuperView = nextSuperView!.superview
        }
        return view.frame.height - view.safeAreaInsets.bottom - textFieldBottom - 48
    }
}
