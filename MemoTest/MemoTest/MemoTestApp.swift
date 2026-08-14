//
//  MemoTestApp.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

import SwiftUI

@main
struct MemoTestApp: App {
    @StateObject private var dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            RootView(
                coordinator: dependencies.coordinator,
                homeViewModel: dependencies.homeViewModel
            )
        }
    }
}

@MainActor
private final class AppDependencies: ObservableObject {
    let coordinator: AppCoordinator
    let homeViewModel: HomeViewModel

    init() {
        let coordinator = AppCoordinator()
        let router = HomeRouter(coordinator: coordinator)

        self.coordinator = coordinator
        self.homeViewModel = HomeViewModel(router: router)
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
