//
//  CoreDataManager.swift
//  Cinema
//
//  Created by Dwistari on 12/03/25.
//

import CoreData
import RxSwift

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext

    init() {
        persistentContainer = NSPersistentContainer(name: "MoviesModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        context = persistentContainer.viewContext
    }
    
    // MARK: - Save Movie List
    func saveMovies(_ movies: [Movie], currentPage: Int) -> Completable {
        return Completable.create { completable in
            self.context.perform {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MovieEntity.fetchRequest()
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try self.context.execute(deleteRequest)
                    for movie in movies {
                        let entity = MovieEntity(context: self.context)
                        entity.id = Int64(movie.id)
                        entity.title = movie.originalTitle
                        entity.overview = movie.overview
                        entity.rating = movie.voteAverage
                        entity.posterPath = movie.posterPath
                    }
                    
                    try self.context.save()
                    completable(.completed)
                } catch {
                    completable(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Fetch Movies
    func fetchMovies() -> Observable<[Movie]> {
        return Observable.create { observer in
            self.context.perform {
                let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
                
                do {
                    let movieEntities = try self.context.fetch(fetchRequest)
                    let movies = movieEntities.map { entity in
                        return Movie(id: Int(entity.id), originalTitle: entity.title ?? "", overview: entity.overview ?? "", posterPath: entity.posterPath ?? "" , voteAverage: entity.rating)
                    }
                    observer.onNext(movies)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Clear Data
    func clearMovies() -> Completable {
        return Completable.create { completable in
            let context = self.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MovieEntity.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            
            return Disposables.create()
        }
    }
    
}
