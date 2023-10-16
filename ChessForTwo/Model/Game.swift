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
enum KingState {
    case isFree, isCheck, isCheckmate
}

final class Game {

    // MARK: - Public properties

    var names: [Player: String]
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
    var whiteKingState: (position: Int?, state: KingState) {
        return whiteKing
    }
    var blackKingState: (position: Int?, state: KingState) {
        return blackKing
    }

    // MARK: - Private properties

    private var scores = [Player.one: 0, Player.two: 0]
    private var whoIsPlaying: PieceColor?
    private var whoIsPlayingBeforePause: PieceColor?
    private var gameState: GameState
    private var pieceAwaitingPromotion: Pieces?
    private var whiteKing: (position: Int?, state: KingState)
    private var blackKing: (position: Int?, state: KingState)
    private var lastMovedPiece: Pieces?
    private var lastMovedRookIfCastling: Pieces?
    private var lastCapturedPiece: Pieces?

    // MARK: - Init

    init() {
        self.names = [Player.one: "", Player.two: ""]
        self.gameState = .isOver
        self.whoPlayWithWhite = .one
        self.whoIsPlaying = nil
        self.whoIsPlayingBeforePause = nil
        self.pieceAwaitingPromotion = nil
        self.whiteKing = (nil, .isFree)
        self.blackKing = (nil, .isFree)
        self.lastMovedPiece = nil
        self.lastMovedRookIfCastling = nil
        self.lastCapturedPiece = nil
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
        // get coordinates and piece
        let startSquare = ChessBoard.intToSquare(start)
        let endSquare = ChessBoard.intToSquare(end)
        guard let movedPiece = ChessBoard.piece(atPosition: startSquare, ofColor: whoIsPlaying) else { return false }
        // check good move
        let move = moveAndCapture(movedPiece, square: endSquare, updateGame: true)
        if !move.valid { return false }
        // notify ViewController if capture
        if let capturedPiece = move.capture {
            ChessBoard.notifyCapturedPiece(capturedPiece)
            ChessBoard.addToCapturedPieces(capturedPiece)
            // save for later if cancel
            lastCapturedPiece = capturedPiece
        } else {
            lastCapturedPiece = nil
        }
        return true
    }

    func promotion<T: Pieces>(chosenPiece: T) {
        // get olg piece to promute
        if let oldPiece = pieceAwaitingPromotion {
            // remove old and add new piece
            ChessBoard.remove(oldPiece)
            let new = T(initialFile: oldPiece.currentFile, initialRank: oldPiece.currentRank, color: oldPiece.color)
            ChessBoard.add(new)
            // update game
            pieceAwaitingPromotion = nil
            unpause()
            let attackByOpp = ChessBoard.attackedSquaresByPieces(byColor: (oldPiece.color == .white ? .black : .white))
            updateGameAfterMove(playerColor: oldPiece.color, attackedByOpponent: attackByOpp)
        }
    }

    func cancelLastMove() {
        guard let movedPiece = lastMovedPiece else { return }
        movedPiece.cancelLastMove()
        if let rook = lastMovedRookIfCastling {
            rook.cancelLastMove()
        }
        if let capturedPiece = lastCapturedPiece {
            ChessBoard.add(capturedPiece)
            ChessBoard.removeFromCapturedPieces(capturedPiece)
        }
        whoIsPlaying = whoIsPlaying == .white ? .black : .white
        lastMovedPiece = nil // to cancel just one time
    }
}

// MARK: - Private methods for move and capture

extension Game {

