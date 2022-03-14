//
//  CovidView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI

//MARK: ENUM STATES
enum CovidViews: String, CaseIterable {
    case myCountry = "My Country"
    case global = "Global"
    case liveStats = "Statistics"
    case news = "News"
    case tweets = "Tweets"
}

//MARK: ENUM VIEWS
struct ChoosenCovidView: View {
    //MARK: PROPERTIES
    @ObservedObject var viewModel: CovidMainViewModel
    
    var selectedView: CovidViews
    
    var body: some View {
        switch selectedView {
        case .myCountry:
            MyCountryView(viewModel: viewModel)
        case .global:
            GlobalCovidView(viewModel: viewModel)
        case .news:
            CovidNewsView(viewModel: viewModel)
        case .tweets:
            CovidTwitterWebView()
        case .liveStats:
            CovidLiveDataView()
        }
    }
}

struct CovidAppView: View {
    //MARK: PROPERTIES
    @State var selectedView: CovidViews = .myCountry
    @ObservedObject var viewModel = CovidMainViewModel.shared
    
    //MARK: BODY
    var body: some View {
        VStack {
            Picker("Choose a View", selection: $selectedView) {
                ForEach(CovidViews.allCases, id:\.self) {
                    Text($0.rawValue)
                }//:ForEach
            }//:Picker
            .padding()
            .pickerStyle(SegmentedPickerStyle())
            ChoosenCovidView(viewModel: viewModel, selectedView: selectedView)
        }//:VStack
    }//:Body
}

//MARK: PREVIEW
struct CovidView_Previews: PreviewProvider {
    static let viewModel = CovidMainViewModel()
    static var previews: some View {
        CovidAppView(selectedView: .global, viewModel: viewModel)
    }
}
