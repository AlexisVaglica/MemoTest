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
        VStack {

            Text("Parejas Encontradas: \(viewModel.pairFound)")
                .font(.title)
        }
        .navigationBarBackButtonHidden(true)
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
        .onChange(of: viewModel.gameplayState) { oldValue, newValue in
            if newValue == .mismatchDelay {
                withAnimation(.easeInOut.delay(0.5)) {
                    viewModel.clearMismatch()
                }
            }
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
