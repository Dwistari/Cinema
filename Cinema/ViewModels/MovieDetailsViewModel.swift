//
//  MovieDetailsViewModel.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import Foundation

class MovieDetailsViewModel: ObservableObject {
 
    @Published var movies: MovieDetails?
    var getDetailsMovie : (() -> Void)?
    
    func loadDetailsMovie(id: Int) {
        print("MovieDetailsViewModel", id)
        APIService.shared.getDetailMovie(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.getDetailsMovie?()
                    print("getDetailsMovie \(movies)")

                case .failure(let error):
                    print("Error fetching movies: \(error.localizedDescription)")
                }
            }
        }
    }
}
