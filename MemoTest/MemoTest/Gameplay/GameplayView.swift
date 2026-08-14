//
//  GameplayView.swift
//  MemoTest
//
//  Created by AVaglica on 07/08/2026.
//

import Foundation
import SwiftUI

struct GameplayView: View {
    @State private var viewModel : GameplayViewModelProtocol
    
    init(viewModel: GameplayViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Parejas Encontradas: \(viewModel.pairFound)")
                .font(.title)
        }
        LazyVGrid (columns: [GridItem(.adaptive(minimum: 80))]) {
            ForEach(viewModel.cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            withAnimation(.easeInOut) {
                                viewModel.select(card)
                            }
                        }
                    }
            }
        }
        .onChange(of: viewModel.gameplayState) { oldValue, newValue in
            if newValue == .mismatchDelay {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeInOut) {
                        viewModel.clearMismatch()
                    }
                }
            }
        }
    }
}

struct CardView: View {
    let card : CardObject
    
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
                           .stroke(card.isMatched ? Color.green : Color.blue, lineWidth: 2)
                   )
                   .overlay(
                    Text(card.content.title)
                           .font(.system(size: 16))
                           .foregroundStyle(.black)
                   )
                   .opacity(rotationAngle < 90 ? 1 : 0)
               
               RoundedRectangle(cornerRadius: 12)
                   .fill(LinearGradient(
                       colors: [.blue, .purple],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing
                   ))
                   .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                   .overlay(
                       Image(systemName: "questionmark.circle.fill")
                           .font(.largeTitle)
                           .foregroundColor(.white)
                   )
                   .opacity(rotationAngle >= 90 ? 1 : 0)
           }
           .aspectRatio(2/3, contentMode: .fit)
           .rotation3DEffect(
               Angle(degrees: rotationAngle),
               axis: (x: 0.0, y: 1.0, z: 0.0)
           )
           .opacity(card.isMatched ? 0.6 : 1.0)
       }
}
