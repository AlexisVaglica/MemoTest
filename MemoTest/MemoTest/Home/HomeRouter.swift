//
//  HomeRouter.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

@MainActor
final class HomeRouter {
    private weak var coordinator: NavigationCoordinatorProtocol?
    private let gameResultRepository: GameResultRepository

    init(coordinator: NavigationCoordinatorProtocol, gameResultRepository: GameResultRepository) {
        self.coordinator = coordinator
        self.gameResultRepository = gameResultRepository
    }

    func startGame(with genre: GenreObject) {
        guard let coordinator = self.coordinator else { return }
        let generator = MoviesCardGenerator(genre: String(genre.id))
        let router = GameplayRouter(coordinator: coordinator)
        let viewModel = GameplayViewModel(
            genreId: genre.id,
            generator: generator,
            resultRepository: gameResultRepository,
            router: router)
        let gameplayView = GameplayView(viewModel: viewModel)

        coordinator.navigate(to: gameplayView)
    }
    
    func close() {
        coordinator?.goToRoot()
    }
}
