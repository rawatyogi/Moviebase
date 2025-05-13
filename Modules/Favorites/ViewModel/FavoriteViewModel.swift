//
//  FavoriteViewModel.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 11/05/25.
//

import Foundation

protocol MovieOpeartionProvider {
    func removeMovieFromFavorites(id: String)-> Result<String, CDErrors>
    func addMovieToFavorites(movie: MoviesModel) -> Result<String, CDErrors>
}

class FavoriteViewModel: MovieOpeartionProvider {
    
    //MARK: PROPERTIES
    var moviesModel: [MoviesModel] = []
    let movieRepoistory: MoviesRepository
    
    init(movieRepoistory: MoviesRepository) {
        self.movieRepoistory = movieRepoistory
    }
    
    //MARK: FETCH THE FAVORITE MOVIES FROM LOCAL DATABASE
    func getFavoriteMovies() -> Result<[MoviesModel], CDErrors> {
        
        let results = movieRepoistory.fetchFavoriteMovies()
        
        switch results {
        case .success(let success):
            self.moviesModel = success
            return .success(success)
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    //MARK: Operation: CD Favorite
    func addMovieToFavorites(movie: MoviesModel) -> Result<String, CDErrors>{
        let result = movieRepoistory.addFavoriteMovie(movie: movie)
        
        switch result {
        case .success(let succuessMessage):
            AppLogs.shared.debugLogs("Movie Added to favorites")
            return .success(succuessMessage)
            
        case .failure(let failure):
            AppLogs.shared.debugLogs("Movie could not be added to favorites")
            return .failure(failure)
        }
    }
    
    //MARK: Operation: CD Unfavorite
    func removeMovieFromFavorites(id: String)-> Result<String, CDErrors>{
        let result = movieRepoistory.removeFavoriteMovie(id: id)
        switch result {
        case .success(let succuessMessage):
            AppLogs.shared.debugLogs("Movie removed from favorites")
            return .success(succuessMessage)
            
        case .failure(let failure):
            AppLogs.shared.debugLogs("Movie could not be removed from favorites")
            return .failure(failure)
        }
    }
}
