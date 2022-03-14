//
//  CovidStatsNetwork.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 08/02/22.
//

import Foundation

//MARK: COVID STATS LAYER
struct CovidStatsNetworkLayer {
    static let shared = CovidStatsNetworkLayer()
    let decoder = JSONDecoder()
    
    //MARK: FETCH COUNTRY DATA
    func fetchCountryData(completionHandler: @escaping (CovidMainDataModel) -> Void, errorHandler: @escaping (Error) -> Void, country:String) {
        URLSession.shared.dataTask(with: getComponentsForCountryData(country: country, past: false).url!) { (data, response, error) in
            do {
                if let data = data {
                    let json = try decoder.decode(CovidMainDataModel.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(json)
                    }
                }
            } catch let error {
                errorHandler(error)
            }
        }.resume()
    }
    //MARK: FETCH GLOBAL DATA
    func fetchGlobalData(completionHandler: @escaping (CovidMainDataModel) -> Void, errorHandler: @escaping (Error) -> Void) {
        URLSession.shared.dataTask(with: getComponentsForGlobalData(past: false).url!) { (data, response, error) in
            do {
                if let data = data {
                    let json = try decoder.decode(CovidMainDataModel.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(json)
                    }
                }
            } catch let error {
                errorHandler(error)
            }
        }.resume()
    }
    
    //MARK: FETCH COUNTRY 7 DAYS DATA
    func fetchCountryPastData(completionHandler: @escaping (MyCountryModel) -> Void, errorHandler: @escaping (Error) -> Void, country:String) {
        URLSession.shared.dataTask(with: getComponentsForCountryData(country: country, past: true).url!) { (data, response, error) in
            do {
                if let data = data {
                    let json = try decoder.decode(MyCountryModel.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(json)
                    }
                }
            } catch let error {
                errorHandler(error)
            }
        }.resume()
    }
    
    //MARK: FETCH GLOBAL 7 DAYS DATA
    func fetchGlobalPastData(completionHandler: @escaping (GlobalModel) -> Void, errorHandler: @escaping (Error) -> Void) {
        URLSession.shared.dataTask(with: getComponentsForGlobalData(past: true).url!) { (data, response, error) in
            do {
                if let data = data {
                    let json = try decoder.decode(GlobalModel.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(json)
                    }
                }
            } catch let error {
                errorHandler(error)
            }
        }.resume()
    }
    
    //MARK: FETCH NEWS
    func fetchNewsArticles(completionHandler: @escaping (NewsFeedModel) -> Void, errorHandler: @escaping (Error) -> Void) {
        // Using percent encoding to replace spaces with percent
        let query = "+covid-19 OR +coronavirus".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "covid-19"
        let urlStr = "https://newsapi.org/v2/everything?qInTitle=\(query)&language=en&sortBy=publishedAt&apiKey=\(getNewsAPIKey())"
        
        let url = URL(string: urlStr)
        
        guard url != nil else {
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
                do {
                    if let data = data {
                        let json = try decoder.decode(NewsFeedModel.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(json)
                        }
                    }
                } catch let error {
                    errorHandler(error)
                }
            
        })
        dataTask.resume()
        //Resumes the task, if it is suspended
    }
}
