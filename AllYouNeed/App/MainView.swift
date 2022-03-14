//
//  ContentView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 01/02/22.
//

import SwiftUI

struct MainView: View {
    //MARK: PROPERTIES
    @State private var selection = 2
    
    //MARK: BODY
    var body: some View {
        TabView(selection: $selection) {
            WeatherAppView()
                .tabItem{
                    Image(systemName: "cloud.sun.rain.fill")
                    Text("Weather")
                }.tag(1)
            
            ChatAppView()
                .tabItem{
                    Image(systemName: "rectangle.3.group.bubble.left")
                    Text("Chat")
                }.tag(2)
            
            MovieAppView()
                .tabItem{
                    Image(systemName: "infinity.circle.fill")
                    Text("Movie")
                }
                .tag(3)
            CovidAppView()
                .tabItem{
                    Image(systemName: "staroflife.fill")
                    Text("Covid")
                }
                .tag(4)
            CurrencyAppView()
                .tabItem{
                    Image(systemName: "coloncurrencysign.circle.fill")
                    Text("Currency")
                }
                .tag(5)
        }//:TabView
    }//:Body
}

//MARK: PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
