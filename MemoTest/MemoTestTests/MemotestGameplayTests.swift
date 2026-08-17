//
//  MemoTestTests.swift
//  MemoTestTests
//
//  Created by AVaglica on 07/08/2026.
//

import Foundation
import Testing

@testable import MemoTest

@MainActor
struct GameplayCoreTests {
    let generatorMock: CardGeneratorProtocol
    let navigation: AppCoordinator
    let gameResultMock: GameResultRepository
    let router: GameplayRouter

    init() async {
        let genre = "action"
        generatorMock = EmojisCardGeneratorFake(genre: genre)
        gameResultMock = GameResultSaveDataMock()
        navigation = AppCoordinator()
        router = GameplayRouter(coordinator: navigation)
    }

    @Test
    func test_gameStateResetsToDefaultOnLoad() {
        let viewModel = makeGameplayViewModel()

        #expect(viewModel.pairFound == 0)
        #expect(viewModel.gameResult.score == 0)
        #expect(viewModel.gameplayState == .idle)
    }

    @Test
    func test_loadedCardsAreFaceDownAndNotMatched() async {
        let viewModel = makeGameplayViewModel()
        await viewModel.restartGame()

        #expect(viewModel.cards.allSatisfy { !$0.isFaceUp })
        #expect(viewModel.cards.allSatisfy { !$0.isMatched })
        #expect(viewModel.gameplayState == .idle)
    }

    @Test
    func test_selectingFirstCard_flipsOnlySelectedCard() async throws {
        let viewModel = makeGameplayViewModel()
        await viewModel.restartGame()

        let selectedCard = try #require(viewModel.cards.first)
        viewModel.select(selectedCard)

        #expect(viewModel.cards.first?.isFaceUp == true)
    }
    
    @Test
    func test_selectingTwoCards_isMatch() async throws {
        let viewModel = makeGameplayViewModel()
        await viewModel.restartGame()

        let firstCard = try #require(viewModel.cards.first)
        let matchingCard = try #require(
            viewModel.cards.first {
                $0.content.id == firstCard.content.id && $0.id != firstCard.id
            }
        )

        viewModel.select(firstCard)
        viewModel.select(matchingCard)

        let selectedCards = viewModel.cards.filter {
            $0.id == firstCard.id || $0.id == matchingCard.id
        }

        #expect(selectedCards.count == 2)
        #expect(selectedCards.allSatisfy { $0.isMatched })
    }

    private func makeGameplayViewModel() -> GameplayViewModel {
        return GameplayViewModel(
            genreId: 0,
            generator: generatorMock,
            resultRepository: gameResultMock,
            router: router
        )
    }
}

struct GameplayCardGeneratorTests {

    let genre : String
    
    init() {
        genre = "action"
    }
    
    @Test
    func test_hasCardsGreaterThanZero() {
        let generator = EmojisCardGeneratorFake(genre: genre)
        let deck = generator.generateDeck()
        let pairs = deck.count / 2
        #expect(pairs > 0)
    }

    @Test
    func test_hasCardsMoviesGreaterThanZero() async {
        let imageService = ImageCaptureMock()
        let movieService = TMDBMovieServiceMock()
        
        let generator = MoviesCardGenerator(
            genre: genre,
            imageService: imageService,
            movieService: movieService
        )
        let deck = await generator.generateDeck()
        let pairs = deck.count / 2
        #expect(pairs > 0)
    }
}

struct DTOTests {

    @Test
    func test_AdapterMovieDTOToCardObject() {
        let movieDTO = TMDBMovieDTO(
            id: 0,
            title: "movie",
            posterPath: "",
            releaseDate: "")
        
        let cardContentExpected = CardContent(
            id: 0,
            title: "movie",
            posterPath: "",
            releaseDate: "")
        
        let deckCardExpected = CardObject(content: cardContentExpected)
        
        let movieDeckCard = movieDTO.toCardObjectAdapter()
        
        #expect(movieDeckCard.content.id == deckCardExpected.content.id)
        #expect(movieDeckCard.content.title == deckCardExpected.content.title)
    }
    
    @Test
    func test_AdapterGenreDTOToGenreObject() {
        let genreDTO = TMDBGenreDTO(id: 0, name: "action")
        let genreExpected = GenreObject(id: 0, name: "action")
        let genreObject = genreDTO.toGenreObjectAdapter()
        
        #expect(genreObject.id == genreExpected.id)
        #expect(genreObject.name == genreExpected.name)
    }
}
