//
//  Game.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 13/09/2023.
//

import Foundation

enum Player {
    case one, two
}

enum GameState {
    case isOver, isStarted, inPause
}

final class Game {

    // MARK: - Public properties

    let names: [Player: String]
    var currentColor: PieceColor? {
        return whoIsPlaying
    }

    var state: GameState {
        return gameState
    }

    // MARK: - Private properties

    private var scores = [Player.one: 0, Player.two: 0]
    private var whoIsPlaying: PieceColor?
    private var whoIsPlayingBeforePause: PieceColor?
    private var gameState: GameState

    // MARK: - Init

    init(playerOne: String, playerTwo: String) {
        self.names = [Player.one: playerOne, Player.two: playerTwo]
        self.gameState = .isOver
        ChessBoard.initChessBoard()
    }
}

// MARK: - Public methods

extension Game {

    func start() {
        gameState = .isStarted
        whoIsPlaying = .white
    }

    func pause() {
        gameState = .inPause
        whoIsPlayingBeforePause = whoIsPlaying
        whoIsPlaying = nil
    }

    func unpause() {
        gameState = .isStarted
        whoIsPlaying = whoIsPlayingBeforePause
    }

    func score(ofPlayer player: Player) -> Int {
        return scores[player]!
    }

    func incrementScore(forPlayer player: Player) {
        scores[player]! += 1
        gameState = .isOver
        whoIsPlaying = nil
    }

    func movePiece(fromInt start: Int, toInt end: Int) -> Bool {
        // good player
        guard let playerColor = whoIsPlaying else { return false }

        // coordinates
        let start = ChessBoard.intToPos(start)
        let end = ChessBoard.intToPos(end)
        let startingPos = Square(file: start.file, rank: start.rank)
        let endingPos = Square(file: end.file, rank: end.rank)

        // get piece at start
        guard let movedPiece = ChessBoard.piece(atPosition: startingPos) else { return false }

        // check good color played
        if movedPiece.color != playerColor { return false }

        // move piece
        if !movedPiece.setNewPosition(atFile: endingPos.file, andRank: endingPos.rank) { return false }

        // check if capture
        checkIfCapture(movedPiece: movedPiece, startPos: startingPos, endPos: endingPos)

        // change pieces position in board
        ChessBoard.moveAfterSetPosition(piece: movedPiece)

        // change who is playing
        whoIsPlaying = whoIsPlaying == .white ? .black : .white
        return true
    }
}

// MARK: - Private methods

extension Game {

    private func checkIfCapture(movedPiece: Piece, startPos: Square, endPos: Square) {
        if let capturedPiece = ChessBoard.piece(atPosition: endPos) {
            removeCapturedPieceAndNotify(capturedPiece: capturedPiece, position: endPos)
            return
        }
        // check capture in passing
        if movedPiece is Pawn && startPos.file != endPos.file {
            // it's a pawn that has moved on diagonal in empty case: capture in passing
            let posOfCapPiece = Square(file: endPos.file, rank: startPos.rank)
            if let capPieceInPass = ChessBoard.piece(atPosition: posOfCapPiece), capPieceInPass is Pawn {
                removeCapturedPieceAndNotify(capturedPiece: capPieceInPass, position: posOfCapPiece)
            }
        }
    }

    private func removeCapturedPieceAndNotify(capturedPiece: Piece, position: Square) {
        ChessBoard.remove(capturedPiece: capturedPiece, atPosition: position)
        // get position in Int for notif
        let position = ChessBoard.posToInt(file: capturedPiece.currentFile, rank: capturedPiece.currentRank)
        NotificationCenter.default.post(name: .capturedPieceAtPosition, object: position)
    }
}
