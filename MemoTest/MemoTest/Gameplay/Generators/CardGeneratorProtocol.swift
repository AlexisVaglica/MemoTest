//
//  CardGeneratorProtocol.swift
//  MemoTest
//
//  Created by AVaglica on 15/08/2026.
//

protocol CardGeneratorProtocol {
    var genre: String { get }
    func generateDeck() async -> [CardObject]
}
