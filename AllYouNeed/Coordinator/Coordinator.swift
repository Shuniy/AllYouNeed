//
//  Coordinator.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 04/02/22.
//

import Foundation

//MARK: NAVIGATES BETWEEN HOMEVIEW AND DETAIL VIEW
final class Coordinator {
    static let shared = Coordinator()
    
    func homeView() -> MovieHomeView {
        let viewModel = MovieViewModel(networkLayer: MovieNetworkLayer())
        return MovieHomeView(viewModel: viewModel)
    }
    
    func detailView(for movie: Movie) -> MovieDetailView {
        return MovieDetailView(movie: movie)
    }
    
}
