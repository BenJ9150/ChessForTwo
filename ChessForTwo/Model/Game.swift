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
}

// MARK: - Private methods for move

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

        // update game after move is finish and validate
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
        // check capture in passing
        if movedPiece is Pawn && movedPiece.oldFile != movedPiece.currentFile {
            // it's a pawn that has moved on diagonal in empty case: capture in passing
            let posOfCapPiece = Square(file: movedPiece.currentFile, rank: movedPiece.oldRank)
            if let capPieceInPass = ChessBoard.piece(atPosition: posOfCapPiece), capPieceInPass is Pawn {
                ChessBoard.remove(capPieceInPass)
                return capPieceInPass
            }
        }
        return nil
    }

    private func notifyCapturedPiece(_ capturedPiece: Pieces) {
        // get position in Int for notif
        let positionToInt = ChessBoard.posToInt(file: capturedPiece.currentFile, rank: capturedPiece.currentRank)
        NotificationCenter.default.post(name: .capturedPieceAtPosition, object: positionToInt)
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
        if savePositionAndCheckIfDrawByRepetition() { return }

        // change who is playing
        whoIsPlaying = whoIsPlaying == .white ? .black : .white
    }

    private func checkmate(opponentKing: Pieces, attackedByPlayer: [Square: [Pieces]],
                           attackedByOpponent: [Square: [Pieces]]) -> Bool {
        // get player pieces that attack opponent king
        if let playerPiecesAttackOppKing = attackedByPlayer[opponentKing.square] {
            if playerPiecesAttackOppKing.count > 1 {
                // to much pieces attack opponent king, checkmate!
                return true
            }
            // one piece attack opponent king, verify if opponent can capture this piece to avoid checkmate
            let playerPiece = playerPiecesAttackOppKing[0]
            if let oppPieces = attackedByOpponent[playerPiece.square] {
                if validAttackToAvoidMate(playerPiece: playerPiece, oppPieces: oppPieces) { return false }
            }
            // verify if opponent can protect king to save checkmate
            let defendedSquares = ChessBoard.defendedSquares(byColor: (whoIsPlaying == .white ? .black : .white))
            let emptySquares = ValidMoves.emptySquaresBetween(opponentKing, and: playerPiece)
            for square in emptySquares {
                if let pieces = defendedSquares[square] {
                    for piece in pieces where type(of: piece) != type(of: King()) {
                        return false
                    }
                }
            }
        } else {
            // opponent King is not check
            return false
        }

        // check if opponent King can move, mat if not
        let oppKingMoves = opponentKing.getValidMoves()
        if oppKingMoves.count <= 0 {
            gameWinByColor()
            return true
        }

        // check if there is one possible move or attack for opponent king
        for endSquare in oppKingMoves {
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
        /*
        // check if all opponent King moves are attacked, mat if true
        for square in oppKingMoves where !attackedByPlayer.contains(where: { $0.key == square }) {
            return false
        }*/
        gameWinByColor()
        return true
    }

    private func validAttackToAvoidMate(playerPiece: Pieces, oppPieces: [Pieces]) -> Bool {
        // get opponent pieces that attack player piece
        if oppPieces.count <= 0 { return false }

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

        // check if opponent King can move, if not: stalemate
        let oppKingMoves = opponentKing.getValidMoves()
        if oppKingMoves.count <= 0 {
            thatIsDraw()
            return true
        }

        // check if all opponent King moves are attacked, stalemate if true
        for square in oppKingMoves where !attackedByPlayer.contains(where: { $0.key == square }) {
            return false
        }
        thatIsDraw()
        return true
    }

    private func thatIsDraw() {
        // increment score
        scores[.one]! += 1
        scores[.two]! += 1
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
            thatIsDraw()
            return true
        }
        return false
    }
}
