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
  
    // Initialisation objek / dependensi
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = MovieListViewModel(apiService: mockAPIService)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockCoreDataManager = MockCoreDataManager()
    }
    
    // Clean objek after each test case done
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }
    
    
    func testFetchMoviesFromAPI_Success() {
        // Given: API returns movies
        mockAPIService.shouldReturnError = false
        
        // When: Calling fetchMoviesFromAPI()
        viewModel.fetchMoviesFromAPI()
        
        // Then: The movies should be updated
        let movies = try? viewModel.movies.toBlocking(timeout: 2).first()
        XCTAssertEqual(movies?.count, 1)
    }
    
    func testFetchMoviesFromAPI_Failure() {
        // Given: API returns an error
        mockAPIService.shouldReturnError = true
        
        // When: Calling fetchMoviesFromAPI()
        viewModel.fetchMoviesFromAPI()
        
        let error = try? viewModel.errorMessage.toBlocking(timeout: 2).first()
        
        // Then: An error message should be emitted
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
