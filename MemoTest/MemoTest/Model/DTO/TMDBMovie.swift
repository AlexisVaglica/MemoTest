//
//  TMDBMovie.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

struct TMDBMovieResponseDTO: Decodable {
    let page: Int
    let results: [TMDBMovieDTO]
}

struct TMDBMovieDTO: Decodable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

extension TMDBMovieDTO {
    func toCardObjectAdapter() -> CardObject {
        let content = CardContent(
            id: id,
            title: title,
            posterPath: posterPath,
            releaseDate: releaseDate)
        
        return CardObject(
            content: content
        )
    }
}
