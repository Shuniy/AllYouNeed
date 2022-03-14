//
//  MovieExtension.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import Foundation

extension Movie {
    static func fromDTO(dto: MovieDTO) -> Movie {
        
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            return dateFormatter
        }()
        
        let dateFormatterWithDot: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.mm.yyyy"
            return dateFormatter
        }()
        
        let yearFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter
        }()
        
        var yearText: String {
            guard let releaseDate = dto.release_date, let date = dateFormatter.date(from: releaseDate) else {
                return "n/a"
            }
            return yearFormatter.string(from: date)
        }
        
        var backdropURL: URL {
            return URL(string: "https://image.tmdb.org/t/p/w500\(dto.backdrop_path ?? "")")!
        }
        
        var posterURL: URL {
            return URL(string: "https://image.tmdb.org/t/p/w500\(dto.poster_path ?? "")")!
        }
        
        var releaseDate: String {
            guard let releaseDate = dto.release_date, let date = dateFormatter.date(from: releaseDate) else {
                return "n/a"
            }
            return dateFormatterWithDot.string(from: date)
        }
        
        return Movie(id: dto.id, title: dto.title, backdropURL: backdropURL, posterURL: posterURL, releaseDate: releaseDate, rating: "\(dto.vote_average)", overview: dto.overview)
        
    }//: fromDTO
    
}
