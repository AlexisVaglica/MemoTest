//
//  MemoTestTests.swift
//  MemoTestTests
//
//  Created by AVaglica on 07/08/2026.
//

import Testing
@testable import MemoTest

struct GameplayCoreTests {

    @Test
    func example() {
        
    }

}

struct GameplayCardGeneratorTests {
    
    @Test
    func test_hasExactPairs() {
        //When
        let generator = GameplayCardGenerator()
        let deck = generator.generateDeck()
        
        //Given
        var contentCounts: [String: Int] = [:]
        
        for card in deck {
            contentCounts[card.content, default: 0] += 1
        }
        
        //Then
        #expect(contentCounts.count == 8)
    }
}
