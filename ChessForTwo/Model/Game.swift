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
    var capturedPieces: [Piece] = []
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
        let startingPos = ChessBoard(file: start.file, rank: start.rank)
        let endingPos = ChessBoard(file: end.file, rank: end.rank)

        // get piece at start
        guard let movedPiece = ChessBoard.board[startingPos] else { return false }

        // check good color played
        if movedPiece.color != playerColor { return false }

        // move piece
        if !movedPiece.setNewPosition(atFile: endingPos.file, andRank: endingPos.rank) { return false }

        // check if capture
        checkIfCapture(movedPiece: movedPiece, startPos: startingPos, endPos: endingPos)

        // change pieces position in board
        ChessBoard.board[endingPos] = movedPiece
        ChessBoard.board.removeValue(forKey: startingPos)

        // change who is playing
        if whoIsPlaying == .white {
            whoIsPlaying = .black
        } else {
            whoIsPlaying = .white
        }

        // update total moves count
        ChessBoard.movesCount += 1
        return true
    }
}

// MARK: - Private methods

extension Game {

    private func checkIfCapture(movedPiece: Piece, startPos: ChessBoard, endPos: ChessBoard) {
        if let capturedPiece = ChessBoard.board[endPos] {
            removeCapturedPieceAndNotify(capturedPiece: capturedPiece, position: endPos)
            return
        }
        // check capture in passing
        if movedPiece is Pawn && startPos.file != endPos.file {
            // it's a pawn that has moved on diagonal in empty case: capture in passing
            if let capPieceInPass = ChessBoard.board[ChessBoard(file: endPos.file, rank: startPos.rank)] {
                removeCapturedPieceAndNotify(capturedPiece: capPieceInPass, position: endPos)
            }
        }
    }

    private func removeCapturedPieceAndNotify(capturedPiece: Piece, position: ChessBoard) {
        capturedPieces.append(capturedPiece)
        ChessBoard.board.removeValue(forKey: position)
        // get position in Int for notif
        let position = ChessBoard.posToInt(file: capturedPiece.currentFile, rank: capturedPiece.currentRank)
        NotificationCenter.default.post(name: .capturedPieceAtPosition, object: position)
    }
}
