//
//  APIService.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import Moya
import RxSwift
import RxMoya
import Foundation


protocol MovieServiceProtocol {
    func fetchMovies(page: Int) -> Single<[Movie]>
    func searchMovies(keyword: String, page: Int) -> Single<[Movie]>
    func getDetailMovie(id: Int) -> Single<MovieDetails>
}

// Represents endpoints
enum MovieAPI {
    case getPopularMovies(page: Int)
    case searchMovies(query: String, page: Int)
    case getMovieDetail(id: Int)
}

// Implementasi TargetType (Moya Protocol)
extension MovieAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: UrlConstants.baseURL) else {
               fatalError("Invalid Base URL")
           }
           return url
    }
    
    var path: String {
        switch self {
        case .getPopularMovies:
            return "/movie/popular"
        case .getMovieDetail(let id):
            return "/movie/\(id)"
        case .searchMovies:
            return "/search/movie"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getPopularMovies(let page):
            return .requestParameters(
                parameters: [ "page": page],
                encoding: URLEncoding.default
            )
            
        case .searchMovies(let query, let page):
            return .requestParameters(
                parameters: ["query": query,"page": page],
                encoding: URLEncoding.default
            )
            
        case .getMovieDetail:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return [
            "Authorization": "Bearer \(UrlConstants.bearerToken)",
            "Accept": "application/json"
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

class APIService: MovieServiceProtocol {
    static let shared = APIService()
    private var provider = MoyaProvider<MovieAPI>()
   
    init(provider: MoyaProvider<MovieAPI> = MoyaProvider<MovieAPI>()) {
           self.provider = provider
       }
    
    func fetchMovies(page: Int)  -> Single<[Movie]> {
        return provider.rx.request(.getPopularMovies(page: page))
            .map { response in
                let decodedResponse = try JSONDecoder().decode(MovieListResponse.self, from: response.data)
                return decodedResponse.results
            }
    }
    
    func searchMovies(keyword: String, page: Int) -> Single<[Movie]> {
        return provider.rx.request(.searchMovies(query: keyword, page: page))
            .map { response in
                let decodedResponse = try JSONDecoder().decode(MovieListResponse.self, from: response.data)
                return decodedResponse.results
            }
    }
    
    func getDetailMovie(id: Int) -> Single<MovieDetails> {
        return provider.rx.request(.getMovieDetail(id: id))
            .map {  response in
                let decodedResponse = try JSONDecoder().decode(MovieDetails.self, from: response.data)
                return decodedResponse
            }
    }
}

