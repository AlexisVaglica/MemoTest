//
//  TMDBGenre.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

struct TMDBGenreResponseDTO: Decodable {
    let genres: [TMDBGenreDTO]
}

struct TMDBGenreDTO: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

extension TMDBGenreDTO {
    func toGenreObjectAdapter() -> GenreObject {
        return GenreObject(id: id, name: name)
    }
}
