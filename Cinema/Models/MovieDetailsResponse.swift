//
//  MovieDetailsResponse.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import Foundation

// MARK: - MovieDetails
struct MovieDetails: Decodable {
    let backdropPath: String?
    let genres: [Genre]
    let id: Int
    let imdbID: String?
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let runtime: Int
    let tagline: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genres, id
        case imdbID = "imdb_id"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case tagline
        case voteAverage = "vote_average"
    }
}


// MARK: - Genre
struct Genre: Decodable {
    let id: Int
    let name: String
}
