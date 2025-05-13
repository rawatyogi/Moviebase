//
//  MockMovieServices.swift
//  Moviebase- Task(MTSL)Tests
//
//  Created by Yogi Rawat on 13/05/25.
//


import Foundation

@testable import Moviebase__Task_MTSL_

class MockMovieServices: Services {
   
    var apiFails = false
    var movie: MoviesModel?
    var error: AppServerErrors = .data_not_found
    
    func fetchMovieByTitle(title: String) async -> Result<MoviesModel, AppServerErrors> {
      
        if apiFails{
            return .failure(error)
        } else if let movie = self.movie {
            return .success(movie)
        } else {
            return .failure(.data_not_found)
        }
    }
}
