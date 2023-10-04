//
//  ChessBoardView.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 16/09/2023.
//

import UIKit

class ChessBoardView: UIView {

    // MARK: Public properties

    var viewOfColor: PieceColor? // to known color of player
    var whoIsPlaying: PieceColor? // to compare if player can play

    // MARK: Private properties

    private var touch: UITouch!
    private var oldPoint = CGPoint()
    private var dragging = false
    private var currentPiece: UIView?
    private var move: (start: Int?, end: Int?)
    private var currentHoveredSquare: Int?
    private var lastHoveredSquare: Int?
    private let selectionAlpha = 0.7

    // MARK: - IBOutlet

    @IBOutlet var squaresView: [UIView]!
    @IBOutlet weak var whiteCoordinates: UIStackView!
    @IBOutlet weak var blackCoordinates: UIStackView!
}

// MARK: - Public methods

extension ChessBoardView {

    func showMove(startSquare: Int, endSquare: Int) {
        selectSquare(atPosition: startSquare)
        selectSquare(atPosition: endSquare)
    }

    func hiddenMove(startSquare: Int?, endSquare: Int?) {
        unselectSquare(atPosition: startSquare)
        unselectSquare(atPosition: endSquare)
    }
}

// MARK: - Touches

extension ChessBoardView {

    private func touchLocation(_ touches: Set<UITouch>) -> CGPoint {
        touch = touches.first! as UITouch
        return touch.location(in: self)
    }

    private func getCurrentSquare(forPoint currentPoint: CGPoint) -> UIView? {
        for square in squaresView {
            guard let squareStack = square.superview else { continue }

            // frame of square in view origin
            let size = square.frame.size
            let origin = CGPoint(x: Double(square.frame.origin.x),
                                 y: Double(squareStack.frame.origin.y))

            if frame(forAlignmentRect: CGRect(origin: origin, size: size)).contains(currentPoint) {
                return square
            }
        }
        return nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canPlay() { return }
        cleanSelectedSquares()

        // get touch
        let currentPoint = touchLocation(touches)
        guard let currentSquare = getCurrentSquare(forPoint: currentPoint) else { return }

        if let pieceImage = currentSquare.subviews.last {
            // new frame of moved piece
            var frame = pieceImage.frame

            // zoom to see the piece under the user's finger
            let zoom = 2.75
            frame.size.width = pieceImage.bounds.width * zoom
            frame.size.height = pieceImage.bounds.height * zoom

            // change origin to center piece on the tap
            frame.origin.x = currentPoint.x - pieceImage.bounds.width * zoom/2
            if viewOfColor == .white {
                frame.origin.y = currentPoint.y - pieceImage.bounds.height * zoom * 2/3
            } else {
                frame.origin.y = currentPoint.y - pieceImage.bounds.height * zoom * 1/3
            }

            // add piece to view
            pieceImage.frame = frame
            currentPiece = pieceImage
            addSubview(currentPiece!)

            // drag is on
            move.start = squaresView.firstIndex(of: currentSquare)
            oldPoint = currentPoint
            dragging = true

            // save start square and add selected background
            currentHoveredSquare = move.start
            selectSquare(atPosition: move.start)
            return
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canPlay() || !dragging { return }

        // get touch and piece
        let currentPoint = touchLocation(touches)
        guard let pieceView = currentPiece else {return}

        // change origin
        var frame = pieceView.frame
        frame.origin.x = pieceView.frame.origin.x + currentPoint.x - oldPoint.x
        frame.origin.y = pieceView.frame.origin.y + currentPoint.y - oldPoint.y
        pieceView.frame = frame

        // update old point
        oldPoint = currentPoint

        // add selected background to hovered square
        guard let currentSquare = getCurrentSquare(forPoint: currentPoint) else { return }
        showSelectedHoveredSquare(currentSquare)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canPlay() || !dragging { return }

        // get touch
        let currentPoint = touchLocation(touches)

        // drag is off
        dragging = false

        // get piece image and starting position in Int
        guard let pieceImage = currentPiece, let start = move.start else {
            cleanSelectedSquares()
            return
        }

        // get current square
        guard let currentSquare = getCurrentSquare(forPoint: currentPoint) else {
            // out of board, replace the piece
            pieceImage.frame = squaresView[start].bounds
            squaresView[start].addSubview(pieceImage)
            cleanSelectedSquares()
            return
        }
        move.end = squaresView.firstIndex(of: currentSquare)

        // add image to current square
        pieceImage.frame = currentSquare.bounds
        currentSquare.addSubview(pieceImage)

        // reinit current piece
        currentPiece = nil

        // check if same position at start
        if move.start == move.end {
            cleanSelectedSquares()
            return
        }

        // notify controller
        NotificationCenter.default.post(name: .moveDone, object: move)
    }
}

// MARK: - Who is playing

extension ChessBoardView {

    private func canPlay() -> Bool {
        guard let boardColor = viewOfColor, let playerColor = whoIsPlaying else { return false }
        return playerColor == boardColor
    }
}
// MARK: - Background selections

extension ChessBoardView {

    private func selectSquare(atPosition position: Int?) {
        setBackgroundAlpha(alpha: selectionAlpha, atPosition: position)
    }

    private func unselectSquare(atPosition position: Int?) {
        setBackgroundAlpha(alpha: 1, atPosition: position)
    }

    private func setBackgroundAlpha(alpha: CGFloat, atPosition position: Int?) {
        guard let pos = position, pos < squaresView.count else { return }
        // change background
        if let color = squaresView[pos].backgroundColor {
            squaresView[pos].backgroundColor = color.withAlphaComponent(alpha)
        }
    }

    private func showSelectedHoveredSquare(_ currentSquare: UIView) {
        DispatchQueue.main.async {
            if self.currentHoveredSquare != self.squaresView.firstIndex(of: currentSquare) {
                self.currentHoveredSquare = self.squaresView.firstIndex(of: currentSquare)

                // add background to current
                self.setBackgroundAlpha(alpha: self.selectionAlpha, atPosition: self.currentHoveredSquare)

                // remove background of last
                if self.lastHoveredSquare != self.move.start {
                    self.setBackgroundAlpha(alpha: 1, atPosition: self.lastHoveredSquare)
                }
                // update last hovered square
                self.lastHoveredSquare = self.squaresView.firstIndex(of: currentSquare)
            }
        }
    }

    private func cleanSelectedSquares() {
        unselectSquare(atPosition: move.start)
        unselectSquare(atPosition: move.end)
        unselectSquare(atPosition: currentHoveredSquare)
        currentHoveredSquare = nil
        lastHoveredSquare = nil
    }
}
