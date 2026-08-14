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
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.genreList, id: \.id) { genre in
                    Button {
                        viewModel.startGame(with: genre)
                    } label: {
                        GenreCardView(genre: genre)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
        .navigationTitle("Géneros")
    }
}

private struct GenreCardView: View {
    let genre: GenreObject

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "film.stack.fill")
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 12))

            Text(genre.name)
                .font(.headline)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray.opacity(0.2))
        }
        .shadow(color: .black.opacity(0.06), radius: 6, y: 3)
    }
}
