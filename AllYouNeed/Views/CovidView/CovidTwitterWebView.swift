//
//  CovidTwitterWebView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 09/02/22.
//

import SwiftUI

struct CovidTwitterWebView: View {
    //MARK: PROPERTIES
    @State private var showLoading:Bool = false
    @State private var shouldRefresh = false
    var url = URL(string: "https://twitter.com/search?q=%23covid19")!
    
    //MARK: BODY
    var body: some View {
        VStack {
            WebView(url: url, showLoading: $showLoading, shouldRefresh: $shouldRefresh)
                .overlay(showLoading ? ProgressView("Loading...").toAnyView() : EmptyView().toAnyView())
            Button(action: {
                self.shouldRefresh = true
            }){
                Text("Reload Recent Tweets")
            }//:Button
            .padding()
        }//:VStack
    }//:Body
}

//MARK: PREVIEW
struct CovidTwitterWebView_Previews: PreviewProvider {
    static var previews: some View {
        CovidTwitterWebView()
    }
}
