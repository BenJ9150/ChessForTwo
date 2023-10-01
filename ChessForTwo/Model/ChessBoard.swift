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

class ChessBoard {

    // MARK: - Public static properties

    static var movesCount = 0
    static let minPosition = 1
    static let maxPosition = 8

    // MARK: - Private properties

    private static let boardSemaphore = DispatchSemaphore(value: 1)
    private static var safeChessboard: [Square: Pieces] = [:]

    private static var chessboard: [Square: Pieces] {
        get {
            return safeChessboard
        } set {
            boardSemaphore.wait()
            safeChessboard = newValue
            boardSemaphore.signal()
        }
    }

    private static let captureSemaphore = DispatchSemaphore(value: 1)
    private static var safeCapturedPieces: [Pieces] = []

    private static var capturedPieces: [Pieces] {
        get {
            return safeCapturedPieces
        } set {
            captureSemaphore.wait()
            safeCapturedPieces = newValue
            captureSemaphore.signal()
        }
    }

    private static let startingRank = [0, 8, 16, 24, 32, 40, 48, 56]
}

// MARK: - Init Chessboard

extension ChessBoard {

    static func initChessBoard() {
        movesCount = 0
        chessboard.removeAll()
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
            let white = T(initialFile: file, initialRank: whiteRank, color: .white)
            chessboard[Square(file: file, rank: whiteRank)] = white
            // black
            let black = T(initialFile: file, initialRank: blackRank, color: .black)
            chessboard[Square(file: file, rank: blackRank)] = black
        }
    }
}

// MARK: - piece edition

extension ChessBoard {

    static func add(piece: Pieces, atPosition position: Square) {
        chessboard[position] = piece
    }

    static func piece(atPosition position: Square) -> Pieces? {
        return chessboard[position]
    }

    static func isEmpty(atPosition position: Square) -> Bool {
        return chessboard[position] == nil ? true : false
    }

    static func moveAfterSetPosition(piece: Pieces) {
        chessboard[Square(file: piece.currentFile, rank: piece.currentRank)] = piece
        chessboard.removeValue(forKey: Square(file: piece.oldFile, rank: piece.oldRank))
    }

    static func remove(capturedPiece: Pieces, atPosition position: Square) {
        capturedPieces.append(capturedPiece)
        chessboard.removeValue(forKey: position)
    }

    static func allPieces() -> [Pieces] {
        return chessboard.map({ $0.1 })
    }

    static func removeAllPieces() {
        chessboard.removeAll()
    }

    static func allCapturedPieces() -> [Pieces] {
        return capturedPieces
    }

    static func getKingSquare(color: PieceColor) -> Square? {
        guard let element = chessboard.first(where: { $0.value is King && $0.value.color == color }) else {
            return nil
        }
        return Square(file: element.value.currentFile, rank: element.value.currentRank)
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

    static func attackedSquares(byColor color: PieceColor) -> [Square] {
        var attackPos: [Square] = []
        let pieces = allPieces()
        switch color {
        case .white:
            for piece in pieces where piece.color == .white {
                attackPos.append(contentsOf: piece.getAttackedSquares())
            }
        case .black:
            for piece in pieces where piece.color == .black {
                attackPos.append(contentsOf: piece.getAttackedSquares())
            }
        }
        return attackPos
    }
}

// MARK: - Valid moves: diagonal

extension ChessBoard {

    static func validUpLeft(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if rank < maxPosition && file > minPosition {
            var rankIndex = rank + 1
            var fileIndex = file - 1

            while rankIndex <= maxPosition && fileIndex >= minPosition {
                let chessBoard = Square(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = chessboard[chessBoard] {
                    if piece.color != color { validMoves.append(chessBoard) }
                    break
                }
                // empty square, add and continue
                validMoves.append(chessBoard)
                rankIndex += 1
                fileIndex -= 1
            }
        }
        return validMoves
    }

    static func validDownRight(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if rank > minPosition && file < maxPosition {
            var rankIndex = rank - 1
            var fileIndex = file + 1

            while rankIndex >= minPosition && fileIndex <= maxPosition {
                let chessBoard = Square(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = chessboard[chessBoard] {
                    if piece.color != color { validMoves.append(chessBoard) }
                    break
                }
                // empty square, add and continue
                validMoves.append(chessBoard)
                rankIndex -= 1
                fileIndex += 1
            }
        }
        return validMoves
    }

    static func validUpRight(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if rank < maxPosition && file < maxPosition {
            var rankIndex = rank + 1
            var fileIndex = file + 1

            while rankIndex <= maxPosition && fileIndex <= maxPosition {
                let chessBoard = Square(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = chessboard[chessBoard] {
                    if piece.color != color { validMoves.append(chessBoard) }
                    break
                }
                // empty square, add and continue
                validMoves.append(chessBoard)
                rankIndex += 1
                fileIndex += 1
            }
        }
        return validMoves
    }

    static func validDownLeft(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if rank > minPosition && file > minPosition {
            var rankIndex = rank - 1
            var fileIndex = file - 1

            while rankIndex >= minPosition && fileIndex >= minPosition {
                let chessBoard = Square(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = chessboard[chessBoard] {
                    if piece.color != color { validMoves.append(chessBoard) }
                    break
                }
                // empty square, add and continue
                validMoves.append(chessBoard)
                rankIndex -= 1
                fileIndex -= 1
            }
        }
        return validMoves
    }
}

// MARK: - Valid moves: vertical

extension ChessBoard {
    static func validUp(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if rank < maxPosition {
            var index = rank + 1

            while index <= maxPosition {
                let chessBoard = Square(file: file, rank: index)
                // check if there is a piece
                if let piece = chessboard[chessBoard] {
                    if piece.color != color { validMoves.append(chessBoard) }
                    break
                }
                // empty square, add and continue
                validMoves.append(chessBoard)
                index += 1
            }
        }
        return validMoves
    }

    static func validRight(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if file < maxPosition {
            var index = file + 1

            while index <= maxPosition {
                let chessBoard = Square(file: index, rank: rank)
                // check if there is a piece
                if let piece = chessboard[chessBoard] {
                    if piece.color != color { validMoves.append(chessBoard) }
                    break
                }
                // empty square, add and continue
                validMoves.append(chessBoard)
                index += 1
            }
        }
        return validMoves
    }
}

// MARK: - Valid moves: horizontal

extension ChessBoard {
    static func validDown(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if rank > minPosition {
            var index = rank - 1

            while index >= minPosition {
                let chessBoard = Square(file: file, rank: index)
                // check if there is a piece
                if let piece = chessboard[chessBoard] {
                    if piece.color != color { validMoves.append(chessBoard) }
                    break
                }
                // empty square, add and continue
                validMoves.append(chessBoard)
                index -= 1
            }
        }
        return validMoves
    }

    static func validLeft(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if file > minPosition {
            var index = file - 1

            while index >= minPosition {
                let chessBoard = Square(file: index, rank: rank)
                // check if there is a piece
                if let piece = chessboard[chessBoard] {
                    if piece.color != color { validMoves.append(chessBoard) }
                    break
                }
                // empty square, add and continue
                validMoves.append(chessBoard)
                index -= 1
            }
        }
        return validMoves
    }
}
