//
//  MovieListViewModelTests.swift
//  CinemaUITests
//
//  Created by Dwistari on 13/03/25.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import Cinema

class MovieListViewModelTests: XCTestCase {
    
    var viewModel: MovieListViewModel!
    var mockAPIService: MockAPIService!
    var mockCoreDataManager: MockCoreDataManager!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = MovieListViewModel(apiService: mockAPIService)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockCoreDataManager = MockCoreDataManager()
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testLoadMovies_CachedMoviesAvailable() {
        // Given: Cached movies exist
        let cachedMovies = [Movie(id: 1, title: "Cached Movie")]
        CoreDataManager.shared.stubbedMovies = cachedMovies
        
        // When: loadMovies() is called
        viewModel.loadMovies()
        
        // Then: Cached movies should be loaded
        let movies = try? viewModel.movies.toBlocking(timeout: 2).first()
        XCTAssertEqual(movies, cachedMovies)
    }
    
    func testLoadMovies_FetchFromAPI() {
        // Given: No cached movies, fetch from API
        CoreDataManager.shared.stubbedMovies = []
        
        // When: Calling loadMovies()
        mockAPIService.shouldReturnError = false
        viewModel.loadMovies()
        
        // Then: Movies should be fetched from API
        let movies = try? viewModel.movies.toBlocking(timeout: 2).first()
        XCTAssertEqual(movies?.count, 2)
    }
    
    func testFetchMoviesFromAPI_Success() {
        // Given: API returns movies
        mockAPIService.shouldReturnError = false
        
        // When: Calling fetchMoviesFromAPI()
        viewModel.fetchMoviesFromAPI()
        
        // Then: The movies should be updated
        let movies = try? viewModel.movies.toBlocking(timeout: 2).first()
        XCTAssertEqual(movies?.count, 2)
    }
    
    func testFetchMoviesFromAPI_Failure() {
        // Given: API returns an error
        mockAPIService.shouldReturnError = true
        
        // When: Calling fetchMoviesFromAPI()
        viewModel.fetchMoviesFromAPI()
        
        // Then: An error message should be emitted
        let error = try? viewModel.errorMessage.toBlocking(timeout: 2).first()
        XCTAssertEqual(error, "The operation couldn’t be completed. (TestError error 1.)")
    }
    
    func testSearchMovies_Success() {
        // Given: API returns search results
        mockAPIService.shouldReturnError = false
        
        // When: Searching for movies
        viewModel.searchMovies(keyword: "Movie", page: 1)
        
        // Then: The results should match
        let movies = try? viewModel.movies.toBlocking(timeout: 2).first()
        XCTAssertEqual(movies?.count, 1)
    }
    
    func testSearchMovies_Failure() {
        // Given: API returns an error
        mockAPIService.shouldReturnError = true
        
        // When: Searching for movies
        viewModel.searchMovies(keyword: "Movie", page: 1)
        
        // Then: An error message should be emitted
        let error = try? viewModel.errorMessage.toBlocking(timeout: 2).first()
        XCTAssertEqual(error, "The operation couldn’t be completed. (TestError error 2.)")
    }
}
