//
//  Factory.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import UIKit
import Foundation


protocol PlaceholdersView{
    func getPlaceholderViews(type: PlaceholderType, placeholderMessage: String) -> UIView
}

class PlaceholderViewFactory: PlaceholdersView {
    
    func getPlaceholderViews(type: PlaceholderType, placeholderMessage: String) -> UIView {
        guard let view = SearchMoviesView.loadViewFromNib() as? SearchMoviesView else { return UIView() }
        view.placeholderType = type
        view.placeholderMessage = placeholderMessage
        return view
    }
}

enum PlaceholderType {
    case noMovies
    case noDataFound
    case requestFailed
    case somethingUnexpected
    case noFavoriteMovideAdded
    
    var placeholderImage: String {
        
        switch self {
        case .noMovies: return "search_movies"
            
        case .noDataFound: return "no_movies_found"
            
        case .requestFailed: return "connection_error"
            
        case .somethingUnexpected: return "request_failed"
            
        case .noFavoriteMovideAdded: return "no_fav_movies_added"
        }
    }
}


