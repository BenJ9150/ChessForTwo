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
    private var startingPoint = CGPoint()
    private var lastPoint = CGPoint()
    private var currentPiece: UIView?
    private var move: (start: Int?, end: Int?)
    private var firstDraggingSquare: Int?
    private var currentHoveredSquare: Int?
    private var lastHoveredSquare: Int?
    private var startingChoice: Int?

    private let selectionAlpha = 0.6
    private let dragZoom = 2.75
    private let dragOffset: CGFloat = 16 // to see piece under finger
    private let minDrag: CGFloat = 8 // min move to known if tap or drag

    // MARK: - IBOutlet

    @IBOutlet var squaresView: [UIView]!
    @IBOutlet weak var whiteCoordinates: UIStackView!
    @IBOutlet weak var blackCoordinates: UIStackView!
}

// MARK: - Public methods

extension ChessBoardView {

    func selectSquare(atPosition position: Int?) {
        setBackgroundAlpha(alpha: selectionAlpha, atPosition: position)
    }

    func unselectSquare(atPosition position: Int?) {
        setBackgroundAlpha(alpha: 1, atPosition: position)
    }
}

// MARK: - Touches

extension ChessBoardView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canPlay() { return }

        // get current point and square
        let currentPoint = touchLocation(touches)
        guard let currentSquare = getCurrentSquare(forPoint: currentPoint) else { return }

        // update points
        startingPoint = currentPoint
        lastPoint = currentPoint

        // check if already choice for start
        if startingChoice != nil { return }

        // get piece image in current square view
        if !setCurrentPieceFromSquare(currentSquare) {
            cleanMove()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canPlay() { return }

        // get current point, start and square
        let currentPoint = touchLocation(touches)
        guard let startingSq = move.start else { return }
        guard let currentSquare = getCurrentSquare(forPoint: currentPoint) else { return }

        // check if dragging
        if abs(currentPoint.x - startingPoint.x) < minDrag && abs(currentPoint.y - startingPoint.y) < minDrag {
            // little move, maybe a tap
            return
        } else if firstDraggingSquare == nil {
            firstDraggingSquare = squaresView.firstIndex(of: currentSquare)
        }
        // at the start of the drag, check if starting dragging square is start move
        if startingSq != firstDraggingSquare {
            // not first piece is dragging, replace first piece
            guard let fistSelectedPiece = currentPiece, startingSq < squaresView.count else {
                cleanMove()
                return
            }
            // just in case, delete transfom
            fistSelectedPiece.transform = .identity
            // add first piece to first square
            fistSelectedPiece.frame = squaresView[startingSq].bounds
            squaresView[startingSq].addSubview(fistSelectedPiece)
            // clean move
            unselectSquare(atPosition: move.start)
            cleanMove()
            firstDraggingSquare = squaresView.firstIndex(of: currentSquare)
            // New move, update points
            startingPoint = currentPoint
            lastPoint = currentPoint
            // get piece image in current square view
            if !setCurrentPieceFromSquare(currentSquare) {
                cleanMove()
            }
        }

        // get current piece
        guard let pieceView = currentPiece else {return}

        // add selected background to hovered square
        showSelectedHoveredSquare(currentSquare)

        // new frame of moved piece
        var newFrame = pieceView.frame
        newFrame.origin.x = pieceView.frame.origin.x + currentPoint.x - lastPoint.x
        newFrame.origin.y = pieceView.frame.origin.y + currentPoint.y - lastPoint.y
        pieceView.frame = newFrame

        // zoom to see the piece under the user's finger
        let zoom = CGAffineTransform(scaleX: dragZoom, y: dragZoom)
        let offset = CGAffineTransform(translationX: 0, y: (viewOfColor == .white ? -dragOffset : dragOffset))
        UIView.animate(withDuration: 0.15, delay: 0.0) {
            pieceView.transform = CGAffineTransformConcat(zoom, offset)
        }

        // update last point
        lastPoint = currentPoint
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !canPlay() { return }

        // get point and image
        let currentPoint = touchLocation(touches)
        guard let pieceImage = currentPiece else {
            cleanMove()
            return
        }

        // get starting square
        guard let start = move.start else {
            pieceImage.transform = .identity
            cleanMove()
            return
        }

        // get current square
        guard let currentSquare = getCurrentSquare(forPoint: currentPoint) else {
            // out of board, replace the piece
            pieceImage.transform = .identity
            pieceImage.frame = squaresView[start].bounds
            squaresView[start].addSubview(pieceImage)
            cleanMove()
            return
        }

        // check if same position at start
        move.end = squaresView.firstIndex(of: currentSquare)
        if move.start == move.end {
            startingChoice = move.start
            firstDraggingSquare = nil // to check if an other square will drag
            // delete transform and replace piece if dragged
            pieceImage.transform = .identity
            pieceImage.frame = squaresView[start].bounds
            squaresView[start].addSubview(pieceImage)
            return
        }

        // end of move with animation
        if startingChoice == nil {
            endAnimationAfterDrag(piece: pieceImage, atSquare: currentSquare)
        } else {
            endAnimationAfterTap(piece: pieceImage, atSquare: currentSquare)
        }
    }
}

// MARK: - End of move animation

extension ChessBoardView {

