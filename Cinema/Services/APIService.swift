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

enum MovieAPI {
    case getPopularMovies(page: Int)
    case searchMovies(query: String, page: Int)
    case getMovieDetail(id: Int)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        return URL(string: UrlConstants.baseURL)!
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

class APIService {
    static let shared = APIService()
    private let provider = MoyaProvider<MovieAPI>()
    
    func fetchMovies(page: Int)  -> Single<[Movie]> {
        
        return provider.rx.request(.getPopularMovies(page: page))
            .map { response in
                do {
                    let decodedResponse = try JSONDecoder().decode(MovieListResponse.self, from: response.data)
                    return decodedResponse.results
                } catch {
                    throw error
                }
            }
    }
    
    func searchMovies(keyword: String, page: Int) -> Single<[Movie]> {
        return provider.rx.request(.searchMovies(query: keyword, page: page))
            .map { response in
                do {
                    let decodedResponse = try JSONDecoder().decode(MovieListResponse.self, from: response.data)
                    return decodedResponse.results
                } catch {
                    throw error
                }
            }
    }
    
    func getDetailMovie(id: Int) -> Single<MovieDetails> {
        return provider.rx.request(.getMovieDetail(id: id))
            .map {  response in
                do {
                    let decodedResponse = try JSONDecoder().decode(MovieDetails.self, from: response.data)
                    return decodedResponse
                } catch {
                    throw error
                }
                
            }
    }
}

