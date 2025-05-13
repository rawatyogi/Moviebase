//
//  MoviesViewModel.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 10/05/25.
//

import Foundation

class MoviesViewModel: MovieOperationProvider {
    
    //PROPERTIES
    var service: Services
    var movies: [MoviesModel] = []
    var favoriteIDs: [String] = []
    var cdOperations: MoviesRepository
    
    init(service: Services, repository: MoviesRepository) {
        self.service = service
        self.cdOperations = repository
    }
    
    //MARK: Service: For searching a movie
    func searchMovieByTitle(title: String) async -> Result<Void, AppServerErrors> {
        let response = await service.fetchMovieByTitle(title: title)
        
        self.movies = []
        
        switch response {
            
        case .success(let success):
            
            //whenver a new item is searched it is matched with favorite IDs if its ID exist in the array the UI is displayed as favorite else unfavorite.
            var movie = success
            movie.isFavorite = favoriteIDs.contains(movie.imdbID ?? "")
            
            self.movies = [movie]
            return .success(())
            
        case .failure(let failure):
            return .failure(failure)
        }
    }
    
    //MARK: Operation: CD Favorite
    func addMovieToFavorites(movie: MoviesModel) -> Result<String, CDErrors>{
        let result = cdOperations.addFavoriteMovie(movie: movie)
        
        switch result {
        case .success(let successMessage):
            if let id = movie.imdbID {
              favoriteIDs.append(id)
            }
            AppLogs.shared.debugLogs("Movie Added to favorites")
            return .success(successMessage)
            
        case .failure(let failure):
            AppLogs.shared.debugLogs("Movie could not be added to favorites")
            return .failure(failure)
        }
    }
    
    //MARK: Operation: CD Unfavorite
    func removeMovieFromFavorites(id: String)-> Result<String, CDErrors>{
        let result = cdOperations.removeFavoriteMovie(id: id)
        switch result {
        case .success(let successMessage):
            favoriteIDs.removeAll { $0 == id }
            AppLogs.shared.debugLogs("Movie removed from favorites")
            return .success(successMessage)
            
        case .failure(let failure):
            AppLogs.shared.debugLogs("Movie could not be removed from favorites")
            return .failure(failure)
        }
    }
    
    //MARK: Operation: Get favorite movies
    func fetchFavoriteMovies() {
        let result = cdOperations.fetchFavoriteMovies()
        
        switch result {
        case .success(let success):
            let movies = success
            self.favoriteIDs = movies.map{ $0.imdbID ?? ""}
            
        case .failure(_):
            AppLogs.shared.debugLogs("Could not load favorite movies to map")
        }
    }
}
