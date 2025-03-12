//
//  MovieListViewModel.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import Foundation
import RxSwift
import RxCocoa

class MovieListViewModel: ObservableObject {
    
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    let movies = BehaviorRelay<[Movie]>(value: [])
    let errorMessage = PublishSubject<String>()
    let currentPage = BehaviorRelay<Int>(value: 1)

    func loadMovies() {
        CoreDataManager.shared.fetchMovies()
            .subscribe(onNext: { [weak self] cachedMovies in
                guard let self = self else { return }
                if cachedMovies.isEmpty {
                    self.fetchMoviesFromAPI()
                } else {
                    let currentPage = self.currentPage.value
                    if currentPage > 1 {
                        let currentMovies = self.movies.value
                        self.movies.accept(cachedMovies + currentMovies)
                    } else {
                        self.movies.accept(cachedMovies)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchMoviesFromAPI() {
        let currentPage = self.currentPage.value
        apiService.fetchMovies(page: currentPage)
              .observe(on: MainScheduler.instance)
              .subscribe(onSuccess: { [weak self] movies in
                  guard let self = self else { return }
                  if currentPage > 1 {
                      let updatedMovies = self.movies.value + movies
                      self.movies.accept(updatedMovies)
                      self.saveMoviesToCoreData(updatedMovies, currentPage: currentPage)
                  } else {
                      self.movies.accept(movies)
                      self.saveMoviesToCoreData(movies, currentPage: currentPage)
                  }
              }, onFailure: { [weak self] error in
                  self?.errorMessage.onNext(error.localizedDescription)
              })
              .disposed(by: disposeBag)
    }
    
    func searchMovies(keyword: String, page: Int) {
        apiService.searchMovies(keyword: keyword, page: page)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] movies in
                self?.movies.accept(movies)
            }, onFailure: { [weak self] error in
                self?.errorMessage.onNext(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func refreshMovies() {
         movies.accept([])
         currentPage.accept(1)
         fetchMoviesFromAPI()
     }
    
    func loadMoreMovies() {
         let nextPage = currentPage.value + 1
         currentPage.accept(nextPage)
         UserDefaults.standard.set(nextPage, forKey: "currentPage")
         fetchMoviesFromAPI()
     }
    
    private func saveMoviesToCoreData(_ movies: [Movie], currentPage: Int) {
        CoreDataManager.shared.saveMovies(movies, currentPage: currentPage)
            .subscribe(
                onCompleted: { print("Movies saved to Core Data") },
                onError: { error in print("Failed to save movies: \(error)") }
            )
            .disposed(by: disposeBag)
    }
}
