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
    var board: [ChessBoard: Piece] = [:]
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
        initPieces()
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

    func movePiece(fromInt start: Int, toInt end: Int) -> (isValid: Bool, capture: Bool) {
        // good player
        guard let playerColor = whoIsPlaying else { return (false, false) }

        // coordinates
        let start = ChessBoard.intToPos(start)
        let end = ChessBoard.intToPos(end)
        let startingPos = ChessBoard(file: start.file, rank: start.rank)
        let endingPos = ChessBoard(file: end.file, rank: end.rank)

        // get piece at start
        guard let movedPiece = board[startingPos] else { return (false, false) }

        // check good color
        if movedPiece.color != playerColor { return (false, false) }

        // check if not over piece
        if checkIfGoneOverPiece(movedPiece: movedPiece, startPos: startingPos, endPos: endingPos) {
            return (false, false)
        }

        // check if capture
        let captureResult = checkIfCapture(movedPiece: movedPiece, AtEndPos: endingPos)
        if !captureResult.isValid { return (false, false) }

        // move piece
        if !movedPiece.setNewPosition(atFile: endingPos.file, andRank: endingPos.rank, capture: captureResult.capture) {
            return (false, false)
        }

        // change pieces position in board
        board[endingPos] = movedPiece
        board.removeValue(forKey: startingPos)

        // change who is playing
        if whoIsPlaying == .white {
            whoIsPlaying = .black
        } else {
            whoIsPlaying = .white
        }
        return captureResult
    }
}

// MARK: - Private methods

extension Game {

    private func checkIfCapture(movedPiece: Piece, AtEndPos endPos: ChessBoard) -> (isValid: Bool, capture: Bool) {
        if let capturedPiece = board[endPos] {
            if capturedPiece.color == movedPiece.color { return (false, false) }
            // capture, stock captured piece
            capturedPieces.append(capturedPiece)
            return (true, true)
        }
        // no capture
        return (true, false)
    }

    private func checkIfGoneOverPiece(movedPiece: Piece, startPos: ChessBoard, endPos: ChessBoard) -> Bool {
        if movedPiece is Knight { return false }

        let rankRange = getRangeOfMove(startPos: startPos.rank, endPos: endPos.rank)
        let fileRange = getRangeOfMove(startPos: startPos.file, endPos: endPos.file)

        // check if is a vertical move
        if fileRange.count <= 0 {
            for rank in rankRange where board[ChessBoard(file: startPos.file, rank: rank)] != nil {
                return true
            }
        }
        // check if is an horizontal move
        if rankRange.count <= 0 {
            for file in fileRange where board[ChessBoard(file: file, rank: startPos.rank)] != nil {
                return true
            }
        }
        // diagonal move
        var fileIndex = 0
        for rank in rankRange {
            if fileIndex >= fileRange.count { continue }
            if board[ChessBoard(file: fileRange[fileIndex], rank: rank)] != nil {
                return true
            }
            fileIndex += 1
        }
        return false
    }

    private func getRangeOfMove(startPos: Int, endPos: Int) -> [Int] {
        var result: [Int] = []
        if startPos == endPos {
            return result
        }
        let range: Range<Int>
        if startPos < endPos {
            range =  startPos + 1..<endPos
        } else {
            range = endPos + 1..<startPos
        }
        for value in range {
            result.append(value)
        }
        return result
    }

    private func initPieces() {
        board.removeAll()
        initPiecesType(Pawn())
        initPiecesType(Rook())
        initPiecesType(Knight())
        initPiecesType(Bishop())
        initPiecesType(Queen())
        initPiecesType(King())
    }

    private func initPiecesType<T: Piece>(_: T) {
        for (file, whiteRank) in T.initialWhitePos {
            // get black rank
            let blackRank = ChessBoard.maxPosition + 1 - whiteRank
            // white
            let white = T(initialFile: file, initialRank: whiteRank, color: .white)
            board[ChessBoard(file: file, rank: whiteRank)] = white
            // black
            let black = T(initialFile: file, initialRank: blackRank, color: .black)
            board[ChessBoard(file: file, rank: blackRank)] = black
        }
    }
}
