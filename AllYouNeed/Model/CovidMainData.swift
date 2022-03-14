//
//  CovidMainData.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 08/02/22.
//

import Foundation

struct CovidMainDataModel : Codable {
    
    var deaths : Int
    var recovered : Int
    var active : Int
    var critical : Int
    var cases : Int
}

struct DailyModel: Identifiable{
    var id : Int
    var day : String
    var cases : Int
}

struct MyCountryModel : Codable {
    var timeline : DayModel
}

struct GlobalModel : Codable {
    var cases : [String : Int]
    var deaths : [String : Int]
    var recovered : [String : Int]
    
}

struct DayModel: Codable {
    var cases : [String : Int]
    var deaths : [String : Int]
    var recovered : [String : Int]
}
