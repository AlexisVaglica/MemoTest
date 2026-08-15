//
//  Globals.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

final class Globals {
    static let shared = Globals()
    private init() {}
    
    public let TMDB_Base_URL : String = "https://api.themoviedb.org/3/"
}
