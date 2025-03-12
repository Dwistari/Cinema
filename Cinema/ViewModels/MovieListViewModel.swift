//
//  MovieListViewModel.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import Foundation


class MovieListViewModel: ObservableObject {
 
    @Published var movies: [Movie] = []
    var getMovieData : (() -> Void)?
    
    func loadMovies() {
        APIService.shared.fetchMovies(page: 1) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.getMovieData?()
                case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func searchMovies(keyword: String) {
        APIService.shared.searchMovies(keyword: keyword) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.getMovieData?()
                    print("searchMovies \(movies)")

                case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                }
            }
        }
    }
}
