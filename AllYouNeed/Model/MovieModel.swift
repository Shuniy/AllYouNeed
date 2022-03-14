//
//  MovieModel.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 04/02/22.
//

import Foundation

// This is the model for movie we will be using for the project
struct Movie: Identifiable {
    let id: Int
    var title: String
    var backdropURL: URL
    var posterURL: URL
    var releaseDate: String
    var rating: String
    var overview: String
}

// This will be the structure of movie data we will get from response
// Following are the data we will receive for movie
struct MovieDTO: Codable {
    let id: Int
    let title: String
    let backdrop_path: String?
    let poster_path: String?
    let overview: String
    let vote_average: Double
    let release_date: String?
}

// Will get Response depending on page numberm with total number of pages
// And the movie results with type MovieDTO(Movie Data Transferable Object)
struct MovieResponse: Codable {
    let page: Int
    let total_pages: Int
    let results: [MovieDTO]
}

