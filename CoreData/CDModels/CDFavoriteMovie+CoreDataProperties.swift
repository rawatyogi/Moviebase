//
//  CDFavoriteMovie+CoreDataProperties.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 11/05/25.
//
//

import Foundation
import CoreData


extension CDFavoriteMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDFavoriteMovie> {
        return NSFetchRequest<CDFavoriteMovie>(entityName: "CDFavoriteMovie")
    }

    @NSManaged public var title: String?
    @NSManaged public var year: String?
    @NSManaged public var poster: String?
    @NSManaged public var imdbID: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var runtime: String?
    @NSManaged public var rated: String?
    @NSManaged public var type: String?
    @NSManaged public var genre: String?
    @NSManaged public var plot: String?
    @NSManaged public var language: String?

}

extension CDFavoriteMovie : Identifiable {

}
