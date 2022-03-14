//
//  WeatherViewModel.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 03/02/22.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {
    static let shared = WeatherViewModel()
    
    @Published var weatherData: CountryWeather
    
    init() {
        self.weatherData = Bundle.main.decode("jsonformatter.json")
    }
}
