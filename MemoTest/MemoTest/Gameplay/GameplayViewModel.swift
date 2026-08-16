//
//  GameplayViewModel.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

import Foundation

@MainActor
protocol GameplayViewModelProtocol: AnyObject {
    var cards: [CardObject] { get }
    var pairFound: Int { get }
    var gameplayState: GameplayState { get }
    var gameResult: GameResultData { get }
    func select(_ card: CardObject)
    func restartGame() async
    func clearMismatch()
    func backToHome()
}

enum GameplayState: Equatable {
    case idle
    case checkingMatch
    case mismatchDelay
    case endGame
}

@Observable
class GameplayViewModel: GameplayViewModelProtocol {
    private(set) var cards: [CardObject] = []
    private(set) var pairFound: Int = 0
    private(set) var gameplayState: GameplayState = .idle
    private(set) var gameResult: GameResultData

    private var firstSelectedCardIndex: Int?
    private var secondSelectedCardIndex: Int?
    private let generator: CardGeneratorProtocol
    private let gameResultRepository: GameResultRepository

    private let router: GameplayRouter

    private let pointsToMatch = 10

    init(
        genreId: Int,
        generator: CardGeneratorProtocol,
        resultRepository: GameResultRepository,
        router: GameplayRouter
    ) {
        self.gameResultRepository = resultRepository
        self.generator = generator
        self.router = router
        self.gameResult = GameResultData(score: 0, genreID: String(genreId))
    }

    func select(_ card: CardObject) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            gameplayState == .idle,
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        else { return }

        if let firstIndex = firstSelectedCardIndex {
            cards[chosenIndex].isFaceUp = true
            secondSelectedCardIndex = chosenIndex
            checkForMatch(firstIndex, chosenIndex)
        } else {
            cards[chosenIndex].isFaceUp = true
            firstSelectedCardIndex = chosenIndex
        }
    }

    func restartGame() async {
        cards = await generator.generateDeck()
        firstSelectedCardIndex = nil
        secondSelectedCardIndex = nil
        pairFound = 0
        gameplayState = .idle
    }

    private func checkForMatch(_ firstCardIndex: Int, _ secondCardIndex: Int) {
        gameplayState = .checkingMatch

        if isCardMatch(
            firstCard: cards[firstCardIndex],
            secondCard: cards[secondCardIndex]
        ) {
            addMatch(
                firstCardIndex: firstCardIndex,
                secondCardIndex: secondCardIndex
            )
        } else {
            gameplayState = .mismatchDelay
        }
    }

    private func isCardMatch(firstCard: CardObject, secondCard: CardObject)
        -> Bool
    {
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
        gameResult.score += pointsToMatch
    }

    private func isEndGame() -> Bool {
        return pairFound >= cards.count / 2
    }

    private func checkMatchEnd() {
        if isEndGame() {
            gameplayState = .endGame

            do {
                try gameResultRepository.save(gameResult)
            } catch {
                print("No se pudo guardar el resultado: \(error)")
            }
        }
    }

    func backToHome() {
        router.backToHome()
    }
}
