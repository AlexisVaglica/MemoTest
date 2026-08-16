//
//  GameplayView.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

import Foundation
import Kingfisher
import SwiftUI

struct GameplayView: View {
    @State private var viewModel: GameplayViewModelProtocol

    init(viewModel: GameplayViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text("Matchs: \(viewModel.pairFound)/\(viewModel.cards.count / 2)")
            Spacer()
            Text("Score: \(viewModel.gameResult.score)")
        }

        ZStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                viewModel.select(card)
                            }
                        }
                }
            }
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.gameplayState) { oldValue, newValue in
                if newValue == .mismatchDelay {
                    withAnimation(.easeInOut.delay(0.7)) {
                        viewModel.clearMismatch()
                    }
                }
            }
            .disabled(viewModel.gameplayState != .idle)

            if viewModel.gameplayState == .endGame {
                FinishPopup(
                    score: viewModel.gameResult.score,
                    matches: viewModel.pairFound,
                    totalMatches: viewModel.cards.count / 2,
                    onGoHome: viewModel.backToHome
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .task {
            await viewModel.restartGame()
        }
    }
}

struct CardView: View {
    let card: CardObject

    init(card: CardObject) {
        self.card = card
    }

    private var rotationAngle: Double {
        card.isFaceUp ? 0 : 180
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(card.isMatched ? Color.green.opacity(0.2) : Color.white)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            card.isMatched ? Color.green : Color.blue,
                            lineWidth: 2
                        )
                )
                .overlay(
                    KFImage(card.content.posterURL)
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .cornerRadius(12)
                        .clipped()
                )
                .opacity(rotationAngle < 90 ? 1 : 0)

            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                .overlay(
                    Image(systemName: "questionmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                )
                .opacity(rotationAngle >= 90 ? 1 : 0)
        }
        .aspectRatio(2 / 3, contentMode: .fit)
        .rotation3DEffect(
            Angle(degrees: rotationAngle),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .opacity(card.isMatched ? 0.6 : 1.0)
    }
}

struct FinishPopup: View {
    let score: Int
    let matches: Int
    let totalMatches: Int
    let onGoHome: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 52))
                .foregroundStyle(.yellow)

            Text("¡Partida completada!")
                .font(.title2.bold())

            VStack(spacing: 8) {
                Text("Score final")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("\(score)")
                    .font(.system(size: 44, weight: .bold, design: .rounded))

                Text("\(matches) de \(totalMatches) parejas encontradas")
                    .font(.headline)
            }

            Button(action: onGoHome) {
                Label("Volver al inicio", systemImage: "house.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(maxWidth: 360)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.5), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.25), radius: 20, y: 10)
    }
}
