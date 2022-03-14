//
//  WeatherAppView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 02/02/22.
//

import SwiftUI
import MapKit

struct WeatherAppView: View {
    //MARK: PROPERTIES
    @ObservedObject var viewModel = WeatherViewModel.shared
    @State var selectedState = 0
    
    //MARK: BODY
    var body: some View {
        VStack {
            VStack {
                //Display the State
                HStack {
                    Text(viewModel.weatherData.weathers[selectedState].name + ", ")
                        .fontWeight(.bold)
                    Text(viewModel.weatherData.weathers[selectedState].sys.country.uppercased())
                        .fontWeight(.bold)
                }//:HStack
                .font(.system(size: 40))
                .background(Color("Peach"))
                HStack {
                    Text("Select a Country: ")
                    Picker("Choose a Country", selection: $selectedState) {
                        ForEach(viewModel.weatherData.weathers.indices, id:\.self) {item in
                            Text(viewModel.weatherData.weathers[item].name)
                                .fontWeight(.bold)
                        }//:ForEach
                    }//:Picker
                }//:HStack
                .background(Color("Peach"))
                WeatherView(weatherContent:$viewModel.weatherData.weathers[selectedState])
            }
            .background(Color("Peach"))
            .foregroundColor(Color("Dark Purple"))
            Spacer()
        }
    }//:Body
}

//MARK: PREVIEW
struct WeatherAppView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherAppView()
    }
}
