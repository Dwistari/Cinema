//
//  MockAPIServices.swift
//  CinemaUITests
//
//  Created by Dwistari on 13/03/25.
//


@testable import Cinema
import Foundation
import RxSwift

class MockAPIService {
    var shouldReturnError = false
    
    func fetchMovies(page: Int) -> Single<[Movie]> {
        if shouldReturnError {
            return Single.error(NSError(domain: "TestError", code: 1, userInfo: nil))
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
    
    func getMoviesDetail(keyword: String, page: Int) -> Single<[MovieDetails]> {
        if shouldReturnError {
            return Single.error(NSError(domain: "TestError", code: 2, userInfo: nil))
        }
        let filteredMovies = [MovieDetails(adult: false, backdropPath: "", budget: 0, genres: [Genre(id: 1, name: "")], homepage: "", id: 1, imdbID: "", originCountry: [""], originalLanguage: "", originalTitle: "", overview: "", popularity: 0, posterPath: "", releaseDate: "", revenue: 1, runtime: 1, status: "", tagline: "", title: "", video: false, voteAverage: 8.0, voteCount: 100)].filter { $0.originalTitle.contains(keyword) }
        return Single.just(filteredMovies)
    }
}
