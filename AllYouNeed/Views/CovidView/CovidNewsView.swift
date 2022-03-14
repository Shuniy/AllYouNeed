//
//  CovidNewsView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 08/02/22.
//

import SwiftUI

struct CovidNewsView: View {
    //MARK: PROPERTIES
    @ObservedObject var viewModel: CovidMainViewModel
    
    //MARK: BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Text("The Latest News on Covid-19 📰")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Spacer()
            }//:HStack
            .padding()
            
            LazyVStack {
                ForEach(viewModel.articles) { article in
                    ArticleRowView(article: article)
                }//:ForEach
            }//:LazyVStack
            
        }//:ScrollView
    }//:Body
}

//MARK: PREVIEW
struct CovidNewsView_Previews: PreviewProvider {
    static var previews: some View {
        CovidNewsView(viewModel: CovidMainViewModel())
    }
}
