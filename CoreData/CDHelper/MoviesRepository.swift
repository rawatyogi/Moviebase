//
//  MoviesRepository.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 11/05/25.
//

import CoreData
import Foundation

protocol MoviesRepository {
    func fetchFavoriteMovies() -> Result<[MoviesModel], CDErrors>
    func removeFavoriteMovie(id: String) -> Result<String, CDErrors>
    func addFavoriteMovie(movie: MoviesModel) -> Result<String, CDErrors>
}

class CDMovieManager: MoviesRepository {
  
    //MAR: FETCH ALL THE MARKED FAVORITE MOVIES
    func fetchFavoriteMovies() -> Result<[MoviesModel], CDErrors> {
        
        let context = CDHelper.shared.persistentContainer.viewContext
        let request: NSFetchRequest<CDFavoriteMovie> = CDFavoriteMovie.fetchRequest()
        
        do {
            let cdMovies = try context.fetch(request)
            
            let movies: [MoviesModel] = cdMovies.map { cdMovie in
                
                let movie = MoviesModel(title: cdMovie.title, year: cdMovie.year, rated: cdMovie.rated, released: cdMovie.year, runtime: cdMovie.runtime, genre: cdMovie.genre, plot: cdMovie.plot, language: cdMovie.language, poster: cdMovie.poster, imdbID: cdMovie.imdbID, type: cdMovie.type, isFavorite: cdMovie.isFavorite)
                return movie
            }
            
            return .success(movies)
            
        } catch(let error) {
            AppLogs.shared.debugLogs(error.localizedDescription)
            return .failure(.could_not_fetch)
        }
    }
    
    //MAR: REMOVE A MARKED FAVORITE MOVIE
    func removeFavoriteMovie(id: String) -> Result<String, CDErrors>{
        
        let context = CDHelper.shared.persistentContainer.viewContext
        let request: NSFetchRequest<CDFavoriteMovie> = CDFavoriteMovie.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "imdbID == %@", id as CVarArg)
        request.predicate = predicate
        
        do {
            let movies = try context.fetch(request)
            if let movieToUnfavorite = movies.first {
                context.delete(movieToUnfavorite)
                try context.save()
                return .success(AppTexts.movie_removed_from_favorite.rawValue)
            }
            return .failure(.could_not_remove_favorite)
            
        } catch(let error) {
            AppLogs.shared.debugLogs(error.localizedDescription)
            return .failure(.could_not_remove_favorite)
        }
    }
    
    //MAR:ADD A FAVORITE MOVIE
    func addFavoriteMovie(movie: MoviesModel) -> Result<String, CDErrors> {
        
        let context = CDHelper.shared.persistentContainer.viewContext
        
        let favouriteMovie = CDFavoriteMovie(context: context)
        favouriteMovie.plot = movie.plot ?? ""
        favouriteMovie.title = movie.title ?? ""
        favouriteMovie.genre = movie.genre ?? ""
        favouriteMovie.imdbID = movie.imdbID ?? ""
        favouriteMovie.year = movie.released ?? ""
        favouriteMovie.poster = movie.poster ?? ""
        favouriteMovie.rated = movie.rated ?? ""
        favouriteMovie.runtime = movie.runtime ?? ""
        favouriteMovie.type = movie.type ?? ""
        favouriteMovie.isFavorite = movie.isFavorite
        favouriteMovie.language = movie.language ?? ""
       
        do {
            try context.save()
            return .success(AppTexts.movie_added_to_favorite.rawValue)
            
        }catch(let error) {
            AppLogs.shared.debugLogs(error.localizedDescription)
            return .failure(.could_not_mark_favorite)
        }
    }
}
