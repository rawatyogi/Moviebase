//
//  DetailsViewModel.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 12/05/25.
//

import Foundation

class DetailsViewModel: MovieOperationProvider {
    
    var cdOperations: MoviesRepository
    init(cdOperations: MoviesRepository) {
        self.cdOperations = cdOperations
    }
    
    //MARK: Operation: CD Favorite
    func addMovieToFavorites(movie: MoviesModel) -> Result<String, CDErrors>{
        let result = cdOperations.addFavoriteMovie(movie: movie)
        
        switch result {
        case .success(let successMessage):
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
            AppLogs.shared.debugLogs("Movie could not be removed from favorites")
            return .success(successMessage)
            
        case .failure(let failure):
            AppLogs.shared.debugLogs("Movie could not be removed from favorites")
            return .failure(failure)
        }
    }
}
