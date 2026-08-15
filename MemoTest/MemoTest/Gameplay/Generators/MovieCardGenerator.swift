//
//  MovieCardGenerator.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

final class MoviesCardGenerator: CardGeneratorProtocol {
    let language: String = "es-AR"
    let genre: String
    
    private let imageService: ImageCaptureRepository
    private let movieService: TMDBMovieRepository
    
    private let maxPairNumber: Int = 8
    private let maxPageNumber: Int = 20
    
    init(genre: String,
         imageService: ImageCaptureRepository,
         movieService: TMDBMovieRepository) {
        self.genre = genre
        self.imageService = imageService
        self.movieService = movieService
    }
    
    func generateDeck() async -> [CardObject] {
        let movies = await getMovies(genre: genre)
        var deck: [CardObject] = []
        
        for movie in movies {
            let cardContent = CardContent(
                id: movie.content.id,
                title: movie.content.title,
                posterPath: movie.content.posterPath,
                releaseDate: movie.content.releaseDate)
            
            deck.append(CardObject(content: cardContent)) // Primera carta de la pareja
            deck.append(CardObject(content: cardContent)) // Segunda carta de la pareja
        }
        
        let urls = deck.compactMap(\.content.posterURL)
        
        do {
            try await imageService.getImages(URLs: urls)
        } catch {
            print("No se pudieron precargar las imágenes: \(error.localizedDescription)")
        }
        
        return deck.shuffled()
    }
    
    private func getMovies(genre: String) async -> [CardObject] {
        do {
            let randomNumber = Int.random(in: 1...maxPageNumber)
            let movies = try await movieService.getMovies(
                genre: genre,
                page: randomNumber,
                language: language
            )
            return movies.prefix(maxPairNumber).map { $0.toCardObjectAdapter() }
        } catch(let e) {
            print(e)
            return []
        }
    }
}
