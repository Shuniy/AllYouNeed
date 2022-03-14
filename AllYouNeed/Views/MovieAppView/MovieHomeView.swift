//
//  HomeView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI

struct MovieHomeView: View {
    //MARK: PROPERTIES
    // It is observed property as it is already initialized in coordinator
    @ObservedObject var viewModel:MovieViewModel
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.screenState {
                case .loading:
                    ProgressView()
                case .failure:
                    MovieErrorView(viewModel: viewModel)
                case .success:
                    MovieHomeListView(viewModel: viewModel)
                }//:switch
            }//:ZStack
            .task {
                viewModel.loadData()
            }
            .ignoresSafeArea(.all, edges: .top)
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }//:Navigation View
        .navigationViewStyle(StackNavigationViewStyle())
    }//:Body
}

//MARK: PREVIEW
struct MovieHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MovieHomeView(viewModel: MovieViewModel(networkLayer: MovieNetworkLayer()))
    }
}
