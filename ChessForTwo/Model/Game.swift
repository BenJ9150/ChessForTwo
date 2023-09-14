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

final class Game {

    // MARK: - Public properties

    let names: [Player: String]

    var boardCount: Int {
        return board.count
    }

    var capturedPiecesCount: Int {
        return capturedPieces.count
    }

    // MARK: - Private properties

    private var scores = [Player.one: 0, Player.two: 0]
    private var board: [ChessBoard: Piece] = [:]
    private var capturedPieces: [Piece] = []

    // MARK: - Init

    init(playerOne: String, playerTwo: String) {
        self.names = [Player.one: playerOne, Player.two: playerTwo]
        initPieces()
    }
}

// MARK: - Public methods

extension Game {

    func score(ofPlayer player: Player) -> Int {
        return scores[player]!
    }

    func incrementScore(forPlayer player: Player) {
        scores[player]! += 1
    }

    func restart() {
        scores[.one] = 0
        scores[.two] = 0
    }

    func piece(atFile file: Int, andRank rank: Int) -> Piece? {
        return board[ChessBoard(file: file, rank: rank)]
    }

    func movePiece(from: (file: Int, rank: Int), toPos: (file: Int, rank: Int)) -> Bool {
        // coordinates
        let startingPos = ChessBoard(file: from.file, rank: from.rank)
        let endingPos = ChessBoard(file: toPos.file, rank: toPos.rank)

        // get piece at start
        guard let movedPiece = board[startingPos] else { return false }

        // check if capture
        if let capturedPiece = board[endingPos] {
            if capturedPiece.color == movedPiece.color { return false }
            // capture
            if !movedPiece.setNewPosition(atFile: toPos.file, andRank: toPos.rank, capture: true) { return false }
            // stock captured piece
            capturedPieces.append(capturedPiece)
        } else {
            // no capture
            if !movedPiece.setNewPosition(atFile: toPos.file, andRank: toPos.rank, capture: false) { return false }
        }

        // change pieces position
        board[endingPos] = movedPiece
        board.removeValue(forKey: startingPos)
        return true
    }
}

// MARK: - Private Init methods

extension Game {

    private func initPieces() {
        board.removeAll()
        initPawns()
        initRooks()
        initKnights()
        initBishops()
        initQueens()
        initKings()
    }

    private func initPawns() {
        for (file, whiteRank, blackRank) in Pawn.initialPos {
            // white
            let white = Pawn(initialFile: file, initialRank: whiteRank, color: .white)
            board[ChessBoard(file: file, rank: whiteRank)] = white
            // black
            let black = Pawn(initialFile: file, initialRank: blackRank, color: .black)
            board[ChessBoard(file: file, rank: blackRank)] = black
        }
    }

    private func initRooks() {
        for (file, whiteRank, blackRank) in Rook.initialPos {
            // white
            let white = Rook(initialFile: file, initialRank: whiteRank, color: .white)
            board[ChessBoard(file: file, rank: whiteRank)] = white
            // black
            let black = Rook(initialFile: file, initialRank: blackRank, color: .black)
            board[ChessBoard(file: file, rank: blackRank)] = black
        }
    }

    private func initKnights() {
        for (file, whiteRank, blackRank) in Knight.initialPos {
            // white
            let white = Knight(initialFile: file, initialRank: whiteRank, color: .white)
            board[ChessBoard(file: file, rank: whiteRank)] = white
            // black
            let black = Knight(initialFile: file, initialRank: blackRank, color: .black)
            board[ChessBoard(file: file, rank: blackRank)] = black
        }
    }

    private func initBishops() {
        for (file, whiteRank, blackRank) in Bishop.initialPos {
            // white
            let white = Bishop(initialFile: file, initialRank: whiteRank, color: .white)
            board[ChessBoard(file: file, rank: whiteRank)] = white
            // black
            let black = Bishop(initialFile: file, initialRank: blackRank, color: .black)
            board[ChessBoard(file: file, rank: blackRank)] = black
        }
    }

    private func initQueens() {
        for (file, whiteRank, blackRank) in Queen.initialPos {
            // white
            let white = Queen(initialFile: file, initialRank: whiteRank, color: .white)
            board[ChessBoard(file: file, rank: whiteRank)] = white
            // black
            let black = Queen(initialFile: file, initialRank: blackRank, color: .black)
            board[ChessBoard(file: file, rank: blackRank)] = black
        }
    }

    private func initKings() {
        for (file, whiteRank, blackRank) in King.initialPos {
            // white
            let white = King(initialFile: file, initialRank: whiteRank, color: .white)
            board[ChessBoard(file: file, rank: whiteRank)] = white
            // black
            let black = King(initialFile: file, initialRank: blackRank, color: .black)
            board[ChessBoard(file: file, rank: blackRank)] = black
        }
    }
}
