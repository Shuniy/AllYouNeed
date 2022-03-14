//
//  GlobalCovidView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 08/02/22.
//

import SwiftUI

struct GlobalCovidView: View {
    //MARK: PROPERTIES
    @ObservedObject var viewModel: CovidMainViewModel
    
    //MARK: BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            //MARK: Today
            Section {
                Text("Till Now!")
                    .font(.system(size: 20))
                    .bold()
                //Cases
                CovidStatCardView(value: $viewModel.globalData.cases, covidDataType: CovidDataType.cases, percentage: viewModel.calculatePercentage(todayValue: viewModel.globalData.cases, yesterdayValue: viewModel.globalPastDataCases[1].cases))
                //Deaths
                CovidStatCardView(value: $viewModel.globalData.deaths, covidDataType: CovidDataType.deaths, percentage: viewModel.calculatePercentage(todayValue: viewModel.globalData.deaths, yesterdayValue: viewModel.globalPastDataDeaths[1].cases))
                
                //Recovered
                CovidStatCardView(value: $viewModel.globalData.recovered, covidDataType: CovidDataType.recovered)
                
                //active
                CovidStatCardView(value: $viewModel.globalData.active, covidDataType: CovidDataType.active)
                //critical
                CovidStatCardView(value: $viewModel.globalData.critical, covidDataType: CovidDataType.critical)
                
            }//:Section
            
            //MARK: LAST 7 Days
            Section {
                Text("Data for Last 7 Days")
                    .font(.system(size: 20))
                    .bold()
                
                CovidDataGroupBox(covidDataType: CovidDataType.cases, cases: $viewModel.globalPastDataCases)
                CovidDataGroupBox(covidDataType: CovidDataType.deaths, cases: $viewModel.globalPastDataDeaths)
            }//:Section
            
        }//:ScrollView
    }
}

//MARK: PREVIEW
struct GlobalCovidView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalCovidView(viewModel: CovidMainViewModel())
    }
}
