//
//  MovieViewModel.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import Foundation
import Combine
import UIKit

//MARK: Determines the screen and data state
enum ScreenState {
    case success
    case loading
    case failure
}

class MovieViewModel:ObservableObject {
    @Published var nowPlayingMovies = [Movie]()
    @Published var upcomingMovies = [Movie]()
    @Published var isPagingAvailable:Bool = true
    @Published var errorMessage:String = ""
    @Published var screenState:ScreenState = .loading
    
    private var networkLayer: MovieNetworkLayer
    private var currentPage: Int = 1
    private var cancellable:AnyCancellable? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    init(networkLayer: MovieNetworkLayer) {
        self.networkLayer = networkLayer
    }//:Init
    
    //MARK: Load Data
    func loadData() {
        self.screenState = .loading
        //Publishers ->  Namespaces for all publishers
        //Zip -> A publisher created by applying the zip function to two upstream publishers.
        cancellable = Publishers.Zip(self.networkLayer.getNowPlayingMovies(page: 1), self.networkLayer.getUpcomingMovies(page: 1))
            .sink(receiveCompletion: {
                completion in
                
                switch completion {
                case .finished:
                    break
                    
                case let .failure(error):
                    print("ERROR Here: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    self.screenState = .failure
                }
                
            }, receiveValue: {
                [unowned self] nowPlayingResponse, upcomingResponse in
                self.nowPlayingMovies = nowPlayingResponse.results.map { Movie.fromDTO(dto: $0)}
                self.upcomingMovies = upcomingResponse.results.map { Movie.fromDTO(dto: $0)}
                self.isPagingAvailable = (currentPage < upcomingResponse.total_pages)
                self.screenState = .success
            })//:Sink
    }//:LoadData
    
    //MARK: Get upcoming movies
    func loadNextPageForUpcomingMovies() {
        guard isPagingAvailable else {
            return
        }
        currentPage += 1
        self.networkLayer.getUpcomingMovies(page: currentPage)
            .sink(receiveCompletion: {
                completion in
                switch completion {
                case .finished:
                    break
                    
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }, receiveValue: {
                [unowned self] moviesResponse in
                self.isPagingAvailable = (currentPage < moviesResponse.total_pages)
                self.upcomingMovies += moviesResponse.results.map{ Movie.fromDTO(dto: $0)}
            }).store(in: &cancellables)
            //Stores this type-erasing cancellable instance in the specified set.
    }
    
}
