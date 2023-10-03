//
//  ChessBoard.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

struct Square: Hashable {

    var file: Int
    var rank: Int
}

struct ChessBoard {

    // MARK: - Public static properties

    static var movesCount = 0
    static let minPosition = 1
    static let maxPosition = 8

    static var chessboard: [Square: Pieces] {
        get {
            return safeChessboard
        } set {
            boardSemaphore.wait()
            safeChessboard = newValue
            boardSemaphore.signal()
        }
    }

    static var capturedPieces: [Pieces] {
        get {
            return safeCapturedPieces
        } set {
            captureSemaphore.wait()
            safeCapturedPieces = newValue
            captureSemaphore.signal()
        }
    }

    // MARK: - Private properties

    private static let boardSemaphore = DispatchSemaphore(value: 1)
    private static var safeChessboard: [Square: Pieces] = [:]
    private static let captureSemaphore = DispatchSemaphore(value: 1)
    private static var safeCapturedPieces: [Pieces] = []
    private static let startingRank = [0, 8, 16, 24, 32, 40, 48, 56]
    private static var savedPositions: [String] = []
}

// MARK: - Init Chessboard

extension ChessBoard {

    static func initChessBoard() {
        movesCount = 0
        chessboard.removeAll()
        capturedPieces.removeAll()
        savedPositions.removeAll()
        initPiecesType(Pawn())
        initPiecesType(Rook())
        initPiecesType(Knight())
        initPiecesType(Bishop())
        initPiecesType(Queen())
        initPiecesType(King())
    }

    private static func initPiecesType<T: Pieces>(_: T) {
        for (file, whiteRank) in T.initialWhitePos {
            // get black rank
            let blackRank = maxPosition + 1 - whiteRank
            // white
            add(T(initialFile: file, initialRank: whiteRank, color: .white))
            // black
            add(T(initialFile: file, initialRank: blackRank, color: .black))
        }
    }
}

// MARK: - draw by repetition

extension ChessBoard {

    static func savePositionAndCheckIfdrawByRepetition() -> Bool {
        // get current position
        var position: [String] = []
        for piece in allPieces() {
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
            return true
        }
        return false
    }
}

// MARK: - piece edition

extension ChessBoard {

    static func add(_ piece: Pieces?) {
        guard let newPiece = piece else { return }
        chessboard[newPiece.square] = newPiece
    }

    static func piece(atPosition position: Square) -> Pieces? {
        return chessboard[position]
    }

    static func isEmpty(atPosition position: Square) -> Bool {
        return chessboard[position] == nil ? true : false
    }

    static func moveAfterSetPosition(piece: Pieces) {
        chessboard[piece.square] = piece
        chessboard.removeValue(forKey: Square(file: piece.oldFile, rank: piece.oldRank))
    }

    static func remove(_ piece: Pieces?) {
        if let removedPiece = piece {
            chessboard.removeValue(forKey: removedPiece.square)
        }
    }

    static func removePiece(atSquare square: Square) {
        chessboard.removeValue(forKey: square)
    }

    static func addToCapturedPieces(_ capturedPiece: Pieces) {
        capturedPieces.append(capturedPiece)
    }

    static func allPieces() -> [Pieces] {
        return chessboard.map({ $0.1 })
    }

    static func allPiecesOfColor(_ color: PieceColor) -> [Pieces] {
        var pieces: [Pieces] = []
        for piece in allPieces() where piece.color == color {
            pieces.append(piece)
        }
        return pieces
    }

    static func removeAllPieces() {
        chessboard.removeAll()
        savedPositions.removeAll()
    }

    static func allCapturedPieces() -> [Pieces] {
        return capturedPieces
    }
}

// MARK: - Convert position

extension ChessBoard {

    static func posToInt(file: Int, rank: Int) -> Int {
        return file - 1 + (rank - 1) * maxPosition
    }

    static func intToSquare(_ int: Int) -> Square {
        if int == 0 { return Square(file: 1, rank: 1) }
        // get rank
        let rank: Int
        if let optRank = startingRank.firstIndex(where: { $0 > int }) {
            rank = optRank
        } else {
            // up to 56
            rank = 8
        }
        // get file
        let file = int - (rank - 1) * maxPosition + 1
        return Square(file: file, rank: rank)
    }
}

// MARK: - Attaqued position

extension ChessBoard {

    static func defendedSquares(byColor color: PieceColor) -> [Square: [Pieces]] {
        var attackedSquares: [Square: [Pieces]] = [:]
        let pieces = allPiecesOfColor(color)
        // check attacked squares for each pieces
        for piece in pieces {
            let attackedSquaresByPiece: [Square]
            if piece is Pawn {
                attackedSquaresByPiece = piece.getValidMoves()
            } else {
                attackedSquaresByPiece = piece.getAttackedSquares()
            }
            // add squares to result
            for square in attackedSquaresByPiece {
                if attackedSquares.contains(where: { $0.key == square }) {
                    attackedSquares[square]?.append(piece)
                } else {
                    attackedSquares[square] = [piece]
                }
            }
        }
        return attackedSquares
    }

    static func attackedSquaresByPieces(byColor color: PieceColor) -> [Square: [Pieces]] {
        var attackedSquares: [Square: [Pieces]] = [:]
        let pieces = allPiecesOfColor(color)
        // check attacked squares for each pieces
        for piece in pieces {
            let attackedSquaresByPiece = piece.getAttackedSquares()
            // add squares to result
            for square in attackedSquaresByPiece {
                if attackedSquares.contains(where: { $0.key == square }) {
                    attackedSquares[square]?.append(piece)
                } else {
                    attackedSquares[square] = [piece]
                }
            }
        }
        return attackedSquares
    }

    static func attackedSquares(byColor color: PieceColor) -> [Square] {
        var attackedSquares: [Square] = []
        let pieces = allPiecesOfColor(color)
        // check attacked squares for each pieces
        for piece in pieces {
            attackedSquares.append(contentsOf: piece.getAttackedSquares())
        }
        return attackedSquares
    }
}
