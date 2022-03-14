//
//  MovieSliderView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI

struct MovieSliderView: View {
    let movie:Movie
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(
                url: movie.backdropURL,
                content: { image in
                    GeometryReader { geo in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width , height: 256)
                    }
                },
                placeholder: {
                    GeometryReader { geo in
                        ZStack {
                            ProgressView()
                        }
                        .frame(width: geo.size.width , height: 256)
                        .background(Color.gray.opacity(0.3))
                    }
                }
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color.white)
                
                Text(movie.overview)
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundColor(Color.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }//:ZStack
        .frame(minHeight: 256)
    }//:Body
}

struct MovieSliderView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSliderView(movie: Movie(id: 634649, title: "Encanto", backdropURL: URL(string: "https://image.tmdb.org/t/p/w500/3G1Q5xF40HkUBJXxt2DQgQzKTp5.jpg")!, posterURL: URL(string: "https://image.tmdb.org/t/p/w500/4j0PNHkMr5ax3IA8tjtxcmPU3QT.jpg")!, releaseDate: "24.11.2021", rating: "7.8", overview: "The tale of an extraordinary family, the Madrigals, who live hidden in the mountains of Colombia, in a magical house, in a vibrant town, in a wondrous, charmed place called an Encanto. The magic of the Encanto has blessed every child in the family with a unique gift from super strength to the power to heal—every child except one, Mirabel. But when she discovers that the magic surrounding the Encanto is in danger, Mirabel decides that she, the only ordinary Madrigal, might just be her exceptional family\'s last hope."))
            .previewLayout(.sizeThatFits)
    }
}
