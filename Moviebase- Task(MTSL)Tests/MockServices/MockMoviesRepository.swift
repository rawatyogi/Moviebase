//
//  MockMoviesRepository.swift
//  Moviebase- Task(MTSL)Tests
//
//  Created by Yogi Rawat on 13/05/25.
//

import Foundation
@testable import Moviebase__Task_MTSL_

class MockMoviesRepository : MoviesRepository {
    
    var fetchingFailed = false
    var failedAddingFavorite = false
    var failedRemovingFavorite = false
    var fetchedMovies = [MoviesModel]()
    var cdError: CDErrors = .could_not_fetch
    
    func fetchFavoriteMovies() -> Result<[MoviesModel], CDErrors> {
      
        if fetchingFailed {
            return .failure(cdError)
        } else {
            return .success(fetchedMovies)
        }
    }
    
    func removeFavoriteMovie(id: String) -> Result<String, CDErrors> {
        if failedRemovingFavorite {
            return .failure(.could_not_remove_favorite)
        } else {
            if let index = self.fetchedMovies.firstIndex(where: {$0.imdbID == id}) {
                self.fetchedMovies.remove(at: index)
                return .success(AppTexts.movie_removed_from_favorite.rawValue)
            }
            return .failure(.could_not_remove_favorite)
        }
    }
    
    func addFavoriteMovie(movie: Moviebase__Task_MTSL_.MoviesModel) -> Result<String, CDErrors> {
        if failedAddingFavorite {
            return .failure(cdError)
        } else {
            self.fetchedMovies.append(movie)
            return .success(AppTexts.movie_added_to_favorite.rawValue)
        }
    }
}
