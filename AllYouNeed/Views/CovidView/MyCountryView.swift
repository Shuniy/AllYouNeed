//
//  MyCountryView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 08/02/22.
//

import SwiftUI

struct MyCountryView: View {
    //MARK: PROPERTIES
    @ObservedObject var viewModel: CovidMainViewModel
    
    //MARK: BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            //MARK: COUNTRY PICKER
            HStack {
                Text("Choose a Country : ")
                    .bold()
                    .italic()
                Picker("Choose a Country", selection: $viewModel.country) {
                    ForEach(countryList, id:\.self) {country in
                        Text(country)
                    }//:ForEach
                }//:Picker
            }//:HStack
            
            //MARK: Today
            Section {
                Text("Till Now!")
                    .font(.system(size: 20))
                    .bold()
                //Cases
                CovidStatCardView(value: $viewModel.countryData.cases, covidDataType: CovidDataType.cases, percentage: viewModel.calculatePercentage(todayValue: viewModel.countryData.cases, yesterdayValue: viewModel.countryPastDataCases[1].cases))
                //Deaths
                CovidStatCardView(value: $viewModel.countryData.deaths, covidDataType: CovidDataType.deaths, percentage: viewModel.calculatePercentage(todayValue: viewModel.countryData.deaths, yesterdayValue: viewModel.countryPastDataDeaths[1].cases))
                
                //Recovered
                CovidStatCardView(value: $viewModel.countryData.recovered, covidDataType: CovidDataType.recovered)
                
                //active
                CovidStatCardView(value: $viewModel.countryData.active, covidDataType: CovidDataType.active)
                //critical
                CovidStatCardView(value: $viewModel.countryData.critical, covidDataType: CovidDataType.critical)
                
            }//:Section
            
            //MARK: LAST 7 Days
            Section {
                Text("Data for Last 7 Days")
                    .font(.system(size: 20))
                    .bold()
                
                CovidDataGroupBox(covidDataType: CovidDataType.cases, cases: $viewModel.countryPastDataCases)
                CovidDataGroupBox(covidDataType: CovidDataType.deaths, cases: $viewModel.countryPastDataDeaths)
            }//:Section
            
        }//:ScrollView
        
    }//:Body
}

//MARK: PREVIEW
struct MyCountryView_Previews: PreviewProvider {
    static var previews: some View {
        MyCountryView(viewModel: CovidMainViewModel())
    }
}
