//
//  MovieDetailsViewModel.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import Foundation
import RxSwift
import RxCocoa

class MovieDetailsViewModel {
    
    var movies = BehaviorRelay<MovieDetails?>(value: nil)
    private let disposeBag = DisposeBag()
    private let apiService: MovieServiceProtocol

    let errorMessage = PublishSubject<String>()
    
    init(apiService: MovieServiceProtocol) {
        self.apiService = apiService
    }
    
    func loadDetailsMovie(id: Int) {
        apiService.getDetailMovie(id: id)
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
}
