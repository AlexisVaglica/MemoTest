//
//  MemoTestTests.swift
//  MemoTestTests
//
//  Created by AVaglica on 07/08/2026.
//

import Testing

@testable import MemoTest

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
        router = await GameplayRouter(coordinator: navigation)
    }

    @Test
    func test_gameStateResetsToDefaultOnLoad() {
        let viewModel = makeGameplayViewModel()

        #expect(viewModel.pairFound == 0)
        #expect(viewModel.gameResult.score == 0)
        #expect(viewModel.gameplayState == .idle)
    }

    @Test
    func test_loadedCardsAreFaceDownAndNotMatched() {
        let viewModel = makeGameplayViewModel()

        #expect(viewModel.cards.allSatisfy { !$0.isFaceUp })
        #expect(viewModel.cards.allSatisfy { !$0.isMatched })
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

    @Test
    func test_hasCardsGreaterThanZero() {
        let genre = "action"
        let generator = EmojisCardGeneratorFake(genre: genre)
        let deck = generator.generateDeck()
        let pairs = deck.count / 2
        #expect(pairs > 0)
    }

    @Test
    func test_hasCardsMoviesGreaterThanZero() async {
        let imageService = ImageCaptureMock()
        let movieService = TMDBMovieServiceMock()
        
        let genre = "action"
        let generator = MoviesCardGenerator(
            genre: genre,
            imageService: imageService,
            movieService: movieService
        )
        let deck = await generator.generateDeck()
        let pairs = deck.count / 2
        #expect(pairs > 0)
    }
    
    /*@Test
    func test_hasCardsMoviesImagesGreaterThanZero() async {
        let imageService = ImageServiceMock()
        let genre = "action"
        let generator = MoviesCardGenerator(genre: genre, imageService: imageService)
        let deck = await generator.generateDeck()
        let pairs = deck.count / 2
        #expect(pairs > 0)
    }*/
}

struct DTOTests {

    @Test
    func test_AdapterMovieDTOToCardObject() {

    }
}
