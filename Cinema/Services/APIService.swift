//
//  APIService.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import Moya
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

    func fetchMovies(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        provider.request(.getPopularMovies(page: page)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(MovieListResponse.self, from: response.data)
                    completion(.success(decodedResponse.results))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchMovies(keyword: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        provider.request(.searchMovies(query: keyword, page: 1)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(MovieListResponse.self, from: response.data)
                    print("hit-search", decodedResponse)
                    completion(.success(decodedResponse.results))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getDetailMovie(id: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        provider.request(.getMovieDetail(id: id)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedResponse = try JSONDecoder().decode(MovieDetails.self, from: response.data)
                    print("getDetailMovie", decodedResponse)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

