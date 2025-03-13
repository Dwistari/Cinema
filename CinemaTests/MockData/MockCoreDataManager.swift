//
//  MockCoreDataManager.swift
//  CinemaTests
//
//  Created by Dwistari on 13/03/25.
//

@testable import Cinema
import RxSwift

class MockCoreDataManager: CoreDataManager {
    
    let mockMoviesSubject = ReplaySubject<[Movie]>.create(bufferSize: 1)

    
    override func fetchMovies() -> Observable<[Movie]> {
        return mockMoviesSubject.asObservable()
     }
}
