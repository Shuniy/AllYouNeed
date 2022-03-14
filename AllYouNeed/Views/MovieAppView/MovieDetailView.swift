//
//  DetailView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI

struct MovieDetailView: View {
    //MARK: PROPERTIES
    @State var movie:Movie
    
    //MARK: BODY
    var body: some View {
        VStack(alignment: .leading) {
            //MARK: TOP BAR VIEW
            DetailTopBarView(title: $movie.title)
            
            //MARK: ASYNC IMAGE
            AsyncImage(
                url: movie.backdropURL,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView()
                }
            )
            //MARK: DETAIL VIEW CONTENT
            HStack(spacing: 9){
                Image("imdb")
                    .resizable()
                    .frame(width: 50, height: 25, alignment: .center)
                
                HStack(spacing: 0) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color.yellow)
                        .padding(.trailing, 4)
                    Text(movie.rating)
                        .font(.system(size: 13, weight: .medium, design: .default))
                    Text("/10")
                        .font(.system(size: 13, weight: .medium, design: .default))
                        .foregroundColor(Color.gray)
                }
                
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 4, height: 4)
                
                Text(movie.releaseDate)
                    .font(.system(size: 13, weight: .medium, design: .default))
            }
            .padding(.horizontal, 16)
            
            Text(movie.title)
                .font(.system(size: 20, weight: .bold, design: .default))
                .padding(16)
            
            
            Text(movie.overview)
                .font(.system(size: 15, weight: .regular, design: .default))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

//MARK: PREVIEW
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSliderView(movie: Movie(id: 634649, title: "Encanto", backdropURL: URL(string: "https://image.tmdb.org/t/p/w500/3G1Q5xF40HkUBJXxt2DQgQzKTp5.jpg")!, posterURL: URL(string: "https://image.tmdb.org/t/p/w500/4j0PNHkMr5ax3IA8tjtxcmPU3QT.jpg")!, releaseDate: "24.11.2021", rating: "7.8", overview: "The tale of an extraordinary family, the Madrigals, who live hidden in the mountains of Colombia, in a magical house, in a vibrant town, in a wondrous, charmed place called an Encanto. The magic of the Encanto has blessed every child in the family with a unique gift from super strength to the power to heal—every child except one, Mirabel. But when she discovers that the magic surrounding the Encanto is in danger, Mirabel decides that she, the only ordinary Madrigal, might just be her exceptional family\'s last hope."))
    }
}
