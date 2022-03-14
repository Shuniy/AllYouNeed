//
//  CurrencyViewModel.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 07/02/22.
//

import Foundation

class CurrencyViewModel: ObservableObject {
    static let shared = CurrencyViewModel()
    
    @Published var currencies: [Currency] {
        didSet {
            self.saveCurrencies()
        }
    }
    @Published var rates: [Rate] {
        didSet {
            self.saveRates()
        }
    }
    @Published var showCurrencies: [Currency] {
        didSet {
            self.saveCurrencyList()
        }
    }
    @Published var lastUpdate: Date? {
        didSet {
            self.saveLastUpdate()
        }
    }
    
    init() {
        currencies = (UserDefaults.standard.array(forKey: "currencies") as? [Data] ?? [])
            .map { try! JSONDecoder().decode(Currency.self, from: $0) }
        rates = (UserDefaults.standard.object(forKey: "rates") as? [Data] ?? [])
            .map { try! JSONDecoder().decode(Rate.self, from: $0) }
        showCurrencies = (UserDefaults.standard.object(forKey: "showCurrencies") as? [Data] ?? [])
            .map { try! JSONDecoder().decode(Currency.self, from: $0) }
        lastUpdate = UserDefaults.standard.object(forKey: "lastUpdate") as? Date
        
        if currencies.isEmpty {
            self.fetchCurrencies()
        }
        
        if rates.isEmpty {
            self.fetchRates()
        }
        
        if showCurrencies.isEmpty {
            self.showCurrencies = Currency.defaultCurrenciesList
        }
    }
    
    //MARK: Fetch Currencies
    func fetchCurrencies() {
        CurrencyNetworkLayer.shared.fetchCurrencies(completionHandler: { currencies in
            self.currencies = currencies
        }, errorHandler: { error in
            self.currencies = Currency.defaultCurrenciesList
            print("ERROR: \(error.localizedDescription)")
        })
    }
    
    //MARK: Fetch Rates
    func fetchRates() {
        CurrencyNetworkLayer.shared.fetchRates(completionHandler: { rates in
            self.rates = rates
            self.lastUpdate = Date()
        }, errorHandler: { error in
            print("ERROR: \(error.localizedDescription)")
        })
    }
    
    //MARK: SAVE Currencies and Rates
    private func saveCurrencies() {
        let data = currencies.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: "currencies")
    }
    
    private func saveRates() {
        let data = rates.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: "rates")
    }
    
    private func saveCurrencyList() {
        let data = showCurrencies.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.setValue(data, forKey: "showCurrencies")
    }
    
    private func saveLastUpdate() {
        UserDefaults.standard.setValue(lastUpdate, forKey: "lastUpdate")
    }
    
    //Update Data only after 120 minutes
    func checkRatesExpiration() {
        let expirationMinutes = 120
        if let lastUpdate = lastUpdate {
            let minutes = Date().minutesFromNow(date: lastUpdate)
            if minutes > expirationMinutes {
                self.fetchRates()
            }
        }
    }
    
    private func filterRateByCurrency(from: Currency, to: Currency) -> Double {
        // USD is based for all convertions
        let baseCurrency = "USD"
        var value: Double = 1
        rates.forEach { rate in
            let convertionCurrency = rate.code.components(withLength: 3)
            //let fromCurrency = convertionCurrency[0]
            let toCurrency = convertionCurrency[1]
            if from.code != baseCurrency, from.code == toCurrency {
                value /= rate.value
            }
            if toCurrency == to.code {
                value *= rate.value
            }
        }
        return value
    }
    
    func convert(from: Currency, to: Currency, amount: Double) -> Double {
        return amount * filterRateByCurrency(from: from, to: to)
    }
    
    func add(currency: Currency) {
        self.showCurrencies.append(currency)
    }
    
    func removeCurrency(at index: IndexSet) {
        index.forEach { showCurrencies.remove(at: $0) }
    }
}
