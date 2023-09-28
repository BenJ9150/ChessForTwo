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

    // MARK: - IBOutlet

    @IBOutlet var chessBoardView: ChessBoardView!
}

// MARK: - View did load

extension ChessBoardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
