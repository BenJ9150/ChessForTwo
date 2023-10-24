//
//  MainViewControllerTableView.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 24/10/2023.
//

import UIKit

// MARK: - Captured pieces tableView

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.width
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case whiteLosedPiecesTV, blackCapturedPiecesTV:
            // white pieces captured
            return ChessBoard.whitePiecesCaptured.count
        case whiteCapturedPiecesTV, blackLosedPiecesTV:
            // black pieces captured
            return ChessBoard.blackPiecesCaptured.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear

        switch tableView {
        case whiteLosedPiecesTV, blackCapturedPiecesTV:
            // white pieces captured
            if indexPath.row >= ChessBoard.whitePiecesCaptured.count { return cell }
            cell.backgroundView = UIImageView.getPieceImageView(piece: ChessBoard.whitePiecesCaptured[indexPath.row])
        case whiteCapturedPiecesTV, blackLosedPiecesTV:
            // black pieces captured
            if indexPath.row >= ChessBoard.blackPiecesCaptured.count { return cell }
            cell.backgroundView = UIImageView.getPieceImageView(piece: ChessBoard.blackPiecesCaptured[indexPath.row])
        default:
            return cell
        }
        return cell
    }
}
