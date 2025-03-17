//
//  MovieEntity+CoreDataProperties.swift
//  Cinema
//
//  Created by Dwistari on 16/03/25.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var rating: Double
    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?

}

extension MovieEntity : Identifiable {

}
