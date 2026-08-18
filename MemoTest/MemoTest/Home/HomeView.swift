//
//  HomeView.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//
import SwiftUI

struct HomeView: View {
    @State private var viewModel: HomeViewModelProtocol

    init(viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Image(Globals.shared.background_image_name)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            tableView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var tableView: some View {
        ScrollView {
            Image(Globals.shared.title_image_name)
                .resizable()
                .scaledToFill()
                .frame(width: 256, height: 256)
                
            Text("Selecciona un Género")
                .font(.headline)
            
            LazyVStack(spacing: 12) {
                ForEach(viewModel.genreList) { item in
                    Button {
                        viewModel.startGame(with: item.genre)
                    } label: {
                        GenreCardView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 36)
        }
        .onAppear {
            Task {
                await viewModel.refresh()
            }
        }
    }
}

private struct GenreCardView: View {
    let item: GenreHomeItem

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "film.stack.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(
                    .blue.gradient,
                    in: RoundedRectangle(cornerRadius: 12)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.genre.name)
                    .font(.headline)
                    .foregroundStyle(.black)

                if let bestScore = item.bestScore {
                    Text("Mejor score: \(bestScore)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                } else {
                    Text("Sin partidas")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray.opacity(0.8))
        }
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}
