//
//  MovieErrorView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI

struct MovieErrorView: View {
    //MARK: PROPERTIES
    @ObservedObject var viewModel:MovieViewModel
    
    //MARK: BODY
    var body: some View {
        RefreshableView(action: {
            viewModel.loadData()
        }, content: {
            Spacer()
                .frame(minHeight: 200)
            VStack (spacing: 16){
                
                Image(systemName: "xmark.circle")
                    .font(.title)
                Text(viewModel.errorMessage)
                Button {
                    viewModel.loadData()
                } label: {
                    Text("Please Try Again")
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }//:label
            }//:VStack
            Spacer()
        })//:content and RefreshableView
    }//:Body
}

//MARK: PREVIEW
struct MovieErrorView_Previews: PreviewProvider {
    static var previews: some View {
        MovieErrorView(viewModel: MovieViewModel(networkLayer: MovieNetworkLayer()))
    }
}
