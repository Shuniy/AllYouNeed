//
//  MovieAppView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 02/02/22.
//

import SwiftUI

struct MovieAppView: View {
    //MARK: PROPERTIES
    
    //MARK: BODY
    var body: some View {
        // As we can see, this function call is already initialized with MovieNetworkLayer
        Coordinator.shared.homeView()
    }
}

//MARK: PREVIEW
struct MovieAppView_Previews: PreviewProvider {
    static var previews: some View {
        MovieAppView()
    }
}
