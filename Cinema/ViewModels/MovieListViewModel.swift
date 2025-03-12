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
    var getMovieData : (() -> Void)?
    let errorMessage = PublishSubject<String>()
    var page = 1
    
    func loadMovies(page: Int) {
        let lastPage = getLastOpenedPage()
        let startPage = lastPage > 0 ? lastPage : 1
        
        if startPage == 1, isMovieListlCached() {
            let movies = getCachedMovieList()
            self.movies.accept(movies)
        } else {
            apiService.fetchMovies(page: startPage)
                  .observe(on: MainScheduler.instance)
                  .subscribe(onSuccess: { [weak self] movies in
                      
                      print("fetch moview")
                      
                      guard let self = self else { return }
                      if page > 1 {
                          let updatedMovies = (startPage > 1) ? (self.movies.value + movies) : movies
                          self.movies.accept(updatedMovies)
                          self.saveMovieList(updatedMovies, page: startPage)
                      } else {
                          self.movies.accept(movies)
                          self.saveMovieList(movies, page: startPage)
                      }
                  }, onFailure: { [weak self] error in
                      self?.errorMessage.onNext(error.localizedDescription)
                  })
                  .disposed(by: disposeBag)
        }
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
         loadMovies(page: 1)
     }
    
    func saveMovieList(_ movies: [Movie], page: Int) {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: "cachedMovies")
            UserDefaults.standard.set(page, forKey: "lastOpenedPage")
        }
    }
    
    func getCachedMovieList() -> [Movie] {
        if let savedData = UserDefaults.standard.data(forKey: "cachedMovies"),
           let decoded = try? JSONDecoder().decode([Movie].self, from: savedData) {
            return decoded
        }
        return []
    }
    
    func isMovieListlCached() -> Bool {
        let details = getCachedMovieList()
        return !details.isEmpty
    }
    
    func getLastOpenedPage() -> Int {
        return UserDefaults.standard.integer(forKey: "lastOpenedPage")
    }
}
