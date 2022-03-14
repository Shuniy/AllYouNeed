//
//  WeatherDataModel.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 02/02/22.
//

import Foundation
import SwiftUI

//MARK: WeathersDataModel
struct CountryWeather: Identifiable, Codable {
    var id = UUID().uuidString
    var weathers = [Weather]()
}

//MARK: WeatherDataModel
struct Weather: Identifiable, Codable {
    var coord:Coordinates
    var weather = [Weathers]()
    var base:String
    var main: Main
    var visibility: Double
    var wind: Wind
    var clouds: Clouds
    var dt: Double
    var sys: Sys
    var timezone: Double
    var id: Int
    var name:String
    var cod: Double
}

//MARK: Coordinate
struct Coordinates: Codable {
    var lon: Double
    var lat: Double
}

//MARK: WeathersData
struct Weathers: Codable {
    var id:Int
    var main:String
    var description:String
    var icon:String
}

//MARK: Main
struct Main: Codable {
    var temp:Double
    var feels_like:Double
    var temp_min:Double
    var temp_max:Double
    var pressure:Double
    var humidity:Double
}

//MARK: Wind
struct Wind: Codable {
    var speed:Double
    var deg:Double
}

//MARK: Clouds
struct Clouds: Codable {
    var all:Double
}

//MARK: Sys
struct Sys: Codable {
    var type:Double
    var id: Int
    var country:String
    var sunrise:Double
    var sunset:Double
}
