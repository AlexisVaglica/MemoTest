//
//  MovieCardGenerator.swift
//  MemoTest
//
//  Created by AVaglica on 14/08/2026.
//

import Foundation

final class MoviesCardGenerator: CardGeneratorProtocol {
    let language: String = "es-AR"
    
    func generateDeck() async -> [CardObject] {
        let movies = await getMovies()
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
        
        let imageCaptureService = ImageCaptureService()
        let urls = deck.compactMap(\.content.posterURL)
        
        do {
            try await imageCaptureService.getImages(URLs: urls)
        } catch {
            print("No se pudieron precargar las imágenes: \(error.localizedDescription)")
        }
        
        return deck.shuffled()
    }
    
    private func getMovies() async -> [CardObject] {
        do {
            let urlPath = URL(string: "https://api.themoviedb.org/3/")!
            let requestClient = URLSessionClient(baseURL: urlPath)
            let repository = TMDBMovieService(requestClient: requestClient)
            let randomNumber = Int.random(in: 1...20)
            let movies = try await repository.getMovies(
                genre: .animation,
                page: randomNumber,
                language: language
            )
            return movies.prefix(8).map { $0.toCardObjectAdapter() }
        } catch(let e) {
            print(e)
            return []
        }
    }
}
