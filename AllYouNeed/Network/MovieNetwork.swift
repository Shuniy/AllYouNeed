//
//  MovieNetwork.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 04/02/22.
//

import Foundation
import Combine
//MARK: MovieNetworkProtocol
// Creating a protocol for Movie Network
protocol MovieNetwork {
    func getNowPlayingMovies(page: Int) -> AnyPublisher<MovieResponse, RequestError>
    func getUpcomingMovies(page: Int) -> AnyPublisher<MovieResponse, RequestError>
}

// Movie network layer to fetch the movies from API
// Creating Publishers to publish the data
// Publisher -> Declares that a type can transmit a sequence of values over time.
// AnyPublisher -> A publisher that performs type erasure by wrapping another publisher.
//MARK: MOVIE Network Layer
class MovieNetworkLayer: MovieNetwork {
    private let decoder = JSONDecoder()
    // Creating an extension of MovieNetworkLayer will give us the access to functions
    // Creating extension of it to create components
    
    // Fetching the data from the url
    //MARK: FETECH MOVIE RESPONSE
    func fetch<MovieNetworkModel : Codable>(url: URL?) -> AnyPublisher<MovieNetworkModel, RequestError> {
        guard let url = url else {
            // A value that represents either a success or a failure, including an associated value in each case
            return Result<MovieNetworkModel, RequestError>
                .Publisher(.failure(.invalidEndPoint))
                .eraseToAnyPublisher()
            //Erasure -> Wraps this publisher with a type eraser
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(3)
            .map (\.data)
            .decode(type: MovieNetworkModel.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .mapError{_ in return .apiError}
            .eraseToAnyPublisher()
        
    }
    
    //MARK: FETCH NOW PLAYING MOVIES
    // Getting Now Playing Movies
    func getNowPlayingMovies(page: Int) -> AnyPublisher<MovieResponse, RequestError> {
        guard let url = getComponentsForNowPlayingMoviesRequest(page: page).url else {
            return Fail<MovieResponse, RequestError>(error: .invalidEndPoint)
                .eraseToAnyPublisher()
        }
        
        let publisher: AnyPublisher<MovieResponse, RequestError> = fetch(url: url)
        return publisher.eraseToAnyPublisher()
        
    }
    
    //MARK: UPCOMING MOVIE
    //Getting Upcoming Movie
    func getUpcomingMovies(page: Int) -> AnyPublisher<MovieResponse, RequestError> {
        guard let url = getComponentsForNowUpcomingMoviesRequest(page: page).url else {
            return Fail<MovieResponse, RequestError>(error: .invalidEndPoint)
                .eraseToAnyPublisher()
        }
        
        let publisher:AnyPublisher<MovieResponse, RequestError> = fetch(url: url)
        return publisher.eraseToAnyPublisher()
        
    }
}
