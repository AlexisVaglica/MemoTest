//
//  HomeRouter.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

@MainActor
final class HomeRouter {
    private weak var coordinator: NavigationCoordinatorProtocol?

    init(coordinator: NavigationCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func startGame(with genre: GenreObject) {
        guard let coordinator = self.coordinator else { return }
        let generator = MoviesCardGenerator(genre: String(genre.id))
        let router = GameplayRouter(coordinator: coordinator)
        let viewModel = GameplayViewModel(generator: generator, router: router)
        let gameplayView = GameplayView(viewModel: viewModel)

        coordinator.navigate(to: gameplayView)
    }
    
    func close() {
        coordinator?.goToRoot()
    }
}
