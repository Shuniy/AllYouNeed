//
//  NewsFeedModel.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 09/02/22.
//

import Foundation
import SwiftUI

struct NewsFeedModel: Codable {
    var articles: [Article]
    
    struct Article: Codable, Identifiable {
        var id = UUID()
        var source: Source
        var author: String?
        var title: String?
        var description: String?
        var url: String?
        var urlToImage: String?
        var publishedAt: String?
        
        enum CodingKeys: String, CodingKey {
            case source
            case author
            case title
            case description
            case url
            case urlToImage
            case publishedAt
        }
        
        struct Source: Codable {
            var source_id: String?
            var name: String?
            
            enum CodingKeys: String, CodingKey {
                case source_id = "id"
                case name
            }
        }
    }
}
