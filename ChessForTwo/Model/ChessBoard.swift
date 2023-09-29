//
//  ChessBoard.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import Foundation

struct ChessBoard: Hashable {

    // MARK: - Public properties

    static var board: [ChessBoard: Piece] = [:]
    var file: Int
    var rank: Int
    static let minPosition = 1
    static let maxPosition = 8

    // MARK: - Private properties

    private static let startingRank = [0, 8, 16, 24, 32, 40, 48, 56]
}

// MARK: - Out of board
/*
extension ChessBoard {

    static func isOutOfChessBoard(file: Int, rank: Int) -> Bool {
        return file < minPosition || file > maxPosition || rank < minPosition || rank > maxPosition
    }
}*/

// MARK: - Convert position

extension ChessBoard {
    static func posToInt(file: Int, rank: Int) -> Int {
        return file - 1 + (rank - 1) * maxPosition
    }

    static func intToPos(_ int: Int) -> (file: Int, rank: Int) {
        if int == 0 { return (1, 1) }
        // get rank
        let rank: Int
        if let optRank = ChessBoard.startingRank.firstIndex(where: { $0 > int }) {
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

// MARK: - Valid moves: diagonal

extension ChessBoard {

    static func getValidMovesUpLeft(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        if rank < ChessBoard.maxPosition && file > ChessBoard.minPosition {
            var rankIndex = rank + 1
            var fileIndex = file - 1

            while rankIndex <= ChessBoard.maxPosition && fileIndex >= ChessBoard.minPosition {
                let chessBoard = ChessBoard(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = ChessBoard.board[chessBoard] {
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

    static func getValidMovesDownRight(fromFile file: Int, andRank rank: Int,
                                       ofColor color: PieceColor) -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        if rank > ChessBoard.minPosition && file < ChessBoard.maxPosition {
            var rankIndex = rank - 1
            var fileIndex = file + 1

            while rankIndex >= ChessBoard.minPosition && fileIndex <= ChessBoard.maxPosition {
                let chessBoard = ChessBoard(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = ChessBoard.board[chessBoard] {
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

    static func getValidMovesUpRight(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        if rank < ChessBoard.maxPosition && file < ChessBoard.maxPosition {
            var rankIndex = rank + 1
            var fileIndex = file + 1

            while rankIndex <= ChessBoard.maxPosition && fileIndex <= ChessBoard.maxPosition {
                let chessBoard = ChessBoard(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = ChessBoard.board[chessBoard] {
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

    static func getValidMovesDownLeft(fromFile file: Int, andRank rank: Int,
                                      ofColor color: PieceColor) -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        if rank > ChessBoard.minPosition && file > ChessBoard.minPosition {
            var rankIndex = rank - 1
            var fileIndex = file - 1

            while rankIndex >= ChessBoard.minPosition && fileIndex >= ChessBoard.minPosition {
                let chessBoard = ChessBoard(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = ChessBoard.board[chessBoard] {
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
    static func getValidMovesUp(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        if rank < ChessBoard.maxPosition {
            var index = rank + 1

            while index <= ChessBoard.maxPosition {
                let chessBoard = ChessBoard(file: file, rank: index)
                // check if there is a piece
                if let piece = ChessBoard.board[chessBoard] {
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

    static func getValidMovesRight(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        if file < ChessBoard.maxPosition {
            var index = file + 1

            while index <= ChessBoard.maxPosition {
                let chessBoard = ChessBoard(file: index, rank: rank)
                // check if there is a piece
                if let piece = ChessBoard.board[chessBoard] {
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
    static func getValidMovesDown(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        if rank > ChessBoard.minPosition {
            var index = rank - 1

            while index >= ChessBoard.minPosition {
                let chessBoard = ChessBoard(file: file, rank: index)
                // check if there is a piece
                if let piece = ChessBoard.board[chessBoard] {
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

    static func getValidMovesLeft(fromFile file: Int, andRank rank: Int, ofColor color: PieceColor) -> [ChessBoard] {
        var validMoves: [ChessBoard] = []
        if file > ChessBoard.minPosition {
            var index = file - 1

            while index >= ChessBoard.minPosition {
                let chessBoard = ChessBoard(file: index, rank: rank)
                // check if there is a piece
                if let piece = ChessBoard.board[chessBoard] {
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
