//
//  MemoTestApp.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

import SwiftUI
import SwiftData

@main
struct MemoTestApp: App {
    @StateObject private var dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            RootView(
                coordinator: dependencies.coordinator,
                homeViewModel: dependencies.homeViewModel
            )
            .modelContainer(dependencies.modelContainer)
        }
    }
}

@MainActor
private final class AppDependencies: ObservableObject {
    let modelContainer: ModelContainer
    let coordinator: AppCoordinator
    let homeViewModel: HomeViewModel

    init() {
        do {
            let modelContainer = try ModelContainer(for: GameResult.self)
            let gameResultRepository = GameResultSaveData(modelContext: modelContainer.mainContext)
            
            let coordinator = AppCoordinator()
            let router = HomeRouter(coordinator: coordinator, gameResultRepository: gameResultRepository)
            
            self.modelContainer = modelContainer
            self.coordinator = coordinator
            self.homeViewModel = HomeViewModel(
                router: router,
                gameResultRepository: gameResultRepository
            )
        } catch(let e) {
            fatalError("App Dependencies not available: \(e.localizedDescription)")
        }
    }
}

private struct RootView: View {
    @ObservedObject var coordinator: AppCoordinator
    let homeViewModel: HomeViewModel

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView(viewModel: homeViewModel)
                .navigationDestination(for: ViewDestination.self) { destination in
                    destination.view
                }
        }
    }
}
