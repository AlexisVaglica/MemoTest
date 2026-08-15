//
//  GameResult.swift
//  MemoTest
//
//  Created by AVaglica on 15/08/2026.
//

import SwiftData

struct GameResultData {
    var score: Int
    var genreID: String
}

@Model
final class GameResult {
    var score: Int
    var genreID: String
    
    init(data: GameResultData) {
        self.score = data.score
        self.genreID = data.genreID
    }
}
