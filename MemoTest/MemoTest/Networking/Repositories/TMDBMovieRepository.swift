//
//  MovieRepository.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

protocol TMDBMovieRepository: Sendable {
    func getMovies(
        genre: TMDBMovieGenre,
        page: Int,
        language: String
    ) async throws -> [TMDBMovieDTO]
}

struct MovieServiceAPI {
    static func getMovies(
        genre: TMDBMovieGenre,
        page: Int,
        language: String
    ) -> APIRequest<TMDBMovieResponseDTO> {
        APIRequest(
            path: "discover/movie",
            method: .get,
            queryItems: [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "with_genres", value: String(genre.rawValue))
            ]
        )
    }
}

final class TMDBMovieService: TMDBMovieRepository {
    let requestClient: RequestClient
    
    init(requestClient: RequestClient) {
        self.requestClient = requestClient
    }
    
    func getMovies(
        genre: TMDBMovieGenre,
        page: Int,
        language: String = "es-AR"
    ) async throws -> [TMDBMovieDTO] {
        let request = MovieServiceAPI.getMovies(
            genre: genre,
            page: page,
            language: language
        )
        let response = try await requestClient.send(request)
        return response.results
    }
}
