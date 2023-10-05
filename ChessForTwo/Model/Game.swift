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

    var currentColorBeforePause: PieceColor? {
        return whoIsPlayingBeforePause
    }

    // MARK: - Private properties

    private var scores = [Player.one: 0, Player.two: 0]
    private var whoIsPlaying: PieceColor?
    private var whoIsPlayingBeforePause: PieceColor?
    private var gameState: GameState
    private var pieceAwaitingPromotion: Pieces?

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
        // coordinates
        let startSquare = ChessBoard.intToSquare(start)
        let endSquare = ChessBoard.intToSquare(end)

        // get piece at start
        guard let movedPiece = ChessBoard.piece(atPosition: startSquare) else { return false }

        // check good color played
        if movedPiece.color != whoIsPlaying { return false }

        // move piece
        let move = moveAndCapture(movedPiece, square: endSquare, updateGame: true)
        if !move.valid { return false }

        // notify ViewController if capture
        if let capturedPiece = move.capture {
            notifyCapturedPiece(capturedPiece)
            ChessBoard.addToCapturedPieces(capturedPiece)
        }
        return true
    }

    func promotion(chosenPiece: Pieces) {
        setBoardAfterPromotionChoice(chosenPiece: chosenPiece)
    }
}

// MARK: - Private methods for move and capture

extension Game {

    private func moveAndCapture(_ piece: Pieces, square: Square, updateGame: Bool) -> (valid: Bool, capture: Pieces?) {
        // move piece
        if !piece.setNewPosition(atFile: square.file, andRank: square.rank) { return (false, nil) }

        // check if capture
        let capturedPieceResult = checkIfCapture(movedPiece: piece)

        // change pieces position in board
        ChessBoard.moveAfterSetPosition(piece: piece)

        // king don't be check after the move
        let attackedByOpponent = ChessBoard.attackedSquaresByPieces(byColor: (piece.color == .white ? .black : .white))
        if let element = ChessBoard.chessboard.first(where: { $0.value is King && $0.value.color == piece.color }) {
            // check if king's square attack by opponent
            if attackedByOpponent.contains(where: { $0.key == element.value.square }) {
                piece.cancelLastMove()
                // delete modification on chess board
                ChessBoard.removePiece(atSquare: square)
                ChessBoard.add(piece)
                ChessBoard.add(capturedPieceResult)
                return (false, nil)
            }
        }

        // move is validate, check if promotion
        if pauseIfWaitingPromotion(pawn: piece, atSquare: square) {
            return (true, capturedPieceResult)
        }

        // check if castling
        checkIfCastling(piece, square: square)

        // update game
        if updateGame {
            updateGameAfterMove(playerColor: piece.color, attackedByOpponent: attackedByOpponent)
        }
        return (true, capturedPieceResult)
    }

    private func checkIfCapture(movedPiece: Pieces) -> Pieces? {
        if let capturedPiece = ChessBoard.piece(atPosition: movedPiece.square) {
            ChessBoard.remove(capturedPiece)
            return capturedPiece
        }
        // check if capture in passing for pawn
        if type(of: movedPiece) != type(of: Pawn()) || movedPiece.oldFile == movedPiece.currentFile {
            return nil
        }
        // it's a pawn that has moved on diagonal in empty case: capture in passing
        let posOfCapPiece = Square(file: movedPiece.currentFile, rank: movedPiece.oldRank)
        let capPieceInPass = ChessBoard.piece(atPosition: posOfCapPiece)
        ChessBoard.remove(capPieceInPass)
        return capPieceInPass
    }

    private func notifyCapturedPiece(_ capturedPiece: Pieces) {
        // get position in Int for notif
        let positionToInt = ChessBoard.posToInt(file: capturedPiece.currentFile, rank: capturedPiece.currentRank)
        NotificationCenter.default.post(name: .capturedPieceAtPosition, object: positionToInt)
    }
}

// MARK: - Private methods for castling

