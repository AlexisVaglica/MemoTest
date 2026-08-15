//
//  AppCoordinator.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import SwiftUI

struct ViewDestination: Hashable {
    let id = UUID()
    let view: AnyView

    static func == (
        lhs: ViewDestination,
        rhs: ViewDestination
    ) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

protocol NavigationCoordinatorProtocol: AnyObject {
    func navigate<Content: View>(to view: Content)
    func goBack()
    func goToRoot()
}

final class AppCoordinator: ObservableObject, NavigationCoordinatorProtocol {

    @Published var path = NavigationPath()
    
    func navigate<Content: View>(to view: Content) {
        path.append(
            ViewDestination(view: AnyView(view))
        )
    }

    func goBack() {
        guard !path.isEmpty else { return }

        path.removeLast()
    }

    func goToRoot() {
        path = NavigationPath()
    }
}