    private func endAnimationAfterDrag(piece pieceImage: UIView, atSquare currentSquare: UIView) {
        // get offset to center piece on ending square
        let xOffset = (pieceImage.bounds.width * self.dragZoom - currentSquare.bounds.width)/2
        let yOffset = xOffset - (viewOfColor == .white ? -dragOffset : dragOffset)

        // animation
        UIView.animate(withDuration: 0.15, delay: 0.0,
                       usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1,
                       options: .curveEaseIn) {
            // center piece on square and return to identity
            pieceImage.frame.origin.x = currentSquare.frame.origin.x - xOffset
            pieceImage.frame.origin.y = currentSquare.superview!.frame.origin.y - yOffset
            pieceImage.transform = .identity
        } completion: { _ in
            self.endOfMove(piece: pieceImage, atSquare: currentSquare)
        }
    }

    private func endAnimationAfterTap(piece pieceImage: UIView, atSquare currentSquare: UIView) {
        // get starting square
        guard let start = move.start, start < squaresView.count else {
            endOfMove(piece: pieceImage, atSquare: currentSquare)
            return
        }
        // get starting piece
        guard let startingPiece = squaresView[start].subviews.last else {
            endOfMove(piece: pieceImage, atSquare: currentSquare)
            return
        }
        // add piece to view
        startingPiece.frame = getFrameForGlobalView(piece: startingPiece, atSquare: squaresView[start])
        addSubview(startingPiece)

        // animation
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseInOut) {
            // center piece on square and return to identity
            startingPiece.frame.origin.x = currentSquare.frame.origin.x
            startingPiece.frame.origin.y = currentSquare.superview!.frame.origin.y
        } completion: { _ in
            self.endOfMove(piece: startingPiece, atSquare: currentSquare)
        }
    }

    private func endOfMove(piece pieceImage: UIView, atSquare currentSquare: UIView) {
        // just in case, delete transfom
        pieceImage.transform = .identity

        // add image to current square
        pieceImage.frame = currentSquare.bounds
        currentSquare.addSubview(pieceImage)

        // select ending square
        selectSquare(atPosition: move.end)

        // notify controller and reinit properties
        NotificationCenter.default.post(name: .moveDone, object: move)
        reinitProperties()
    }
}

// MARK: - Get piece, square or frame

extension ChessBoardView {

    private func touchLocation(_ touches: Set<UITouch>) -> CGPoint {
        touch = touches.first! as UITouch
        return touch.location(in: self)
    }

    private func getCurrentSquare(forPoint currentPoint: CGPoint) -> UIView? {
        for square in squaresView {
            guard let squareStack = square.superview else { continue }

            // frame of square in view origin
            let origin = CGPoint(x: Double(square.frame.origin.x),
                                 y: Double(squareStack.frame.origin.y))

            if frame(forAlignmentRect: CGRect(origin: origin, size: square.frame.size)).contains(currentPoint) {
                return square
            }
        }
        return nil
    }

    private func setCurrentPieceFromSquare(_ square: UIView) -> Bool {
        // get piece image in current square view
        if let pieceImage = square.subviews.last {
            // check if good color
            guard let pieceImageView = pieceImage as? UIImageView else { return false }
            guard let imageAsset = pieceImageView.image?.imageAsset else { return false }
            guard let imageName = imageAsset.value(forKey: "assetName") as? String else { return false }
            guard let playerColor = whoIsPlaying else { return false }
            // check image name
            if imageName.lowercased().contains("\(playerColor.rawValue.lowercased())") {
                // remove background if exist
                if pieceImage.backgroundColor != .clear {
                    pieceImage.backgroundColor = .clear
                }
                // add piece to view
                pieceImage.frame = getFrameForGlobalView(piece: pieceImage, atSquare: square)
                currentPiece = pieceImage
                addSubview(currentPiece!)
                // save start square and add selected background
                move.start = squaresView.firstIndex(of: square)
                currentHoveredSquare = move.start
                selectSquare(atPosition: move.start)
                return true
            }
        }
        return false
    }

    private func getFrameForGlobalView(piece pieceImage: UIView, atSquare square: UIView) -> CGRect {
        // new frame of piece in global view
        var newFrame = pieceImage.frame
        newFrame.size.width = pieceImage.bounds.width
        newFrame.size.height = pieceImage.bounds.height
        newFrame.origin.x = square.frame.origin.x
        newFrame.origin.y = square.superview!.frame.origin.y
        return newFrame
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

    private func setBackgroundAlpha(alpha: CGFloat, atPosition position: Int?) {
        guard let pos = position, pos < squaresView.count else { return }
        // change background
        if let color = squaresView[pos].backgroundColor {
            squaresView[pos].backgroundColor = color.withAlphaComponent(alpha)
        }
    }

    private func showSelectedHoveredSquare(_ currentSquare: UIView) {
        if self.currentHoveredSquare != self.squaresView.firstIndex(of: currentSquare) {
            self.currentHoveredSquare = self.squaresView.firstIndex(of: currentSquare)

            // add background to current
            self.selectSquare(atPosition: self.currentHoveredSquare)

            // remove background of last
            if self.lastHoveredSquare != self.move.start {
                self.unselectSquare(atPosition: self.lastHoveredSquare)
            }
            // update last hovered square
            self.lastHoveredSquare = self.squaresView.firstIndex(of: currentSquare)
        }
    }
}

// MARK: - Clear move

extension ChessBoardView {

    private func cleanMove() {
        unselectSquare(atPosition: move.start)
        unselectSquare(atPosition: move.end)
        unselectSquare(atPosition: currentHoveredSquare)
        reinitProperties()
    }

    private func reinitProperties() {
        touch = nil
        startingPoint = CGPoint()
        lastPoint = CGPoint()
        currentPiece = nil
        move.start = nil
        move.end = nil
        firstDraggingSquare = nil
        currentHoveredSquare = nil
        lastHoveredSquare = nil
        startingChoice = nil
    }
}
