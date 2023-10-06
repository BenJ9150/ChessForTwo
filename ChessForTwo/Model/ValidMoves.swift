//
//  ValidMoves.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 02/10/2023.
//

import Foundation

class ValidMoves {

    // MARK: - Private properties

    private static var minPosition: Int {
        return ChessBoard.minPosition
    }

    private static var maxPosition: Int {
        return ChessBoard.maxPosition
    }

    private static var chessboard: [Square: Pieces] {
        return ChessBoard.chessboard
    }
}

// MARK: - Empty squares between pieces

extension ValidMoves {

    private static func directionBetweenPieces(one: Pieces, two: Pieces) -> String {
        // vertical
        var dir = one.currentRank < two.currentRank ? "N" : one.currentRank > two.currentRank ? "S" : ""
        // horizontal
        dir += one.currentFile < two.currentFile ? "E" : one.currentFile > two.currentFile ? "W" : ""

        // check diff for diagonal
        if one.currentRank != two.currentRank && one.currentFile != two.currentFile {
            if abs(one.currentRank - two.currentRank) - abs(one.currentFile - two.currentFile) != 0 {
                dir = ""
            }
        }
        return dir
    }

    static func emptySquaresBetween(_ one: Pieces, and two: Pieces) -> [Square] {
        var emptySquares: [Square] = []
        if type(of: two) == type(of: Knight()) {
            return emptySquares
        }
        let color: PieceColor = one.color

        switch directionBetweenPieces(one: one, two: two) {
        case "N":
            emptySquares.append(contentsOf: validUp(file: one.currentFile, rank: one.currentRank, color: color))
        case "S":
            emptySquares.append(contentsOf: validDown(file: one.currentFile, rank: one.currentRank, color: color))
        case "E":
            emptySquares.append(contentsOf: validRight(file: one.currentFile, rank: one.currentRank, color: color))
        case "W":
            emptySquares.append(contentsOf: validLeft(file: one.currentFile, rank: one.currentRank, color: color))
        case "NE":
            emptySquares.append(contentsOf: validUpRight(file: one.currentFile, rank: one.currentRank, color: color))
        case "NW":
            emptySquares.append(contentsOf: validUpLeft(file: one.currentFile, rank: one.currentRank, color: color))
        case "SE":
            emptySquares.append(contentsOf: validDownRight(file: one.currentFile, rank: one.currentRank, color: color))
        case "SW":
            emptySquares.append(contentsOf: validDownLeft(file: one.currentFile, rank: one.currentRank, color: color))
        default:
            return emptySquares
        }
        return emptySquares
    }
}

// MARK: - Valid moves: diagonal

extension ValidMoves {

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

extension ValidMoves {

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
}

// MARK: - Valid moves: horizontal

extension ValidMoves {

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