//
//  WeatherMapView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 02/02/22.
//

import SwiftUI
import MapKit

struct WeatherMapView: View {
    //MARK: PROPERTIES
    @Binding var data: Weather
    
//    @State var region:MKCoordinateRegion {
//        get {
//            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: data.coord.lat, longitude: data.coord.lon), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//        }
//    }
    
    //MARK: BODY
    var body: some View {
        CustomMapView(latitude: data.coord.lat, longitude: data.coord.lon)
            .shadow(color: Color("Dark Purple"), radius: 20, x: 0, y: 0)
            .frame(height:256)
            .cornerRadius(15)
            .overlay(
                HStack {
                    Image(systemName: "mappin.circle")
                        .foregroundColor(.white)
                        .imageScale(.large)
                    
                    Text(data.name)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Peach"))
                }//:HStack
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                    .shadow(radius: 20)
                .background(Color.black
                                .opacity(0.4)
                                .cornerRadius(15))
                        .padding(12), alignment: .topTrailing
            )//:Overlay
    }
}

//MARK: PREVIEW
struct WeatherMapView_Previews: PreviewProvider {
    static let data = WeatherViewModel().weatherData.weathers[0]
    static var previews: some View {
        WeatherMapView(data: Binding.constant(data))
    }
}

//Other Structs
struct CustomMapView: UIViewRepresentable {
    let latitude:Double
    let longitude:Double
 
 func makeUIView(context: Context) -> MKMapView {
     MKMapView()
 }
 
 func updateUIView(_ view: MKMapView, context: Context) {
     let coordinate = CLLocationCoordinate2D(
     latitude: latitude, longitude: longitude)
     let span = MKCoordinateSpan(latitudeDelta: 1.5, longitudeDelta: 1.5)
     let region = MKCoordinateRegion(center: coordinate, span: span)
     view.setRegion(region, animated: true)
 }
}
