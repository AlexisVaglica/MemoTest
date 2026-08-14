//
//  TMDBGenreRepository.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

protocol TMDBGenreRepository: Sendable {
    func getGenres(language: String) async throws -> [TMDBGenreDTO]
}

struct GenreServiceAPI {
    static func getGenres(language: String) -> APIRequest<TMDBGenreResponseDTO> {
        APIRequest(
            path: "genre/movie/list",
            method: .get,
            queryItems: [URLQueryItem(name: "language", value: language)]
        )
    }
}

final class TMDBGenreService: TMDBGenreRepository {
    let requestClient: RequestClient
    
    init(requestClient: RequestClient) {
        self.requestClient = requestClient
    }
    
    func getGenres(language: String = "es-AR") async throws -> [TMDBGenreDTO] {
        let request = GenreServiceAPI.getGenres(language: language)
        let response = try await requestClient.send(request)
        return response.genres
    }
}