extension Game {

    private func checkIfCastling(_ king: Pieces, square: Square) {
        if type(of: king) != type(of: King()) { return }

        // check if big castling
        if king.currentFile - king.oldFile == -2 {
            castling(king, startRookFile: 1, endRookFile: 4)
        }
        // check if little castling
        if king.currentFile - king.oldFile == 2 {
            castling(king, startRookFile: 8, endRookFile: 6)
        }
    }

    private func castling(_ king: Pieces, startRookFile: Int, endRookFile: Int) {
        if let rook = ChessBoard.piece(atPosition: Square(file: startRookFile, rank: king.currentRank)) {
            // remove king of board to move rook
            ChessBoard.remove(king)
            // move rook (safe, already test in King class)
            _ = rook.setNewPosition(atFile: endRookFile, andRank: king.currentRank)
            // change rook position in board and add king
            ChessBoard.moveAfterSetPosition(piece: rook)
            ChessBoard.add(king)
            // notify controller
            let startingSq = ChessBoard.posToInt(file: rook.oldFile, rank: rook.oldRank)
            let endingSq = ChessBoard.posToInt(file: rook.currentFile, rank: rook.currentRank)
            NotificationCenter.default.post(name: .castling, object: (start: startingSq, end: endingSq))
        }
    }
}

// MARK: - Private methods for promotion

extension Game {

    private func setBoardAfterPromotionChoice<T: Pieces>(chosenPiece: T) {
        // get olg piece to promute
        if let oldPiece = pieceAwaitingPromotion {
            // remove old piece
            ChessBoard.remove(oldPiece)
            // add new Piece
            let new = T(initialFile: oldPiece.currentFile, initialRank: oldPiece.currentRank, color: oldPiece.color)
            ChessBoard.add(new)
            pieceAwaitingPromotion = nil
            unpause()

            // update game
            let attackByOpp = ChessBoard.attackedSquaresByPieces(byColor: (oldPiece.color == .white ? .black : .white))
            updateGameAfterMove(playerColor: oldPiece.color, attackedByOpponent: attackByOpp)
        }
    }

    private func pauseIfWaitingPromotion(pawn: Pieces, atSquare square: Square) -> Bool {
        if type(of: pawn) != type(of: Pawn()) { return false }
        // check good rank
        switch pawn.color {
        case .black:
            if square.rank != ChessBoard.minPosition { return false }
        case .white:
            if square.rank != ChessBoard.maxPosition { return false }
        }
        // promotion
        pieceAwaitingPromotion = pawn
        // get position in Int for notif
        let positionToInt = ChessBoard.posToInt(file: pawn.currentFile, rank: pawn.currentRank)
        NotificationCenter.default.post(name: .promotion, object: (color: pawn.color, position: positionToInt))
        pause()
        return true
    }
}

// MARK: - Private methods for update

extension Game {

    private func updateGameAfterMove(playerColor: PieceColor, attackedByOpponent: [Square: [Pieces]]) {
        // check if opponent is checkmate or stalemate
        let opponent: PieceColor = whoIsPlaying == .white ? .black : .white
        if let element = ChessBoard.chessboard.first(where: { $0.value is King && $0.value.color == opponent }) {
            // get opponent king
            if let opponentKing = ChessBoard.piece(atPosition: element.value.square) {
                // get attacked squares by player
                let attackedByPlayer = ChessBoard.attackedSquaresByPieces(byColor: playerColor)

                // verify if checkmate
                if checkmate(opponentKing: opponentKing, attackedByPlayer: attackedByPlayer,
                             attackedByOpponent: attackedByOpponent) { return }

                // verify if stalemate
                if stalemate(opponentKing: opponentKing, attackedByPlayer: attackedByPlayer) { return }
            }
        }

        // verify if draw by repetition
        if ChessBoard.savePositionAndCheckIfdrawByRepetition() {
            itsDraw()
            return
        }

        // change who is playing
        whoIsPlaying = whoIsPlaying == .white ? .black : .white
    }
}

