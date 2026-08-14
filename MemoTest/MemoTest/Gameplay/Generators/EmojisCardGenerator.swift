//
//  CardGenerator.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

import Foundation

final class EmojisCardGenerator: CardGeneratorProtocol {
    var genre: String = ""
    private let baseContents = ["🐶", "🐱", "🦊", "🐻", "🦁", "🐷", "🐸", "🐵"]

    func generateDeck() -> [CardObject] {
        var deck: [CardObject] = []
        var index = 0
        for content in baseContents {
            
            let cardContent = CardContent(
                id: index,
                title: content,
                posterPath: nil,
                releaseDate: nil)
            
            deck.append(CardObject(content: cardContent)) // Primera carta de la pareja
            deck.append(CardObject(content: cardContent)) // Segunda carta de la pareja
            index += 1
        }
        
        return deck.shuffled()
    }
}
