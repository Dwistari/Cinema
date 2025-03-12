//
//  APIService.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import Moya
import Foundation

enum MovieAPI {
    case getMovies(page: Int)
    case getMovieDetail(id: Int)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        return URL(string: UrlConstants.baseURL)!
    }

    var path: String {
        switch self {
        case .getMovies:
            return "/movie/popular"
        case .getMovieDetail(let id):
            return "/movie/\(id)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        let apiKey = UrlConstants.apiKey
        let params: [String: Any] = ["api_key": apiKey, "language": "en-US"]
        
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
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
        provider.request(.getMovies(page: page)) { result in
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

