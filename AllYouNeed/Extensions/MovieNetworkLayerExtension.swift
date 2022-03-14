//
//  MovieNetworkLayerExtension.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 04/02/22.
//

import Foundation

extension MovieNetworkLayer {
    struct TMDBAPI {
        static let schema = "https"
        static let host = "api.themoviedb.org"
        
        fileprivate static var apiKey: String {
            get {
               // Step 1: Find the API_KEY plist file
                guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
                    fatalError("Info plist not Found!")
                }//:else
                
                // Step 2: Find the API Key
                let plist = try?NSDictionary(contentsOf: URL(fileURLWithPath: filePath), error: ())
                guard let value = plist?.object(forKey: "TMDB_API_KEY") as? String else {
                  fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
                }
                return value
            }//:Get
        }//: apiKey
    }//:TMDBAPI Struct
    
    func getComponentsForNowPlayingMoviesRequest(page: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = TMDBAPI.schema
        components.host = TMDBAPI.host
        components.path = "/3/movie/now_playing"
        
        components.queryItems = [
            .init(name: "api_key", value: TMDBAPI.apiKey),
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: "\(page)")
        ]
        
        return components
    }
    
    func getComponentsForNowUpcomingMoviesRequest(page: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = TMDBAPI.schema
        components.host = TMDBAPI.host
        components.path = "/3/movie/upcoming"
        
        components.queryItems = [
            .init(name: "api_key", value: TMDBAPI.apiKey),
            .init(name: "language", value: "en-US"),
            .init(name: "page", value: "\(page)")
        ]
        return components
    }
    
}
