//
//  MoviesModel.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 10/05/25.
//

import Foundation

struct MoviesModel : Codable {
  
    let title : String?
    let year : String?
    let rated : String?
    let released : String?
    let runtime : String?
    let genre : String?
    let director : String?
    let writer : String?
    let actors : String?
    let plot : String?
    let language : String?
    let country : String?
    let awards : String?
    let poster : String?
    let ratings : [Ratings]?
    let metascore : String?
    let imdbRating : String?
    let imdbVotes : String?
    let imdbID : String?
    let type : String?
    let dVD : String?
    let boxOffice : String?
    let production : String?
    let website : String?
    let response : String?
    var isFavorite: Bool = false
    enum CodingKeys: String, CodingKey {

        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating = "imdbRating"
        case imdbVotes = "imdbVotes"
        case imdbID = "imdbID"
        case type = "Type"
        case dVD = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        year = try values.decodeIfPresent(String.self, forKey: .year)
        rated = try values.decodeIfPresent(String.self, forKey: .rated)
        released = try values.decodeIfPresent(String.self, forKey: .released)
        runtime = try values.decodeIfPresent(String.self, forKey: .runtime)
        genre = try values.decodeIfPresent(String.self, forKey: .genre)
        director = try values.decodeIfPresent(String.self, forKey: .director)
        writer = try values.decodeIfPresent(String.self, forKey: .writer)
        actors = try values.decodeIfPresent(String.self, forKey: .actors)
        plot = try values.decodeIfPresent(String.self, forKey: .plot)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        awards = try values.decodeIfPresent(String.self, forKey: .awards)
        poster = try values.decodeIfPresent(String.self, forKey: .poster)
        ratings = try values.decodeIfPresent([Ratings].self, forKey: .ratings)
        metascore = try values.decodeIfPresent(String.self, forKey: .metascore)
        imdbRating = try values.decodeIfPresent(String.self, forKey: .imdbRating)
        imdbVotes = try values.decodeIfPresent(String.self, forKey: .imdbVotes)
        imdbID = try values.decodeIfPresent(String.self, forKey: .imdbID)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        dVD = try values.decodeIfPresent(String.self, forKey: .dVD)
        boxOffice = try values.decodeIfPresent(String.self, forKey: .boxOffice)
        production = try values.decodeIfPresent(String.self, forKey: .production)
        website = try values.decodeIfPresent(String.self, forKey: .website)
        response = try values.decodeIfPresent(String.self, forKey: .response)
    }

}


struct Ratings : Codable {
    let source : String?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case source = "Source"
        case value = "Value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        source = try values.decodeIfPresent(String.self, forKey: .source)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}

extension MoviesModel {
    init(title: String?,
         year: String?,
         rated: String?,
         released: String?,
         runtime: String?,
         genre: String?,
         director: String? = nil,
         writer: String? = nil,
         actors: String? = nil,
         plot: String?,
         language: String?,
         country: String? = nil,
         awards: String? = nil,
         poster: String?,
         ratings: [Ratings]? = nil,
         metascore : String? = nil,
         imdbRating : String? = nil,
         imdbVotes : String? = nil,
         imdbID: String?,
         type: String?,
         dVD : String? = nil,
         boxOffice : String? = nil,
         production : String? = nil,
         website : String? = nil,
         response : String? = nil,
         isFavorite: Bool) {

        self.title = title
        self.year = year
        self.rated = rated
        self.released = released
        self.runtime = runtime
        self.genre = genre
        self.director = director
        self.writer = writer
        self.actors = actors
        self.plot = plot
        self.language = language
        self.country = country
        self.awards = awards
        self.poster = poster
        self.ratings = ratings
        self.metascore = metascore
        self.imdbRating = imdbRating
        self.imdbVotes = imdbVotes
        self.imdbID = imdbID
        self.type = type
        self.dVD = dVD
        self.boxOffice = boxOffice
        self.production = production
        self.website = website
        self.response = response
        self.isFavorite = isFavorite
    }
}
