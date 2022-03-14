//
//  CurrencyNetworkExtension.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 07/02/22.
//

import Foundation

extension CurrencyNetworkLayer {
    struct CurrencyAPI {
        
        static let schema = "http"
        static let host = "api.currencylayer.com"
        
        fileprivate static var apiKey: String {
            get {
               // Step 1: Find the API_KEY plist file
                guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
                    fatalError("API Key plist not Found!")
                }//:else
                
                // Step 2: Find the API Key
                let plist = try?NSDictionary(contentsOf: URL(fileURLWithPath: filePath), error: ())
                guard let value = plist?.object(forKey: "Currency_API_KEY") as? String else {
                  fatalError("Couldn't find key 'API_KEY' in 'Info.plist'.")
                }
                return value
            }//:Get
        }//: apiKey
        
    }//:CurrencyAPI Struct
    func getComponentsForCurrencyList() -> URLComponents {
        var components = URLComponents()
        components.scheme = CurrencyAPI.schema
        components.host = CurrencyAPI.host
        components.path = "/list"
        
        components.queryItems = [
            .init(name: "access_key", value: CurrencyAPI.apiKey),
        ]
        
        return components
    }//:getComponentsForCurrencyList
    
    func getComponentsForCurrencyLive() -> URLComponents {
        var components = URLComponents()
        components.scheme = CurrencyAPI.schema
        components.host = CurrencyAPI.host
        components.path = "/live"
        
        components.queryItems = [
            .init(name: "access_key", value: CurrencyAPI.apiKey),
        ]
        
        return components
    }//:getComponentsForCurrencyLive
}//:extension
