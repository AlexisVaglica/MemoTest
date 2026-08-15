//
//  HomeViewModel.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

@MainActor
protocol HomeViewModelProtocol: AnyObject {
    var genreList: [GenreHomeItem] { get }
    func refresh() async
    func startGame(with genre: GenreObject)
}

@Observable
@MainActor
final class HomeViewModel : HomeViewModelProtocol {
    private(set) var genreList: [GenreHomeItem] = []
    private let router: HomeRouter
    private let gameResultRepository: GameResultRepository
    
    init(
        router: HomeRouter,
        gameResultRepository: GameResultRepository
    ) {
        self.router = router
        self.gameResultRepository = gameResultRepository
    }

    func refresh() async {
        let genres = await getGenres()
        let results = (try? gameResultRepository.fetchAll()) ?? []
        let bestScores = Dictionary(grouping: results, by: \.genreID)
            .compactMapValues { results in
                results.map(\.score).max()
            }

        genreList = genres.map { genre in
            GenreHomeItem(
                genre: genre,
                bestScore: bestScores[String(genre.id)]
            )
        }
    }
    
    private func getGenres() async -> [GenreObject] {
        do {
            let urlPath = URL(string: Globals.shared.TMDB_Base_URL)!
            let requestClient = URLSessionClient(baseURL: urlPath)
            let repository = TMDBGenreService(requestClient: requestClient)
            let genres = try await repository.getGenres()
            return genres.prefix(8).map { $0.toGenreObjectAdapter() }
        } catch(let e) {
            print(e)
            return []
        }
    }
    
    func startGame(with genre: GenreObject) {
        router.startGame(with: genre)
    }
}
