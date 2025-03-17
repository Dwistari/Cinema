//
//  MovieListViewModel.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewModel {
    
    private let disposeBag = DisposeBag()
    private let apiService: MovieServiceProtocol
    private let coreDataManager: CoreDataManager

    let movies = BehaviorRelay<[Movie]>(value: [])
    let errorMessage = ReplaySubject<String>.create(bufferSize: 1)
    let currentPage = BehaviorRelay<Int>(value: 1)
    
    init(apiService: MovieServiceProtocol, coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.apiService = apiService
        self.coreDataManager = coreDataManager
    }

    func loadMovies() {
        coreDataManager.fetchMovies()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cachedMovies in
                guard let self = self else { return }
                if cachedMovies.isEmpty {
                    
                    self.fetchMoviesFromAPI()
                } else {
                    let newMovies = self.currentPage.value > 1 ? self.movies.value + cachedMovies : cachedMovies
                    self.movies.accept(newMovies)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchMoviesFromAPI() {
        let currentPage = self.currentPage.value
        apiService.fetchMovies(page: currentPage)
            .observe(on: MainScheduler.instance) // Process on mainthread
            .subscribe(onSuccess: { [weak self] movies in 
                guard let self = self else { return }
                if movies.isEmpty {return} // Stop pagination when movies is empty
               
                let updatedMovies = currentPage > 1 ? self.movies.value + movies : movies
                self.movies.accept(updatedMovies)
                self.saveMoviesToCoreData(updatedMovies)

            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                self.errorMessage.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func searchMovies(keyword: String, page: Int) {
        apiService.searchMovies(keyword: keyword, page: page)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] movies in
                guard let self = self else { return }
                self.movies.accept(movies)
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                self.errorMessage.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func clearMoviesInCoreData() {
        coreDataManager.clearMovies()
            .subscribe(
                onCompleted: { [weak self] in
                    guard self != nil else { return }
                    print("Movies cleared from Core Data")
                },
                onError: { [weak self] error in
                    guard let _ = self else { return }
                    print("Failed to clear movies: \(error)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    func refreshMovies() {
         movies.accept([])
         currentPage.accept(1)
         clearMoviesInCoreData()
         fetchMoviesFromAPI()
     }
    
    func loadMoreMovies() {
         let nextPage = currentPage.value + 1
         currentPage.accept(nextPage)
         fetchMoviesFromAPI()
     }
    
    private func saveMoviesToCoreData(_ movies: [Movie]) {
        coreDataManager.saveMovies(movies)
            .subscribe(
                onCompleted: { print("Movies saved to Core Data") },
                onError: { error in print("Failed to save movies: \(error)") }
            )
            .disposed(by: disposeBag)
    }
}
