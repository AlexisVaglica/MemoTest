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
    var userGame : UserPlayer { get }
    func select (_ card : CardObject)
    func clearMismatch()
    func backToHome()
}

protocol CardGeneratorProtocol {
    var genre: String { get }
    func generateDeck() async -> [CardObject]
}

enum GameplayState : Equatable {
    case idle
    case checkingMatch
    case mismatchDelay
    case endGame
}

@Observable
class GameplayViewModel : GameplayViewModelProtocol {
    private(set) var cards: [CardObject] = []
    private(set) var pairFound: Int = 0
    private(set) var gameplayState: GameplayState = .idle
    private(set) var userGame: UserPlayer
    
    private var firstSelectedCardIndex : Int?
    private var secondSelectedCardIndex : Int?
    private let generator : CardGeneratorProtocol?
    
    private let router: GameplayRouter
    
    private let pointsToMatch = 10
    
    init(generator : CardGeneratorProtocol, router: GameplayRouter) {
        self.generator = generator
        self.router = router
        self.userGame = UserPlayer(points: 0)
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
    
    private func restartGame() {
        Task {
            cards = await generator?.generateDeck() ?? []
            firstSelectedCardIndex = nil
            secondSelectedCardIndex = nil
            pairFound = 0
            gameplayState = .idle
        }
    }
    
    private func checkForMatch(_ firstCardIndex: Int, _ secondCardIndex: Int) {
        gameplayState = .checkingMatch
        
        if isCardMatch(
            firstCard: cards[firstCardIndex],
            secondCard: cards[secondCardIndex]
        ) {
            addMatch(firstCardIndex: firstCardIndex, secondCardIndex: secondCardIndex)
        } else {
            gameplayState = .mismatchDelay
        }
    }
    
    private func isCardMatch(firstCard: CardObject, secondCard: CardObject) -> Bool {
        return firstCard.content.id == secondCard.content.id
    }
    
    private func addMatch(firstCardIndex: Int, secondCardIndex: Int) {
        gameplayState = .idle
        pairFound += 1
        
        cards[firstCardIndex].isMatched = true
        cards[secondCardIndex].isMatched = true
        firstSelectedCardIndex = nil
        secondSelectedCardIndex = nil
        
        addPoints()
        checkMatchEnd()
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

    private func addPoints() {
        userGame.points += pointsToMatch
    }
    
    private func isEndGame() -> Bool {
        return pairFound >= cards.count / 2
    }
    
    private func checkMatchEnd() {
        if isEndGame() {
            gameplayState = .endGame
        }
    }
    
    func backToHome() {
        Task {
            await router.backToHome()
        }
    }
}
