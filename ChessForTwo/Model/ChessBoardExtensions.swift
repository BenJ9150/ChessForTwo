//
//  ChessBoardExtensions.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 02/10/2023.
//

import Foundation

// MARK: - Empty squares between pieces

extension ChessBoard {

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

extension ChessBoard {

    static func validUpLeft(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if rank < maxPosition && file > minPosition {
            var rankIndex = rank + 1
            var fileIndex = file - 1

            while rankIndex <= maxPosition && fileIndex >= minPosition {
                let square = Square(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = piece(atPosition: square) {
                    if piece.color != color { validMoves.append(square) }
                    break
                }
                // empty square, add and continue
                validMoves.append(square)
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
                let square = Square(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = piece(atPosition: square) {
                    if piece.color != color { validMoves.append(square) }
                    break
                }
                // empty square, add and continue
                validMoves.append(square)
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
                let square = Square(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = piece(atPosition: square) {
                    if piece.color != color { validMoves.append(square) }
                    break
                }
                // empty square, add and continue
                validMoves.append(square)
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
                let square = Square(file: fileIndex, rank: rankIndex)
                // check if there is a piece
                if let piece = piece(atPosition: square) {
                    if piece.color != color { validMoves.append(square) }
                    break
                }
                // empty square, add and continue
                validMoves.append(square)
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
                let square = Square(file: file, rank: index)
                // check if there is a piece
                if let piece = piece(atPosition: square) {
                    if piece.color != color { validMoves.append(square) }
                    break
                }
                // empty square, add and continue
                validMoves.append(square)
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
                let square = Square(file: file, rank: index)
                // check if there is a piece
                if let piece = piece(atPosition: square) {
                    if piece.color != color { validMoves.append(square) }
                    break
                }
                // empty square, add and continue
                validMoves.append(square)
                index -= 1
            }
        }
        return validMoves
    }
}

// MARK: - Valid moves: horizontal

extension ChessBoard {

    static func validRight(file: Int, rank: Int, color: PieceColor) -> [Square] {
        var validMoves: [Square] = []
        if file < maxPosition {
            var index = file + 1

            while index <= maxPosition {
                let square = Square(file: index, rank: rank)
                // check if there is a piece
                if let piece = piece(atPosition: square) {
                    if piece.color != color { validMoves.append(square) }
                    break
                }
                // empty square, add and continue
                validMoves.append(square)
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
                let square = Square(file: index, rank: rank)
                // check if there is a piece
                if let piece = piece(atPosition: square) {
                    if piece.color != color { validMoves.append(square) }
                    break
                }
                // empty square, add and continue
                validMoves.append(square)
                index -= 1
            }
        }
        return validMoves
    }
}