    private func moveAndCapture(_ piece: Pieces, square: Square, updateGame: Bool) -> (valid: Bool, capture: Pieces?) {
        // move piece
        if !piece.setNewPosition(atFile: square.file, andRank: square.rank) { return (false, nil) }
        // check if capture
        let capturedPieceResult = ChessBoard.checkIfCapture(movedPiece: piece)
        // king don't be check after the move
        let attackedByOpponent = ChessBoard.attackedSquaresByPieces(byColor: (piece.color == .white ? .black : .white))
        if let king = ChessBoard.board.first(where: { $0 is King && $0.color == piece.color }) {
            // check if king's square attack by opponent
            if attackedByOpponent.contains(where: { $0.key == king.square }) {
                piece.cancelLastMove()
                // put the captured piece back on the board
                ChessBoard.add(capturedPieceResult)
                return (false, nil)
            }
            if updateGame { setKingState(king: king, state: .isFree) }
        }
        // move is validate, save for later if cancel
        lastMovedPiece = piece
        // check if promotion
        if pauseIfWaitingPromotion(pawn: piece, atSquare: square) {
            return (true, capturedPieceResult)
        }
        // check if castling
        lastMovedRookIfCastling = ChessBoard.checkIfCastling(piece, square: square)
        // update game
        if updateGame {
            updateGameAfterMove(playerColor: piece.color, attackedByOpponent: attackedByOpponent)
        }
        return (true, capturedPieceResult)
    }
}

// MARK: - Private methods for promotion

extension Game {

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
        if let opponentKing = ChessBoard.board.first(where: { $0 is King && $0.color == opponent }) {
            // get attacked squares by player
            let attackedByPlayer = ChessBoard.attackedSquaresByPieces(byColor: playerColor)
            // verify if checkmate
            if checkmate(opponentKing: opponentKing, attackedByPlayer: attackedByPlayer,
                         attackedByOpponent: attackedByOpponent) { return }
            // verify if stalemate
            if ChessBoard.stalemate(opponentKing: opponentKing, attackedByPlayer: attackedByPlayer) {
                gameIsDraw()
                return
            }
        }
        // verify if draw by repetition
        if ChessBoard.savePositionAndCheckIfdrawByRepetition() {
            gameIsDraw()
            return
        }
        whoIsPlaying = whoIsPlaying == .white ? .black : .white
    }
}

// MARK: - Private methods for checkmate or draw

extension Game {

    private func checkmate(opponentKing: Pieces, attackedByPlayer: [Square: [Pieces]],
                           attackedByOpponent: [Square: [Pieces]]) -> Bool {
        // get player pieces that attack opponent king
        guard let playerPiecesAttackOppKing = attackedByPlayer[opponentKing.square] else {
            setKingState(king: opponentKing, state: .isFree)
            return false
        }
        setKingState(king: opponentKing, state: .isCheck)
        if playerPiecesAttackOppKing.count == 1 {
            // one piece attack opponent king, verify if opponent can capture this piece to avoid checkmate
            let playerPiece = playerPiecesAttackOppKing[0]
            if let oppPieces = attackedByOpponent[playerPiece.square] {
                if validAttackToAvoidMate(playerPiece: playerPiece, oppPieces: oppPieces) { return false }
            }
            // verify if opponent can protect king to save checkmate
            let defendedSquares = ChessBoard.defendedSquares(byColor: (whoIsPlaying == .white ? .black : .white))
            let emptySquares = ChessBoard.emptySquaresBetween(opponentKing, and: playerPiece)
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
            // put the captured piece back on the board
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
            // put the captured piece back on the board
            ChessBoard.add(move.capture)
            return false
        }
        gameIsWin(opponentKing: opponentKing)
        return true
    }

    private func gameIsWin(opponentKing: Pieces) {
        if let playerColor = whoIsPlaying {
            let winner = playerColor == .white ? whoPlayWithWhite : whoPlayWithWhite == .one ? .two : .one
            scores[winner]! += 2
            gameState = .isOver
            whoIsPlaying = nil
            setKingState(king: opponentKing, state: .isCheckmate)
        }
    }

    private func gameIsDraw() {
        scores[.one]! += 1
        scores[.two]! += 1
        gameState = .isOver
        whoIsPlaying = nil
    }

    private func setKingState(king: Pieces, state: KingState) {
        switch king.color {
        case .white:
            whiteKing = (ChessBoard.posToInt(file: king.currentFile, rank: king.currentRank), state)
        case .black:
            blackKing = (ChessBoard.posToInt(file: king.currentFile, rank: king.currentRank), state)
        }
    }
}
