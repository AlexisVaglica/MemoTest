//
//  MovieServiceMock.swift
//  MemoTest
//
//  Created by AVaglica on 15/08/2026.
//


final class TMDBMovieServiceMock: TMDBMovieRepository {
    func getMovies(genre: String, page: Int, language: String) async throws -> [TMDBMovieDTO] {
        // Retorna un par de películas de prueba mockeadas al instante
        return [
            TMDBMovieDTO(id: 1, title: "Película 1", posterPath: "/path1", releaseDate: "2026"),
            TMDBMovieDTO(id: 2, title: "Película 2", posterPath: "/path2", releaseDate: "2026")
        ]
    }
}
