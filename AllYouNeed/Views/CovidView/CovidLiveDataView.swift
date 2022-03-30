//
//  CovidLiveDataView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 10/02/22.
//

import SwiftUI

struct CovidLiveDataView: View {
    //MARK: PROPERTIES
    @State private var showLoading:Bool = false
    @State private var shouldRefresh = false
    var url = URL(string: "https://covid19.who.int/")!
    
    //MARK: BODY
    var body: some View {
        VStack {
            WebView(url: url, showLoading: $showLoading, shouldRefresh: $shouldRefresh)
                .overlay(showLoading ? ProgressView("Loading...").toAnyView() : EmptyView().toAnyView())
            Button(action: {
                self.shouldRefresh = true
            }){
                Text("Reload Live Data")
            }//:Button
            .padding()
        }//:VStack
    }//:Body
}

struct CovidLiveDataView_Previews: PreviewProvider {
    static var previews: some View {
        CovidLiveDataView()
    }
}
