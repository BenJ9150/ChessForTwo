//
//  ChessComApi.swift
//  ChessForTwo
//
//  Created by Benjamin LEFRANCOIS on 10/11/2023.
//

import Foundation

// MARK: daily puzzle struct

struct DailyPuzzle: Decodable {

    var title = ""
    var url = ""
    var fen = ""
    var image = ""
}

// MARK: Chess com API class

final class ChessComApi {

    // MARK: Private properties

    private let host = "https://api.chess.com/pub"
    private let dailyPuzzleURI = "/puzzle"

    // MARK: Singleton

    static let shared = ChessComApi()
    private init() {}
}

// MARK: Get daily Puzzle

extension ChessComApi {

    func getDailyPuzzle(completionHandler: @escaping (DailyPuzzle) -> Void) {
        guard let url = URL(string: host + dailyPuzzleURI) else {
            completionHandler(DailyPuzzle())
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard error == nil else {
                completionHandler(DailyPuzzle())
                return
            }
            DispatchQueue.main.async {
                completionHandler(self.parse(data: data))
            }
        }
        task.resume()
    }

    private func parse(data: Data?) -> DailyPuzzle {
        if let data = data, let dailyPuzzle = try? JSONDecoder().decode(DailyPuzzle.self, from: data) {
            return dailyPuzzle
        }
        return DailyPuzzle()
    }
}
