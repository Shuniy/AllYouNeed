//
//  WeatherBlockView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 02/02/22.
//

import SwiftUI

struct WeatherBlockView: View {
    //MARK: PROPERTIES
    var icon: String
    var secondaryIcon:String?
    var title:String
    var value:String
    var metric: String?
    var headline: String?
    
    //MARK: BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack(spacing: 10){
                HStack{
                    Image(systemName: icon)
                        .shadow(color: Color("Lavender Gray"), radius: 5, x: 0, y: 0)
                    Text(title.uppercased())
                }//:HStack
                Spacer()
            }//:HStack
            .padding(.leading, 10)
            .padding(.top, 10)
            .padding(.bottom, 5)
            
            //Secondary Icon
            if secondaryIcon != nil {
                Image(systemName: secondaryIcon!)
                    .font(.system(size: 50))
                    .shadow(color: Color("Lavender Gray"), radius: 5, x: 0, y: 0)
                
                Text(value)
                    .fontWeight(.bold)
                    .font(.title)
                
            } else {
                Text(value)
                    .fontWeight(.bold)
                    .font(.largeTitle)
            }
            //Metric
            if metric != nil {
                Text(metric ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
            }
            
            //Headline
            if headline != nil {
                HStack {
                    Text(headline ?? "")
                        .font(.callout)
                    Spacer()
                }//:HStack
                .padding(.leading, 10)
            }
        }//:ScrollView
        .background(Color("Linen"))
        .frame(width: UIScreen.main.bounds.width / 2 - 10, height: UIScreen.main.bounds.width / 2, alignment: .center)
        .cornerRadius(15)
        .shadow(color: Color("Dark Purple"), radius: 5, x: 1, y: 1)
    }//:Body
}

//MARK: PREVIEW
struct WeatherBlockView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherBlockView(icon: "wind", secondaryIcon: "safari", title: "Title", value: "234", metric: "KM/H", headline: "I am Headline")
            .previewLayout(.sizeThatFits)
        WeatherBlockView(icon: "wind", title: "Title", value: "234", metric: "M/S", headline: "I am Headline")
            .previewLayout(.sizeThatFits)
    }
}
