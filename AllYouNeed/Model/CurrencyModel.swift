//
//  CurrencyModel.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 07/02/22.
//

import Foundation
//CURRENCY MODEL
struct Currency: Codable, Hashable {
    var code: String
    var name: String
    
    static let defaultCurrency = Currency(code: "USD", name: "United States Dollar")
    static let defaultCurrenciesList = [
        Currency(code: "CNY", name: "Chinese Yuan"),
        Currency(code: "EUR", name: "Euro"),
        Currency(code: "JPY", name: "Japanese Yen"),
        Currency(code: "KRW", name: "South Korean Won"),
        Currency(code: "USD", name: "United States Dollar")
    ]
}

//RATE MODEL
struct Rate: Codable {
    var code: String
    var value: Double
}
