//
//  MovieHomeListView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI

struct MovieHomeListView: View {
    //MARK: PROPERTIES
    @ObservedObject var viewModel:MovieViewModel
    
    //MARK: BODY
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            //MARK: Now Playing Movies
            LazyVStack {
                if !viewModel.nowPlayingMovies.isEmpty {
                    TabView {
                        ForEach(viewModel.nowPlayingMovies){
                            movie in
                            
                            NavigationLink {
                                Coordinator.shared.detailView(for: movie)
                            } label: {
                                MovieSliderView(movie: movie)
                            }//:SliderView Label
                        }//:ForEach
                    }//:TabView
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height:256)
                }//:isEmpty
            }//:LazyVStack
            .frame(height: 256, alignment: .center)
            
            Divider()
            Text("Upcoming Movies")
                .bold()
            
            //MARK: Upcoming View
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.upcomingMovies) {
                    movie in
                    
                    LazyVStack {
                        NavigationLink(destination: Coordinator.shared.detailView(for: movie)){
                            MovieRowView(movie: movie)
                        }//:NavigationLink
                        Divider()
                    }//:LazyVStack
                }//:ForEach
                
                if viewModel.isPagingAvailable {
                    ProgressView()
                        .onAppear(perform: {
                            viewModel.loadNextPageForUpcomingMovies()
                        })//:onAppear
                }//isPagingAvailable
                
            }//:LazyVStack
        
        }//:ScrollView
    }//:Body
}

//MARK: PREVIEW
struct MovieHomeListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieHomeListView(viewModel: MovieViewModel(networkLayer: MovieNetworkLayer()))
    }
}
