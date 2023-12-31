//
//  ChessBoard.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation
import UIKit

struct Square: Hashable {

    var file: Int
    var rank: Int
}

struct ChessBoard {

    // MARK: - Public static properties

    static var movesCount = 0
    static let minPosition = 1
    static let maxPosition = 8

    static var board: [Pieces] {
        get {
            return safeBoard
        } set {
            boardSemaphore.wait()
            safeBoard = newValue
            boardSemaphore.signal()
        }
    }

    static var whitePiecesCaptured: [Pieces] {
        return whiteCaptured
    }

    static var blackPiecesCaptured: [Pieces] {
        return blackCaptured
    }

    // MARK: - Private properties

    private static let boardSemaphore = DispatchSemaphore(value: 1)
    private static var safeBoard: [Pieces] = []
    private static var whiteCaptured: [Pieces] = []
    private static var blackCaptured: [Pieces] = []
    private static let startingRank = [0, 8, 16, 24, 32, 40, 48, 56]
    private static var savedPositions: [String] = []
}

// MARK: - Init Chessboard

extension ChessBoard {

    static func initChessBoard() {
        movesCount = 0
        board.removeAll()
        whiteCaptured.removeAll()
        blackCaptured.removeAll()
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

// MARK: - Capture

extension ChessBoard {

    static func checkIfCapture(movedPiece: Pieces) -> (piece: Pieces?, inPassing: Bool) {
        let opponentColor: PieceColor = movedPiece.color == .white ? .black : .white
        if let capturedPiece = piece(atPosition: movedPiece.square, ofColor: opponentColor) {
            remove(capturedPiece)
            return (capturedPiece, false)
        }
        // check if capture in passing for pawn
        if type(of: movedPiece) != type(of: Pawn()) || movedPiece.oldFile == movedPiece.currentFile {
            return (nil, false)
        }
        // it's a pawn that has moved on diagonal in empty case: capture in passing
        let posOfCapPiece = Square(file: movedPiece.currentFile, rank: movedPiece.oldRank)
        let capPieceInPass = piece(atPosition: posOfCapPiece, ofColor: opponentColor)
        remove(capPieceInPass)
        return (capPieceInPass, true)
    }

    static func notifyCapturedPiece(_ capturedPiece: Pieces, inPassing: Bool) {
        // get position in Int for notif
        let positionToInt = posToInt(file: capturedPiece.currentFile, rank: capturedPiece.currentRank)
        NotificationCenter.default.post(name: .capture, object: (positionToInt, inPassing))
    }
}

// MARK: - Castling

extension ChessBoard {

    static func checkIfCastling(king: Pieces) -> Pieces? {
        if type(of: king) != type(of: King()) { return nil }
        // check if big castling
        if king.currentFile - king.oldFile == -2 {
            return castling(king, startRookFile: 1, endRookFile: 4)
        }
        // check if little castling
        if king.currentFile - king.oldFile == 2 {
            return castling(king, startRookFile: 8, endRookFile: 6)
        }
        return nil
    }

    private static func castling(_ king: Pieces, startRookFile: Int, endRookFile: Int) -> Pieces? {
        // remove king of board to move rook
        remove(king)
        // move rook (safe, already test in King class)
        let rook = piece(atPosition: Square(file: startRookFile, rank: king.currentRank), ofColor: king.color)!
        _ = rook.setNewPosition(atFile: endRookFile, andRank: king.currentRank)
        // add king after rook move
        add(king)
        // notify controller
        let startingSq = posToInt(file: rook.oldFile, rank: rook.oldRank)
        let endingSq = posToInt(file: rook.currentFile, rank: rook.currentRank)
        NotificationCenter.default.post(name: .castling, object: (start: startingSq, end: endingSq))
        return rook
    }
}

// MARK: - Draw

extension ChessBoard {

    static func stalemate(opponentKing: Pieces, attackedByPlayer: [Square: [Pieces]]) -> Bool {
        // check if all pieces of opponent can't move (except the king)
        let opponentPieces = ChessBoard.allPiecesOfColor(opponentKing.color)
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
        return true
    }

    static func savePositionAndCheckIfdrawByRepetition() -> Bool {
        // get current position
        var position: [String] = []
        for piece in board {
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
        board.append(newPiece)
    }

    static func piece(atPosition position: Square) -> Pieces? {
        if let index = board.firstIndex(where: { $0.square == position }), index < board.count {
            return board[index]
        }
        return nil
    }

    static func piece(atPosition position: Square, ofColor color: PieceColor?) -> Pieces? {
        guard let pieceColor = color else { return nil }
        if let index = board.firstIndex(where: { $0.square == position
            && $0.color == pieceColor }), index < board.count {
            return board[index]
        }
        return nil
    }

    static func isEmpty(atPosition position: Square) -> Bool {
        if let index = board.firstIndex(where: { $0.square == position }), index < board.count {
            return false
        }
        return true
    }

    static func remove(_ piece: Pieces?) {
        if let removedPiece = piece, let index = board.firstIndex(where: { $0.square == removedPiece.square
            && $0.color == removedPiece.color }), index < board.count {
            board.remove(at: index)
        }
    }

    static func addToCapturedPieces(_ capturedPiece: Pieces) {
        switch capturedPiece.color {
        case .white:
            if capturedPiece is Pawn {
                whiteCaptured.insert(capturedPiece, at: 0)
            } else {
                whiteCaptured.append(capturedPiece)
            }
        case .black:
            if capturedPiece is Pawn {
                blackCaptured.insert(capturedPiece, at: 0)
            } else {
                blackCaptured.append(capturedPiece)
            }
        }
    }

    static func removeFromCapturedPieces(_ capturedPiece: Pieces) {
        switch capturedPiece.color {
        case .white:
            if let index = whiteCaptured.firstIndex(where: { $0.square == capturedPiece.square }),
               index < whiteCaptured.count {
                whiteCaptured.remove(at: index)
            }
        case .black:
            if let index = blackCaptured.firstIndex(where: { $0.square == capturedPiece.square }),
               index < blackCaptured.count {
                blackCaptured.remove(at: index)
            }
        }
    }

    static func allPiecesOfColor(_ color: PieceColor) -> [Pieces] {
        var pieces: [Pieces] = []
        for piece in board where piece.color == color {
            pieces.append(piece)
        }
        return pieces
    }

    static func removeAllPieces() {
        board.removeAll()
        savedPositions.removeAll()
    }

    static func rotatePiece(image: UIImage?) -> UIImage? {
        // save name before modification
        let imageName = image?.imageAsset?.value(forKey: UIImage.imageNameKey)
        let newImage = image?.rotate()
        // change name
        newImage?.imageAsset?.setValue(imageName, forKey: UIImage.imageNameKey)
        return newImage
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
        // check attacked squares for each pieces
        for piece in allPiecesOfColor(color) {
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
        // check attacked squares for each pieces
        for piece in allPiecesOfColor(color) {
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
        // check attacked squares for each pieces
        for piece in allPiecesOfColor(color) {
            attackedSquares.append(contentsOf: piece.getAttackedSquares())
        }
        return attackedSquares
    }
}
