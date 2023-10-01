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
    private var savedPositions: [String] = []

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
        savedPositions.removeAll()
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
        if let isCheck = isCheck(whoIsPlaying: playerColor, movedPiece: movedPiece), isCheck { return false }

        // check if capture
        checkIfCapture(movedPiece: movedPiece, startPos: startSquare, endPos: endSquare)

        // change pieces position in board
        ChessBoard.moveAfterSetPosition(piece: movedPiece)

        // check if opponent is checkmate or stalemate
        if let opponentKingSquare = ChessBoard.getKingSquare(color: (playerColor == .white ? .black : .white)) {
            let attackedSquares = ChessBoard.attackedSquares(byColor: playerColor)
            if let opponentKing = ChessBoard.piece(atPosition: opponentKingSquare) {
                // check if stalemate
                if checkmate(colorPlay: playerColor, attack: attackedSquares,
                             opponentKing: opponentKing, isAtSquare: opponentKingSquare) { return true }
                // check if stalemate
                if stalemate(colorPlay: playerColor, attack: attackedSquares,
                             opponentKing: opponentKing, isAtSquare: opponentKingSquare) { return true }
            }
        }

        // check if draw by repetition
        if savePositionAndCheckIfDrawByRepetition() { return true }

        // change who is playing
        whoIsPlaying = whoIsPlaying == .white ? .black : .white
        return true
    }
}

// MARK: - Private methods

extension Game {

    private func draw() {
        // increment score
        scores[.one]! += 1
        scores[.two]! += 1
        gameState = .isOver
        whoIsPlaying = nil
    }

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

    private func savePositionAndCheckIfDrawByRepetition() -> Bool {
        // get current position
        var position: [String] = []
        for piece in ChessBoard.allPieces() {
            position.append("\(piece.color)\(type(of: piece))\(piece.currentFile)\(piece.currentRank);")
        }
        position.sort()
        // current position to one string
        var stringPosition = ""
        for value in position {
            stringPosition += value
        }
        // add current position to saved positions
        savedPositions.append(stringPosition)

        // check if 3 repetitions
        let countedSet = NSCountedSet(array: savedPositions)
        for value in countedSet where countedSet.count(for: value) == 3 {
            draw()
            return true
        }
        return false
    }

    private func stalemate(colorPlay: PieceColor, attack: [Square],
                           opponentKing: Pieces, isAtSquare opponentKingSquare: Square) -> Bool {

        // DIFF : check if all pieces of opponent can't move (except the king)
        let opponentPieces = ChessBoard.allPiecesOfColor((colorPlay == .white ? .black : .white))
        var opponentPiecesMoves: [Square] = []
        for piece in opponentPieces {
            if piece is King { continue }
            if piece is Pawn {
                opponentPiecesMoves.append(contentsOf: piece.getOtherValidMoves()) // move up
            } else {
                opponentPiecesMoves.append(contentsOf: piece.getAttackedSquares())
            }
        }
        if opponentPiecesMoves.count > 0 { return false }

        // check if opponent King is check
        if attack.contains(opponentKingSquare) { return false } // DIFF

        // check if opponent King can move, if not: stalemate
        let oppKingMoves = opponentKing.getAttackedSquares()
        if oppKingMoves.count <= 0 {
            draw() // DIFF
            return true
        }

        // check if all opponent King moves are attacked, stalemate if true
        for square in oppKingMoves where !attack.contains(square) {
            return false
        }
        draw() // DIFF
        return true
    }

    private func checkmate(colorPlay: PieceColor, attack: [Square],
                           opponentKing: Pieces, isAtSquare opponentKingSquare: Square) -> Bool {

        // check if opponent King is check
        if !attack.contains(opponentKingSquare) { return false }

        // check if opponent King can move, mat if not
        let oppKingMoves = opponentKing.getAttackedSquares()
        if oppKingMoves.count <= 0 {
            gameWinByColor(colorPlay)
            return true
        }

        // check if all opponent King moves are attacked, mat if true
        for square in oppKingMoves where !attack.contains(square) {
            return false
        }
        gameWinByColor(colorPlay)
        return true
    }

    private func isCheck(whoIsPlaying: PieceColor, movedPiece: Pieces) -> Bool? {
        // get king square
        guard let kingSquare = ChessBoard.getKingSquare(color: whoIsPlaying) else { return nil }
        // get attacked position
        let attackedSquaresByOpponent = ChessBoard.attackedSquares(byColor: (whoIsPlaying == .white ? .black : .white))
        // check if King is attacked
        if attackedSquaresByOpponent.contains(kingSquare) {
            movedPiece.cancelLastMove()
            return true
        }
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
