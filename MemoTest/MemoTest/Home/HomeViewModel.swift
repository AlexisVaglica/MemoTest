//
//  HomeViewModel.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

@MainActor
protocol HomeViewModelProtocol: AnyObject {
    var genreList: [GenreObject] { get }
    func startGame(with genre: GenreObject)
}

@Observable
@MainActor
final class HomeViewModel : HomeViewModelProtocol {
    private(set) var genreList: [GenreObject] = []
    private let router: HomeRouter
    
    init(router: HomeRouter) {
        self.router = router
        
        Task {
            genreList = try await self.getGenres()
        }
    }
    
    private func getGenres() async throws -> [GenreObject] {
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
