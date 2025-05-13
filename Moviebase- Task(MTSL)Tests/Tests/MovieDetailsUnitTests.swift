//
//  MovieDetailsUnitTests.swift
//  Moviebase- Task(MTSL)Tests
//
//  Created by Yogi Rawat on 13/05/25.
//

import XCTest
@testable import Moviebase__Task_MTSL_

final class MovieDetailsUnitTests: XCTestCase {
 
    var viewModel: MoviesViewModel!
    var mockServices: MockMovieServices!
    var moviesRepo: MockMoviesRepository!
    
    override func setUp() {
        super.setUp()
        mockServices = MockMovieServices()
        moviesRepo = MockMoviesRepository()
        viewModel = MoviesViewModel(service: mockServices, repository: moviesRepo)
    }
    
    override func tearDown() {
        mockServices = nil
        moviesRepo = nil
        viewModel = nil
        super.tearDown()
    }

    func testAddingFavoriteMovie_Success() {
     
        let testingMovie = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABDJ2366CX", type: "movie", isFavorite: false)
        
        moviesRepo.failedAddingFavorite = false
        let result = viewModel.addMovieToFavorites(movie: testingMovie)
        
        switch result {
        case .success(let success):
            XCTAssertTrue(viewModel.favoriteIDs.contains(testingMovie.imdbID ?? ""))
            XCTAssertEqual(success, AppTexts.movie_added_to_favorite.rawValue)
         
        case .failure(let failure):
            XCTFail("Expected succuess but got failure \(failure)")
        }
    }
    
    func testAddingFavoriteMovie_Failure() {
     
        let testingMovie = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABDJ2366CX", type: "movie", isFavorite: false)
        
        moviesRepo.failedAddingFavorite = true
        moviesRepo.cdError = .could_not_mark_favorite
        let result = viewModel.addMovieToFavorites(movie: testingMovie)
        
        switch result {
        case .success(let success):
            XCTFail("Expected failure but got success \(success)")
           
        case .failure(let failure):
            XCTAssertFalse(viewModel.favoriteIDs.contains(testingMovie.imdbID ?? ""))
            XCTAssertEqual(failure,.could_not_mark_favorite)
         
        }
    }
    
    func testRemovingFavoriteMovie_Success() {
     
        let testingMovie = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABDJ2366CX", type: "movie", isFavorite: true)
        
        _ = viewModel.addMovieToFavorites(movie: testingMovie)
        XCTAssertTrue(viewModel.favoriteIDs.contains(testingMovie.imdbID ?? ""))
        
        moviesRepo.failedRemovingFavorite = false
        let result = viewModel.removeMovieFromFavorites(id: testingMovie.imdbID ?? "")
        
        switch result {
        case .success(let success):
            XCTAssertFalse(viewModel.favoriteIDs.contains(testingMovie.imdbID ?? ""))
            XCTAssertEqual(success, AppTexts.movie_removed_from_favorite.rawValue)
         
        case .failure(let failure):
            XCTFail("Expected succuess but got failure \(failure)")
        }
    }
    
    func testRemovingFavoriteMovie_Failure() {
     
        let testingMovie = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABDJ2366CX", type: "movie", isFavorite: true)
        
        _ = viewModel.addMovieToFavorites(movie: testingMovie)
        XCTAssertTrue(viewModel.favoriteIDs.contains(testingMovie.imdbID ?? ""))
        
        moviesRepo.failedRemovingFavorite = true
        moviesRepo.cdError = .could_not_remove_favorite
        let result = viewModel.removeMovieFromFavorites(id: testingMovie.imdbID ?? "")
        
        switch result {
        case .success(let success):
            XCTFail("Expected failure but got success \(success)")
            
        case .failure(let failure):
            XCTAssertTrue(viewModel.favoriteIDs.contains(testingMovie.imdbID ?? ""))
            XCTAssertEqual(failure, .could_not_remove_favorite)
         
        }
    }
}
