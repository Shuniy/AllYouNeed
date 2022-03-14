//
//  CovidMainViewModel.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 08/02/22.
//

import Foundation
//MARK: COVID MAIN MODEL
class CovidMainViewModel: ObservableObject {
    static let shared = CovidMainViewModel()
    
    @Published var country:String {
        didSet {
            loadCountryData()
            loadCountry7DaysData()
        }
    }
    
    @Published var countryData:CovidMainDataModel
    @Published var globalData: CovidMainDataModel
    var countryPastData:MyCountryModel
    var globalPastData:GlobalModel
    
    @Published var countryPastDataCases:[DailyModel]
    @Published var countryPastDataRecovered:[DailyModel]
    @Published var countryPastDataDeaths:[DailyModel]
    @Published var globalPastDataCases:[DailyModel]
    @Published var globalPastDataRecovered:[DailyModel]
    @Published var globalPastDataDeaths:[DailyModel]
    
    @Published var newsFeed: NewsFeedModel
    @Published var articles = [NewsFeedModel.Article]()
    
    
    init() {
        self.country = "india"
        self.countryData = CovidMainDataModel(deaths: 0, recovered: 0, active: 0, critical: 0, cases: 0)
        self.globalData = CovidMainDataModel(deaths: 0, recovered: 0, active: 0, critical: 0, cases: 0)
        self.countryPastData = MyCountryModel(timeline: DayModel(cases: [:], deaths: [:], recovered: [:]))
        self.globalPastData = GlobalModel(cases: [:], deaths: [:], recovered: [:])
        
        self.globalPastDataCases = []
        self.globalPastDataRecovered = []
        self.globalPastDataDeaths = []
        self.countryPastDataDeaths = []
        self.countryPastDataCases = []
        self.countryPastDataRecovered = []
        self.newsFeed = NewsFeedModel(articles: [])
        self.articles = []
     
        if self.countryData.deaths == 0 && self.countryData.active == 0 && self.countryData.cases == 0 && self.countryData.recovered == 0 {
            self.loadCountryData()
        }
        
        if self.globalData.deaths == 0 && self.globalData.active == 0 && self.globalData.cases == 0 && self.globalData.recovered == 0 {
            self.loadGlobalData()
        }
        
        if self.countryPastDataCases.isEmpty || self.countryPastDataRecovered.isEmpty || self.countryPastDataDeaths.isEmpty {
            self.loadCountry7DaysData()
        }
        
        if self.globalPastDataCases.isEmpty  || self.globalPastDataRecovered.isEmpty || self.globalPastDataDeaths.isEmpty {
            self.loadGlobal7DaysData()
        }
        
        if self.articles.isEmpty {
            self.getNewsArticles()
        }
    }
    
    //MARK: Load Country Data
    func loadCountryData() {
        CovidStatsNetworkLayer.shared.fetchCountryData(completionHandler: {data in
            self.countryData = data
        }, errorHandler: {error in
            print("Error: ", error.localizedDescription)
        }, country: self.country)
    }
    
    //MARK: LOAD COUNTRY 7 DAYS DATA
    func loadCountry7DaysData() {
        CovidStatsNetworkLayer.shared.fetchCountryPastData(completionHandler: {data in
            self.countryPastData = data
            var count = 1
            for i in self.countryPastData.timeline.cases {
                self.countryPastDataCases.append(DailyModel(id: count, day: i.key, cases: i.value))
                count += 1
            }
            count = 1
            for i in self.countryPastData.timeline.deaths {
                self.countryPastDataDeaths.append(DailyModel(id: count, day: i.key, cases: i.value))
                count += 1
            }
            count = 1
            for i in self.countryPastData.timeline.recovered {
                self.countryPastDataRecovered.append(DailyModel(id: count, day: i.key, cases: i.value))
                count += 1
            }
            //Sorted in decreasing order
            self.countryPastDataCases = self.countryPastDataCases.sorted {
                (t, k) -> Bool in
                if t.day <= k.day{
                    return false
                } else {
                    return true
                }
            }
            self.countryPastDataDeaths = self.countryPastDataDeaths.sorted {
                (t, k) -> Bool in
                if t.day <= k.day{
                    return false
                } else {
                    return true
                }
            }
            self.countryPastDataRecovered = self.countryPastDataRecovered.sorted {
                (t, k) -> Bool in
                if t.day <= k.day{
                    return false
                } else {
                    return true
                }
            }
        }, errorHandler: {error in
            print("Error : ", error.localizedDescription)
        }, country: self.country)
    }
    
    //MARK: LOAD GLOBAL DATA
    func loadGlobalData() {
        CovidStatsNetworkLayer.shared.fetchGlobalData(completionHandler: {data in
            self.globalData = data
        }, errorHandler: {error in
            print("Error : ", error.localizedDescription)
        })
    }
    
    //MARK: LOAD GLOBAL PAST DATA
    func loadGlobal7DaysData() {
        CovidStatsNetworkLayer.shared.fetchGlobalPastData(completionHandler: {data in
            self.globalPastData = data
            var count = 1
            for i in self.globalPastData.cases {
                self.globalPastDataCases.append(DailyModel(id: count, day: i.key, cases: i.value))
                count += 1
            }
            count = 1
            for i in self.globalPastData.deaths {
                self.globalPastDataDeaths.append(DailyModel(id: count, day: i.key, cases: i.value))
                count += 1
            }
            count = 1
            for i in self.globalPastData.recovered {
                self.globalPastDataRecovered.append(DailyModel(id: count, day: i.key, cases: i.value))
                count += 1
            }
            //Sorted in decreasing order
            self.globalPastDataCases = self.globalPastDataCases.sorted {
                (t, k) -> Bool in
                if t.day <= k.day{
                    return false
                } else {
                    return true
                }
            }
            self.globalPastDataDeaths = self.globalPastDataDeaths.sorted {
                (t, k) -> Bool in
                if t.day <= k.day{
                    return false
                } else {
                    return true
                }
            }
            self.globalPastDataRecovered = self.globalPastDataRecovered.sorted {
                (t, k) -> Bool in
                if t.day <= k.day{
                    return false
                } else {
                    return true
                }
            }
            
        }, errorHandler: {error in
            print("Error : ", error.localizedDescription)
        })
    }

    //MARK: CALCULATE PERCENTAGE
    func calculatePercentage(todayValue: Int, yesterdayValue: Int) -> Double {
        
        let percentage = Double(todayValue - yesterdayValue) / Double(todayValue)
        return percentage * 100
    }
    
    //MARK: GET NEWS ARTICLES
    func getNewsArticles() {
        CovidStatsNetworkLayer.shared.fetchNewsArticles(completionHandler: {
            data in
            self.newsFeed = data
            self.articles = self.newsFeed.articles
        }, errorHandler: {
            error in
            print("Error: ", error.localizedDescription)
        })
    }
    
}

