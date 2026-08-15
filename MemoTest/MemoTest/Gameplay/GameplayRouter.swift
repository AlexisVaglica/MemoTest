//
//  GameplayRouter.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

@MainActor
final class GameplayRouter {
    private weak var coordinator: NavigationCoordinatorProtocol?

    init(coordinator: NavigationCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func backToHome() {
        coordinator?.goBack()
    }

    func close() {
        coordinator?.goToRoot()
    }
}
