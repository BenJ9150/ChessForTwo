//
//  ChessBoardView.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 16/09/2023.
//

import UIKit

class ChessBoardView: UIView {

    // MARK: Private properties

    private var touch: UITouch!
    private var oldPoint = CGPoint()
    private var dragging = false
    private var currentPiece: UIView?

    // MARK: - IBOutlet

    @IBOutlet var squaresView: [UIView]!

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
        // get touch
        let currentPoint = touchLocation(touches)
        guard let currentSquare = currentSquare(forPoint: currentPoint) else { return }

        if let pieceImage = currentSquare.subviews.last, pieceImage is UIImageView {
            // change origin for put image in view
            var frame = pieceImage.frame
            frame.origin.x = currentPoint.x - pieceImage.bounds.width/2
            frame.origin.y = currentPoint.y - pieceImage.bounds.height/2
            pieceImage.frame = frame
            // add piece image to view
            currentPiece = pieceImage
            addSubview(currentPiece!)
            // drag is on
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
        guard let currentSquare = currentSquare(forPoint: currentPoint) else { return }
        // add image to current square
        pieceImage.frame = currentSquare.bounds
        currentSquare.addSubview(pieceImage)
        // reinit current piece
        currentPiece = nil
    }
}
