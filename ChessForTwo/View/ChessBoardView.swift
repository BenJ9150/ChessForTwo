//
//  ChessBoardView.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 16/09/2023.
//

import UIKit

class ChessBoardView: UIView {

    // MARK: Public properties

    var viewOfColor: PieceColor? // for notification of move
    var whoIsPlaying: PieceColor? // to compare if can play

    // MARK: Private properties

    private var touch: UITouch!
    private var oldPoint = CGPoint()
    private var dragging = false
    private var currentPiece: UIView?
    private var movement: (start: Int?, end: Int?)

    // MARK: - IBOutlet

    @IBOutlet var squaresView: [UIView]!
    @IBOutlet weak var whiteCoordinates: UIStackView!
    @IBOutlet weak var blackCoordinates: UIStackView!
}

// MARK: - Touches

extension ChessBoardView {

    private func touchLocation(_ touches: Set<UITouch>) -> CGPoint {
        touch = touches.first! as UITouch
        return touch.location(in: self)
    }

    private func currentSquare(forPoint currentPoint: CGPoint) -> UIView? {
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
        if viewOfColor != whoIsPlaying { return }
        // get touch
        let currentPoint = touchLocation(touches)
        guard let currentSquare = currentSquare(forPoint: currentPoint) else { return }

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
            movement.start = squaresView.firstIndex(of: currentSquare)
            oldPoint = currentPoint
            dragging = true
            return
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !dragging { return }
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
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !dragging { return }
        // get touch
        let currentPoint = touchLocation(touches)
        // drag is off
        dragging = false
        // get piece image and current square
        guard let pieceImage = currentPiece else {return}
        guard let currentSquare = currentSquare(forPoint: currentPoint) else {
            // out of boardn replace the piece
            guard let start = movement.start else {return}
            pieceImage.frame = squaresView[start].bounds
            squaresView[start].addSubview(pieceImage)
            return
        }
        movement.end = squaresView.firstIndex(of: currentSquare)
        // add image to current square
        pieceImage.frame = currentSquare.bounds
        currentSquare.addSubview(pieceImage)
        // reinit current piece
        currentPiece = nil
        // notify controller
        guard let color = viewOfColor else { return }
        switch color {
        case .white:
            NotificationCenter.default.post(name: .whiteMoved, object: movement)
        case .black:
            NotificationCenter.default.post(name: .blackMoved, object: movement)
        }
    }
}
