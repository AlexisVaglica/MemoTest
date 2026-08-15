//
//  GameResultMock.swift
//  MemoTest
//
//  Created by AVaglica on 15/08/2026.
//

import SwiftData

final class GameResultSaveDataMock: GameResultRepository {
    func save(_ result: GameResultData) throws {}
    func fetchAll() throws -> [GameResultData] { return [] }
}
