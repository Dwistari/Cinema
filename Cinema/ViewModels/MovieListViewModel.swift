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
        apiService.fetchMovies(page: page)
              .observe(on: MainScheduler.instance)
              .subscribe(onSuccess: { [weak self] movies in
                  guard let self = self else { return }
                  if page > 1 {
                      self.movies.accept(self.movies.value + movies)
                  } else {
                      self.movies.accept(movies)
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
    
    func loadMoreMovies() {
           let nextPage = page + 1
           loadMovies(page: nextPage)
       }
}
