//
//  CardGenerator.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

struct GameplayCardGenerator: CardGeneratorProtocol {
    
    // Lista de contenidos base para el juego (pueden ser animales, banderas, etc.)
    private let baseContents = ["🐶", "🐱", "🦊", "🐻", "🦁", "🐷", "🐸", "🐵"]

    func generateDeck() -> [CardObject] {
        var deck: [CardObject] = []
        
        for content in baseContents {
            deck.append(CardObject(content: content)) // Primera carta de la pareja
            deck.append(CardObject(content: content)) // Segunda carta de la pareja
        }
        
        return deck.shuffled()
    }
}
