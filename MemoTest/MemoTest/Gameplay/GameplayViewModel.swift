//
//  GameplayViewModel.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

import Foundation

protocol GameplayViewModelProtocol : AnyObject {
    var cards : [CardObject] { get }
    var pairFound : Int { get }
    var gameplayState : GameplayState { get }
    func select (_ card : CardObject)
    func checkForMatch(_ firstCardIndex: Int, _ secondCardIndex: Int)
    func clearMismatch()
    func restartGame() async
}

protocol CardGeneratorProtocol {
    func generateDeck() async -> [CardObject]
}

enum GameplayState : Equatable {
    case idle
    case checkingMatch
    case mismatchDelay
}

@Observable
class GameplayViewModel : GameplayViewModelProtocol {
    private(set) var cards: [CardObject] = []
    private(set) var pairFound: Int = 0
    private(set) var gameplayState: GameplayState = .idle
    
    private var firstSelectedCardIndex : Int?
    private var secondSelectedCardIndex : Int?
    private let generator : CardGeneratorProtocol?
    
    init(generator : CardGeneratorProtocol) {
        self.generator = generator
        restartGame()
    }
    
    func select(_ card: CardObject) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id}),
            gameplayState == .idle,
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched else { return }
        
        if let firstIndex = firstSelectedCardIndex {
            cards[chosenIndex].isFaceUp = true
            secondSelectedCardIndex = chosenIndex
            checkForMatch(firstIndex, chosenIndex)
        } else {
            cards[chosenIndex].isFaceUp = true
            firstSelectedCardIndex = chosenIndex
        }
    }
    
    func restartGame() {
        Task {
            cards = await generator?.generateDeck() ?? []
            firstSelectedCardIndex = nil
            secondSelectedCardIndex = nil
            pairFound = 0
            gameplayState = .idle
        }
    }
    
    func checkForMatch(_ firstCardIndex: Int, _ secondCardIndex: Int) {
        gameplayState = .checkingMatch
        
        if isCardMatch(
            firstCard: cards[firstCardIndex],
            secondCard: cards[secondCardIndex]
        ) {
            cards[firstCardIndex].isMatched = true
            cards[secondCardIndex].isMatched = true
            pairFound += 1
            gameplayState = .idle
            firstSelectedCardIndex = nil
            secondSelectedCardIndex = nil
        } else {
            gameplayState = .mismatchDelay
        }
    }
    
    private func isCardMatch(firstCard: CardObject, secondCard: CardObject) -> Bool {
        return firstCard.content.id == secondCard.content.id
    }
    
    func clearMismatch() {
        guard gameplayState == .mismatchDelay,
              let firstIndex = firstSelectedCardIndex,
              let secondIndex = secondSelectedCardIndex
        else { return }
        
        cards[firstIndex].isFaceUp = false
        cards[secondIndex].isFaceUp = false
        
        firstSelectedCardIndex = nil
        secondSelectedCardIndex = nil
        gameplayState = .idle
    }
}
