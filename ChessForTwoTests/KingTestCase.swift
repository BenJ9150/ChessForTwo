//
//  KingTestCase.swift
//  ChessForTwoTests
//
//  Created by Benjamin LEFRANCOIS on 12/09/2023.
//

import XCTest
@testable import ChessForTwo

final class KingTestCase: XCTestCase {

    // MARK: - Valid move

    func testGivenKingIsAt7x6_WhenMovingAt6x5_ThenIsValidMove() {
        let king = King(initialFile: 7, initialRank: 6, color: .white)

        let valid = king.setNewPosition(atFile: 6, andRank: 5)

        XCTAssertTrue(valid)
    }

    // MARK: - Not valid move

    func testGivenKingIsAt7x6_WhenMovingAt7x8_ThenIsNotValidMove() {
        let king = King(initialFile: 7, initialRank: 6, color: .white)

        let valid = king.setNewPosition(atFile: 7, andRank: 8)

        XCTAssertFalse(valid)
    }

    // MARK: - Castling

    // Roque impossible :

    // le roi a bougé, roque impossible
    // le roi est attaqué, roque impossible
    // la tour a1 a bougé, grand roque blanc impossible
    // la tour a8 a bougé, petit roque blanc impossible
    // une pièce est en f1 ou g1, petit roque blanc impossible
    // une pièce est en b1, c1 ou d1, grand roque blanc impossible
    // une pièce attaque la case c1 ou d1, grand roque impossible
    // une pièce attaque la case f1 ou g1, petit roque impossible

    // Petit roque blanc possible :
    // le roi n'est pas attaqué
    // + ni le roi ni la tour h1 n'a bougé
    // + aucune pièce en f1 et g1
    // + les cases f1 et g1 ne sont pas attaquées

    // Grand roque blanc possible :
    // le roi n'est pas attaqué
    // + ni le roi ni la tour a1 n'a bougé
    // + aucune pièce en b1, c1 et d1
    // + les cases c1 et d1 ne sont pas attaquées
}
