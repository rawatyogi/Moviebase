//
//  MoviesUnitTests.swift
//  Moviebase- Task(MTSL)Tests
//
//  Created by Yogi Rawat on 13/05/25.
//

import XCTest
@testable import Moviebase__Task_MTSL_

final class MoviesUnitTests: XCTestCase {
 
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
    
    
    func testMovieSearchByTitle_Success() async {

        let testingMovie = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABDJ2366CX", type: "movie", isFavorite: false)
        
        mockServices.movie = testingMovie
        mockServices.apiFails = false
        
        let result = await viewModel.searchMovieByTitle(title: testingMovie.title ?? "")
        
        switch result {
        case .success:
            XCTAssertEqual(viewModel.movies.count, 1)
            XCTAssertEqual(viewModel.movies.first?.title, testingMovie.title)
            XCTAssertEqual(viewModel.movies.first?.imdbID, testingMovie.imdbID)
            
        case .failure :
            XCTFail("Search Failed")
        }
    }
    
    func testMovieSearchByTitle_NoResult() async {

        let testingMovie = MoviesModel(title: "hfe3894", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABDJ2366CX", type: "movie",response: "False", isFavorite: false)
        
        mockServices.movie = testingMovie
        mockServices.apiFails = false
        
        let result = await viewModel.searchMovieByTitle(title: testingMovie.title ?? "")
        
        switch result {
        case .success:
            XCTAssertEqual(viewModel.movies.first?.response, "False")
            
        case .failure(let failure) :
            XCTFail("Expected No Results, but received failure \(failure)")
        }
    }
    
    func testMovieSearchByTitle_ServiceFails() async {

        let testingMovie = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABDJ2366CX", type: "movie", isFavorite: false)
        
        mockServices.movie = testingMovie
        mockServices.apiFails = true
        
        let result = await viewModel.searchMovieByTitle(title: testingMovie.title ?? "")
        
        switch result {
        case .success:
            XCTFail("Expected failure but received success")
            
        case .failure(let failure) :
            XCTAssertEqual(failure, .something_went_wrong)
        }
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
    
    
    func testFetchFavoriteMovies_Success() {
        
        let testingMovie1 = MoviesModel(title: "Testing Movie", year: "2025", rated: "12+ ASD", released: "2025", runtime: "123 min", genre: "Action, Drama", plot: "Hey this is success mock", language: "English", poster: "hh", imdbID: "ABCJ2366CX", type: "movie", isFavorite: true)
        let testingMovie2 = MoviesModel(title: "Testing Movie2", year: "2025", rated: "12+ ASD2", released: "2025", runtime: "100 min", genre: "Action2, Drama2", plot: "Hey this is success mock2", language: "English, Hindi", poster: "hh2", imdbID: "XYZJ2366CX", type: "movie2", isFavorite: true)
        
        _ = viewModel.addMovieToFavorites(movie: testingMovie1)
        _ = viewModel.addMovieToFavorites(movie: testingMovie2)
        moviesRepo.fetchingFailed = false
        viewModel.fetchFavoriteMovies()
        
        XCTAssertEqual(viewModel.favoriteIDs.count, 2)
        XCTAssertEqual(viewModel.favoriteIDs, [testingMovie1.imdbID, testingMovie2.imdbID])
    }
    
    func testFetchFavoriteMovies_Failure() {
      
        moviesRepo.fetchingFailed = true
        moviesRepo.cdError = .could_not_fetch
        viewModel.fetchFavoriteMovies()
        
        XCTAssertEqual(viewModel.favoriteIDs.count, 0)
        XCTAssertEqual(viewModel.favoriteIDs, [])
    }
}
