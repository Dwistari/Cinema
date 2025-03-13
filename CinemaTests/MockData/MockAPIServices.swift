//
//  MockAPIServices.swift
//  CinemaUITests
//
//  Created by Dwistari on 13/03/25.
//


@testable import Cinema
import Foundation
import RxSwift

class MockAPIService: MovieServiceProtocol {

    var shouldReturnError = false
    
    func fetchMovies(page: Int) -> Single<[Movie]>{
        if shouldReturnError {
            let error = NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "The operation couldn’t be completed. (TestError error 1.)"])
            return Single.error(error)
        }
        let mockMovies = [Movie(id: 1, originalTitle: "Movie", overview: "Loremdipsum", posterPath: "www.image.png", voteAverage: 8.0)]
        return Single.just(mockMovies)
    }
    
    
    func searchMovies(keyword: String, page: Int) -> Single<[Movie]> {
        if shouldReturnError {
            return Single.error(NSError(domain: "TestError", code: 2, userInfo: nil))
        }
        let filteredMovies = [Movie(id: 1, originalTitle: "Movie", overview: "Loremdipsum", posterPath: "www.image.png", voteAverage: 8.0)].filter { $0.originalTitle.contains(keyword) }
        return Single.just(filteredMovies)
    }
    
    func getDetailMovie(id: Int) -> Single<MovieDetails> {
        if shouldReturnError {
            return Single.error(NSError(domain: "TestError", code: 2, userInfo: nil))
        } 
        
        let mockMovies = MovieDetails(backdropPath: "", genres: [Genre(id: 1, name: "")], id: 1, imdbID: "", originalTitle: "", overview: "", popularity: 0, posterPath: "", releaseDate: "", runtime: 10, tagline: "", voteAverage: 10)
        return Single.just(mockMovies)
    }
}
