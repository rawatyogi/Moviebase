//
//  FavoriteUnitTests.swift
//  Moviebase- Task(MTSL)Tests
//
//  Created by Yogi Rawat on 13/05/25.
//

import XCTest
@testable import Moviebase__Task_MTSL_

final class FavoriteUnitTests: XCTestCase {

    var viewModel: FavoriteViewModel!
    var mockServices: MockMovieServices!
    var moviesRepo: MockMoviesRepository!
    
    override func setUp() {
        super.setUp()
        mockServices = MockMovieServices()
        moviesRepo = MockMoviesRepository()
        viewModel = FavoriteViewModel(movieRepoistory: moviesRepo)
    }
    
    override func tearDown() {
        mockServices = nil
        moviesRepo = nil
        viewModel = nil
        super.tearDown()
    }
  
    func testRemovingFavoriteMovie_Success() {
     
        let testingMovie = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABDJ2366CX", type: "movie", isFavorite: true)
        
        let addedResult = viewModel.addMovieToFavorites(movie: testingMovie)
      
       // XCTAssertTrue(viewModel.moviesModel.contains(where: {$0.imdbID == testingMovie.imdbID ?? ""}))
        
        moviesRepo.failedRemovingFavorite = false
        let result = viewModel.removeMovieFromFavorites(id: testingMovie.imdbID ?? "")
        
        switch result {
        case .success(let success):
            XCTAssertEqual(success, AppTexts.movie_removed_from_favorite.rawValue)
         
        case .failure(let failure):
            XCTFail("Expected succuess but got failure \(failure)")
        }
    }
    
    func testRemovingFavoriteMovie_Failure() {
     
        let testingMovie = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABDJ2366CX", type: "movie", isFavorite: true)
        
        let addedResult = viewModel.addMovieToFavorites(movie: testingMovie)
      
       // XCTAssertTrue(viewModel.moviesModel.contains(where: {$0.imdbID == testingMovie.imdbID ?? ""}))
        
        moviesRepo.failedRemovingFavorite = true
        moviesRepo.cdError = .could_not_remove_favorite
        let result = viewModel.removeMovieFromFavorites(id: testingMovie.imdbID ?? "")
        
        switch result {
        case .success(let success):
            XCTFail("Expected failure but got success \(success)")
            
        case .failure(let failure):
            XCTAssertEqual(failure, .could_not_remove_favorite)
        }
    }
    
    func testFetchFavoriteMovies_Empty() {
        moviesRepo.fetchingFailed = false
        let result = viewModel.getFavoriteMovies()

        switch result {
        case .success:
            XCTAssertEqual(viewModel.moviesModel.count, 0)
            
        case .failure(let failure):
            XCTFail("Expected success but got failure: \(failure)")
        }
    }

    
    func testFetchFavoriteMovies_Success() {
        
        let testingMovie1 = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABCJ2366CX", type: "movie", isFavorite: true)
        let testingMovie2 = MoviesModel(title: "Testing Movie2", year: "2025", rated: "12+ ASD2", released: "2025", runtime: "100 min", genre: "Action2, Drama2", plot: "Hey this is success mock2", language: "English, Hindi", poster: "hh2", imdbID: "XYZJ2366CX", type: "movie2", isFavorite: true)
        
        _ = viewModel.addMovieToFavorites(movie: testingMovie1)
        _ = viewModel.addMovieToFavorites(movie: testingMovie2)
        
        moviesRepo.fetchingFailed = false
        let result = viewModel.getFavoriteMovies()
        
        switch result {
        case .success(let success):
            XCTAssertEqual(viewModel.moviesModel.count, 2)
            
        case .failure(let failure):
            XCTFail("Expected success but got failure \(failure)")
        }
    }
    
    func testFetchFavoriteMovies_Failure() {
      
        let testingMovie1 = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABCJ2366CX", type: "movie", isFavorite: true)
        let testingMovie2 = MoviesModel(title: "Testing Movie2", year: "2025", rated: "12+ ASD2", released: "2025", runtime: "100 min", genre: "Action2, Drama2", plot: "Hey this is success mock2", language: "English, Hindi", poster: "hh2", imdbID: "XYZJ2366CX", type: "movie2", isFavorite: true)
        
        _ = viewModel.addMovieToFavorites(movie: testingMovie1)
        _ = viewModel.addMovieToFavorites(movie: testingMovie2)
        
        moviesRepo.fetchingFailed = true
        let result = viewModel.getFavoriteMovies()
        
        switch result {
        case .success(let success):
            XCTFail("Expected failure but got success \(success)")
           
            
        case .failure(let failure):
            XCTAssertEqual(viewModel.moviesModel.count, 0)
            XCTAssertEqual(failure, .could_not_fetch)
        }
    }
}
