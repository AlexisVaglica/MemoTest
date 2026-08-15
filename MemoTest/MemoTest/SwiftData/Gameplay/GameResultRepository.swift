//
//  GameResultRepository.swift
//  MemoTest
//
//  Created by AVaglica on 15/08/2026.
//

import SwiftData

protocol GameResultRepository {
    func save(_ result: GameResultData) throws
    func fetchAll() throws -> [GameResultData]
}

final class GameResultSaveData: GameResultRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func save(_ result: GameResultData) throws {
        let gameResult = GameResult(data: result)

        modelContext.insert(gameResult)
        try modelContext.save()
    }

    func fetchAll() throws -> [GameResultData] {
        let descriptor = FetchDescriptor<GameResult>()

        return try modelContext.fetch(descriptor).map {
            GameResultData(score: $0.score, genreID: $0.genreID)
        }
    }
}
