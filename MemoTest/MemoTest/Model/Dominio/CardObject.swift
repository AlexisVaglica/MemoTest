//
//  CardObject.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

import Foundation

struct CardObject: Identifiable {
    let id: UUID = UUID()
    let content: CardContent
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

struct CardContent: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String?

    var posterURL: URL? {
        guard let posterPath else { return nil }

        let normalizedPath = posterPath.trimmingCharacters(
            in: CharacterSet(charactersIn: "/")
        )

        return URL(
            string: "\(Globals.shared.TMDB_Image_URL)\(normalizedPath)"
        )
    }
}
