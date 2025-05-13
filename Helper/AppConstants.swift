//
//  AppConstants.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import Foundation
import UIKit

//MARK: APP TEXT SECTION
enum AppTexts: String {
    case welcome_to_moviebase = "Welcome to Moviebase"
    case favorite_movies = "Favorite Movies"
    case released_on = "Released on"
    
    case offline_msg = "You’re offline. Please check your connection."
    case no_data_found = "We couldn’t find any movies for your search."
    case try_again_msg = "The connection is a bit dramatic right now. Try again in a few moments."
    case search_movie = "Enter a title and see what’s playing."
    case add_favorite_movie = "Looks a little empty here! Add your favorite movie and start your watchlist adventure 🍿✨"
    case  favorite_your_movie = "Favorite Your Movie"
    case  movie_added_to_favorite = "Your movie added to favorites"
    case  movie_not_added_to_favorite = "Your movie could not be added to favorites"
    case  movie_not_removed_from_favorite = "Your movie could not be removed from favorites"
    case  movie_removed_from_favorite = "Your movie removed from favorites"
    case unfavorite = "Unfavorite"
    case favorite = "Favorite"
    case unknownError = "Unknown Error"
}

//MARK: ERROR SECTION
enum AppServerErrors: Error {
    case request_failed //request did not succeeded
    case data_not_found //request succeeded but no data
    case something_went_wrong //Unknown error
    
    var errorMessage: String {
        switch self {
        case .request_failed:
            return "Request failed, Please check your connection"
            
        case .data_not_found:
            return "A movie of your choice could not be found!"
            
        case .something_went_wrong:
            return "Something went wrong! Try Again"
        }
    }
}

//MARK: DATABASE CONSTANTS SECTION
struct OMDBConstants {
    static var omdbID = "tt3896198"
    static var apiKey = "5c8f24e"
}

//MARK: URL SECTION
class BaseURL {
     static let base = "http://www.omdbapi.com"
     static var baseURL: String {
        return base + "/?&apikey=\(OMDBConstants.apiKey)"
    }
}


//MARK: LOGGIONG SECTION
struct AppLogs {
   
    private init() {}
    static var shared = AppLogs()
    
    func debugLogs<T>(_ toPrint: T) {
        debugPrint(toPrint)
    }
}


struct DeviceType {
    
    private init() {}
    static var shared = DeviceType()
    
    var iPadDevice: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var iPhoneDevice: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
}

//MARK: CORE DATA ERRORS
enum CDErrors: Error {
    case could_not_fetch
    case could_not_remove_favorite
    case could_not_mark_favorite
}


enum FavoriteOperations {
    case markFavorite
    case unfavorite
}
