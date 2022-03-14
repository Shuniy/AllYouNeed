//
//  CovidStatsNetworkLayerExtension.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 08/02/22.
//

import Foundation
extension CovidStatsNetworkLayer {
    struct CoronaAPI {
        static let schema = "https"
        static let host = "corona.lmao.ninja"
        
        fileprivate static var newsAPIKey: String {
            get {
               // Step 1: Find the API_KEY plist file
                guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
                    fatalError("plist not Found!")
                }//:else
                
                // Step 2: Find the API Key
                let plist = try?NSDictionary(contentsOf: URL(fileURLWithPath: filePath), error: ())
                guard let value = plist?.object(forKey: "News_API_KEY") as? String else {
                  fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
                }
                return value
            }//:Get
        }//: apiKey
        
    }//:Struct
    
    func getNewsAPIKey() -> String {
        return CoronaAPI.newsAPIKey
    }
    
    func getComponentsForCountryData(country:String, past:Bool = false) -> URLComponents {
        
        var components = URLComponents()
        components.scheme = CoronaAPI.schema
        components.host = CoronaAPI.host
        
        if past {
            components.path = "/v2/historical/\(country)"
            components.queryItems = [
                .init(name: "lastdays", value: "7")
            ]
        }
        else{
            components.path = "/v2/countries/\(country)"
            components.queryItems = [
                .init(name: "yesterday", value: "false")
            ]
        }
        
        return components
    }
    
    func getComponentsForGlobalData(past:Bool = false) -> URLComponents {
        var components = URLComponents()
        components.scheme = CoronaAPI.schema
        components.host = CoronaAPI.host
        
        if past {
            components.path = "/v2/historical/all"
            components.queryItems = [
                .init(name: "lastdays", value: "7")
            ]
        }
        else{
            components.path = "/v2/all"
            components.queryItems = [
                .init(name: "today", value: "")
            ]
        }
        
        return components
    }
}
