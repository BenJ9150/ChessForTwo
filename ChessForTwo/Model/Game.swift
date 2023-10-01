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
    var whoPlayWithWhite: Player
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
        self.whoPlayWithWhite = .one
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

    func movePiece(fromInt start: Int, toInt end: Int) -> Bool {
        // good player
        guard let playerColor = whoIsPlaying else { return false }

        // coordinates
        let startSquare = ChessBoard.intToSquare(start)
        let endSquare = ChessBoard.intToSquare(end)

        // get piece at start
        guard let movedPiece = ChessBoard.piece(atPosition: startSquare) else { return false }

        // check good color played
        if movedPiece.color != playerColor { return false }

        // move piece
        if !movedPiece.setNewPosition(atFile: endSquare.file, andRank: endSquare.rank) { return false }

        // check if king is check after the move
        if let check = isCheck(whoIsPlaying: playerColor), check == true {
            movedPiece.cancelLastMove()
            return false
        }

        // check if capture
        checkIfCapture(movedPiece: movedPiece, startPos: startSquare, endPos: endSquare)

        // change pieces position in board
        ChessBoard.moveAfterSetPosition(piece: movedPiece)

        // check if opponent is check mat
        if let checkMat = opponentIsCheckMat(whoIsPlaying: playerColor), checkMat == true {
            gameWinByColor(playerColor)
            return true
        }

        // change who is playing
        whoIsPlaying = whoIsPlaying == .white ? .black : .white
        return true
    }
}

// MARK: - Private methods

extension Game {

    private func gameWinByColor(_ playerColor: PieceColor) {
        let winner: Player
        switch playerColor {
        case .white:
            winner = whoPlayWithWhite
        case .black:
            winner = whoPlayWithWhite == .one ? .two : .one
        }
        // increment score
        scores[winner]! += 2
        gameState = .isOver
        whoIsPlaying = nil
    }

    private func opponentIsCheckMat(whoIsPlaying: PieceColor) -> Bool? {
        // get king square
        guard let oppKingSquare = ChessBoard.getKingSquare(color: (whoIsPlaying == .white ? .black : .white)) else {
            return nil
        }
        // check if opponent King is check
        let attackedSquares = ChessBoard.attackedSquares(byColor: whoIsPlaying)
        if !attackedSquares.contains(oppKingSquare) { return false }

        // check if opponent King can move, mat if not
        guard let oppKing = ChessBoard.piece(atPosition: oppKingSquare) else { return nil }
        let oppKingMoves = oppKing.getAttackedSquares()
        if oppKingMoves.count <= 0 { return true }

        // check if all opponent King moves are attacked, mat if true
        for square in oppKingMoves where !attackedSquares.contains(square) {
            return false
        }
        return true
    }

    private func isCheck(whoIsPlaying: PieceColor) -> Bool? {
        // get king square
        guard let kingSquare = ChessBoard.getKingSquare(color: whoIsPlaying) else { return nil }
        // get attacked position
        let attackedSquares = ChessBoard.attackedSquares(byColor: (whoIsPlaying == .white ? .black : .white))
        // check if King is attacked
        if attackedSquares.contains(kingSquare) { return true }
        return false
    }

    private func checkIfCapture(movedPiece: Pieces, startPos: Square, endPos: Square) {
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

    private func removeCapturedPieceAndNotify(capturedPiece: Pieces, position: Square) {
        ChessBoard.remove(capturedPiece: capturedPiece, atPosition: position)
        // get position in Int for notif
        let position = ChessBoard.posToInt(file: capturedPiece.currentFile, rank: capturedPiece.currentRank)
        NotificationCenter.default.post(name: .capturedPieceAtPosition, object: position)
    }
}
