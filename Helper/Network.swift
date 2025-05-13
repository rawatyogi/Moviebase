//
//  Network.swift
//  Moviebase- Task(MTSL)
//
//  Created by Yogi Rawat on 09/05/25.
//

import Foundation


 protocol Services {
    func fetchMovieByTitle(title: String) async -> Result<MoviesModel, AppServerErrors>
}

class MoviesServices: Services {
    
    //Fetching movies from server : This server only serves one movie per search
    func fetchMovieByTitle(title: String) async -> Result<MoviesModel, AppServerErrors> {
        
        let urlString = BaseURL.baseURL + "&t=\(title)"
        guard let url = URL(string: urlString) else { return .failure(.something_went_wrong) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        AppLogs.shared.debugLogs("REQUEST OF : \(urlRequest)")
       
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let response = (response as? HTTPURLResponse), response.statusCode == 200 else {
                return .failure(.something_went_wrong)
            }
         
            let decoded = try JSONDecoder().decode(MoviesModel.self, from: data)
            AppLogs.shared.debugLogs("SERVER RESPONSE : \n \n \(decoded)")
            return (decoded.response == "True") ? .success(decoded) : .failure(.data_not_found)
        }
        catch {
            return .failure(.something_went_wrong)
        }
    }
}
