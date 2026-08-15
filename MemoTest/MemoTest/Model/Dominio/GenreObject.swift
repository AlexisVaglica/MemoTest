//
//  GenreObject.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

struct GenreObject {
    let id: Int
    let name: String
}

struct GenreHomeItem: Identifiable {
    var id: Int { genre.id }
    let genre: GenreObject
    let bestScore: Int?
}