// MARK: - Private methods for checkmate

extension Game {

    private func checkmate(opponentKing: Pieces, attackedByPlayer: [Square: [Pieces]],
                           attackedByOpponent: [Square: [Pieces]]) -> Bool {
        // get player pieces that attack opponent king
        guard let playerPiecesAttackOppKing = attackedByPlayer[opponentKing.square] else { return false }

        if playerPiecesAttackOppKing.count == 1 {
            // one piece attack opponent king, verify if opponent can capture this piece to avoid checkmate
            let playerPiece = playerPiecesAttackOppKing[0]
            if let oppPieces = attackedByOpponent[playerPiece.square] {
                if validAttackToAvoidMate(playerPiece: playerPiece, oppPieces: oppPieces) { return false }
            }
            // verify if opponent can protect king to save checkmate
            let defendedSquares = ChessBoard.defendedSquares(byColor: (whoIsPlaying == .white ? .black : .white))
            let emptySquares = ValidMoves.emptySquaresBetween(opponentKing, and: playerPiece)
            for square in emptySquares where defendedSquares[square] != nil {
                for piece in defendedSquares[square]! where type(of: piece) != type(of: King()) { return false }
            }
        }

        // check if there is one possible move or attack for opponent king
        return opponentKingHasNoValidMove(opponentKing: opponentKing)
    }

    private func validAttackToAvoidMate(playerPiece: Pieces, oppPieces: [Pieces]) -> Bool {
        // simulation of opponent capture, remove player piece
        let endSquare = Square(file: playerPiece.currentFile, rank: playerPiece.currentRank)
        for movedPiece in oppPieces {
            let move = moveAndCapture(movedPiece, square: endSquare, updateGame: false)
            if !move.valid { continue }
            // delete simulation
            movedPiece.cancelLastMove()
            // delete modification on chess board
            ChessBoard.removePiece(atSquare: endSquare)
            ChessBoard.add(movedPiece)
            ChessBoard.add(move.capture)
            return true
        }
        return false
    }

    private func opponentKingHasNoValidMove(opponentKing: Pieces) -> Bool {
        for endSquare in opponentKing.getValidMoves() {
            let move = moveAndCapture(opponentKing, square: endSquare, updateGame: false)
            if !move.valid { continue }
            // valid move, no checkmate, delete simulation
            opponentKing.cancelLastMove()
            // delete modification on chess board
            ChessBoard.removePiece(atSquare: endSquare)
            ChessBoard.add(opponentKing)
            ChessBoard.add(move.capture)
            return false
        }
        // checkmate!
        gameWinByColor()
        return true
    }

    private func gameWinByColor() {
        if let playerColor = whoIsPlaying {
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
    }
}

// MARK: - Private methods for stalemate

extension Game {

    private func stalemate(opponentKing: Pieces, attackedByPlayer: [Square: [Pieces]]) -> Bool {
        // check if all pieces of opponent can't move (except the king)
        let opponentPieces = ChessBoard.allPiecesOfColor((whoIsPlaying == .white ? .black : .white))
        var opponentPiecesMoves: [Square] = []
        for piece in opponentPieces {
            if piece is King { continue }
            opponentPiecesMoves.append(contentsOf: piece.getValidMoves())
        }
        if opponentPiecesMoves.count > 0 { return false }

        // check if opponent King is check
        if attackedByPlayer.contains(where: { $0.key == opponentKing.square }) { return false }

        // check if all opponent King moves are attacked, stalemate if true
        for square in opponentKing.getValidMoves() where !attackedByPlayer.contains(where: { $0.key == square }) {
            return false
        }
        itsDraw()
        return true
    }

    private func itsDraw() {
        // increment score
        scores[.one]! += 1
        scores[.two]! += 1
        gameState = .isOver
        whoIsPlaying = nil
    }
}
