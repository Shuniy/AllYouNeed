//
//  WeatherView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 16/02/22.
//

import SwiftUI

struct WeatherView: View {
    //MARK: PROPERTIES
    @Binding var weatherContent:Weather
    
    //MARK: Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            //Top GroupBox
            Group {
                //Display temperature
                Text(weatherContent.main.temp.convertToCelsius())
                    .font(.system(size: 40))
                
                //Display Main
                Text(weatherContent.weather[0].main)
                    .font(.system(size: 25))
                
                //WeatherImage
                Image("09n")
                    .resizable()
                    .frame(width: 150, height: 150, alignment: .center)
                
                //Display description
                Text(weatherContent.weather[0].description.uppercased())
                    .font(.system(size: 20))
                
                // HIGH and LOW
                HStack {
                    Text("H:\(weatherContent.main.temp_max.convertToCelsius())")
                        .fontWeight(.bold)
                    Text("L:\(weatherContent.main.temp_min.convertToCelsius())")
                        .fontWeight(.bold)
                }//:HStack
                .font(.system(size: 20))
            }//:Group
            .padding(.bottom)
            
            //Map
            Group {
                //Stations
                Text("\(weatherContent.base.uppercased())")
                    .fontWeight(.semibold)
                
                //Map
                WeatherMapView(data: $weatherContent)
                    .padding(.horizontal)
                    .padding(.top, 0)
                    .padding(.bottom)
            }
            
            //Block View
            Group {
                //Feels Like and Humidity
                HStack {
                    WeatherBlockView(icon: "thermometer", secondaryIcon: "circle.hexagonpath.fill", title: "Feels Like", value: weatherContent.main.feels_like.toString(),
                                     metric: "Celsius", headline: "Wind is making it feel cooler")
                    
                    WeatherBlockView(icon: "humidity", secondaryIcon: "humidity.fill", title: "Humidity", value: weatherContent.main.humidity.toString(), metric: "%", headline: "The dew point is right now")
                }//:HStack
                
                //Pressure and Visibility
                HStack {
                    WeatherBlockView(icon: "eye.trianglebadge.exclamationmark", secondaryIcon: "eye", title: "Visibility", value: weatherContent.visibility.toString(), metric: "m", headline: "Light Fog is Expected")
                    
                    WeatherBlockView(icon: "barometer", secondaryIcon: "speedometer", title: "Pressure", value: weatherContent.main.pressure.toString(), metric: "hPa", headline: "High Pressure")
                }//:HStack
                
                //Wind
                HStack {
                    WeatherBlockView(icon: "wind", secondaryIcon: "wind.snow", title: "wind", value: weatherContent.wind.speed.toString(), metric: "KM/H", headline: "Winds are not that Fast")
                    WeatherBlockView(icon: "wind.snow", secondaryIcon: "arrowshape.bounce.right", title: "Direction", value: weatherContent.wind.deg.toString(), metric: "Degrees")
                }//:HStack
                
                //Cloud and Temp
                HStack {
                    WeatherBlockView(icon: "cloud", secondaryIcon: "exclamationmark.icloud", title: "Clouds", value: weatherContent.clouds.all.toString(), metric: "%")
                    
                    WeatherBlockView(icon: "thermometer.sun", secondaryIcon: "theatermasks", title: "Weather", value: weatherContent.main.temp.toString(), metric: "Kelvin")
                }//:HStack
                
                //Sunrise and Sunset
                HStack {
                    WeatherBlockView(icon: "sunrise", secondaryIcon: "sunrise.fill", title: "Sunrise", value: "Time", metric: "AM", headline: String(NSDate(timeIntervalSince1970: weatherContent.sys.sunrise).description(with: "en-us")))
                    
                    WeatherBlockView(icon: "sunset", secondaryIcon: "sunset.fill", title: "Sunset", value: "Time", metric: "PM", headline: String(NSDate(timeIntervalSince1970: weatherContent.sys.sunset).description(with: "en-us")))
                }//:HStack
            }//:Group
            .padding(.bottom)
        }//:ScrollView
        .padding(.vertical, 20)
        .background(Color("Peach"))
    }
}

//MARK: PREVIEW
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weatherContent: Binding.constant(WeatherViewModel().weatherData.weathers[0]))
    }
}
