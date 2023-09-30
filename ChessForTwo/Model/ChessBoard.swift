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
    private static var safeChessboard: [Square: Piece] = [:]

    private static var chessboard: [Square: Piece] {
        get {
            return safeChessboard
        } set {
            boardSemaphore.wait()
            safeChessboard = newValue
            boardSemaphore.signal()
        }
    }

    private static let captureSemaphore = DispatchSemaphore(value: 1)
    private static var safeCapturedPieces: [Piece] = []

    private static var capturedPieces: [Piece] {
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

    private static func initPiecesType<T: Piece>(_: T) {
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

    static func add(piece: Piece, atPosition position: Square) {
        chessboard[position] = piece
    }

    static func piece(atPosition position: Square) -> Piece? {
        return chessboard[position]
    }

    static func isEmpty(atPosition position: Square) -> Bool {
        return chessboard[position] == nil ? true : false
    }

    static func moveAfterSetPosition(piece: Piece) {
        chessboard[Square(file: piece.currentFile, rank: piece.currentRank)] = piece
        chessboard.removeValue(forKey: Square(file: piece.oldFile, rank: piece.oldRank))
    }

    static func remove(capturedPiece: Piece, atPosition position: Square) {
        capturedPieces.append(capturedPiece)
        let result = chessboard.removeValue(forKey: position)
        var test = 10
    }

    static func allPieces() -> [Piece] {
        return chessboard.map({ $0.1 })
    }

    static func removeAllPieces() {
        chessboard.removeAll()
    }

    static func allCapturedPieces() -> [Piece] {
        return capturedPieces
    }
}

// MARK: - Convert position

extension ChessBoard {

    static func posToInt(file: Int, rank: Int) -> Int {
        return file - 1 + (rank - 1) * maxPosition
    }

    static func intToPos(_ int: Int) -> (file: Int, rank: Int) {
        if int == 0 { return (1, 1) }
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
        return (file, rank)
    }
}

// MARK: - Attaqued position

extension ChessBoard {

    static func getAttackedPositions(byColor color: PieceColor) -> [Square] {
        var attackPos: [Square] = []
        let pieces = allPieces()
        switch color {
        case .white:
            for piece in pieces where piece.color == .white {
                attackPos.append(contentsOf: piece.getAllValidMoves())
            }
        case .black:
            for piece in pieces where piece.color == .black {
                attackPos.append(contentsOf: piece.getAllValidMoves())
            }
        }
        return attackPos
    }
}

// MARK: - Valid moves: diagonal

extension ChessBoard {

    static func validUpLeft(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [Square] {
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

    static func validDownRight(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [Square] {
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

    static func validUpRight(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [Square] {
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

    static func validDownLeft(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [Square] {
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
    static func validUp(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [Square] {
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

    static func validRight(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [Square] {
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
    static func validDown(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [Square] {
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

    static func validLeft(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [Square] {
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
