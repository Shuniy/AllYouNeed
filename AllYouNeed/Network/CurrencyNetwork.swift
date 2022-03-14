//
//  CurrencyNetwork.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 07/02/22.
//

import Foundation

//MARK: CURRECY NETWORK LAYER
class CurrencyNetworkLayer {
    
    static let shared = CurrencyNetworkLayer()
    
    //MARK: FETCH CURRENCY
    //Using @escaping for completion handler and error handler
    func fetchCurrencies(completionHandler: @escaping ([Currency]) -> Void, errorHandler: @escaping (Error) -> Void) {
        URLSession.shared.dataTask(with: getComponentsForCurrencyList().url!) { (data, response, error) in
            do {
                if let data = data {
                    let response = try JSONSerialization.jsonObject(with: data)
                    if let dictionary = response as? [String: Any], let currenciesJSON = dictionary["currencies"] as? [String: String] {
                        DispatchQueue.main.async {
                            completionHandler(currenciesJSON.map { Currency(code: $0.key, name: $0.value) })
                        }
                    }
                }
            } catch let error {
                errorHandler(error)
            }
        }.resume()
    }
    
    //MARK: FETCH RATES
    func fetchRates(completionHandler: @escaping ([Rate]) -> Void, errorHandler: @escaping (Error) -> Void) {
        URLSession.shared.dataTask(with: getComponentsForCurrencyLive().url!) { (data, response, error) in
            do {
                if let data = data {
                    let response = try JSONSerialization.jsonObject(with: data)
                    if let dictionary = response as? [String: Any], let ratesJSON = dictionary["quotes"] as? [String: Double] {
                        DispatchQueue.main.async {
                            completionHandler(ratesJSON.map { Rate(code: $0.key, value: $0.value) })
                        }
                    }
                }
            } catch let error {
                errorHandler(error)
            }
        }.resume()
    }
}
