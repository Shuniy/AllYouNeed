//
//  MovieRowView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 06/02/22.
//

import SwiftUI

struct MovieRowView: View {
    //MARK: PROPERTIES
    let movie: Movie
    
    //MARK: BODY
    var body: some View {
        HStack(spacing: 9) {
            AsyncImage(
                url: movie.posterURL,
                content: { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 105, height: 105)
                        .cornerRadius(15)
                        .clipped()
                },
                placeholder: {
                    ProgressView()
                }
            )//:Async Image
            
            LazyVStack(alignment: .leading) {
                Text(movie.title).fontWeight(.bold)
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 9)
                Text(movie.overview)
                    .font(.system(size: 13, weight: .medium, design: .default))
                    .foregroundColor(Color.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 15)
                HStack {
                    Spacer()
                    Text("Release Date: " + movie.releaseDate)
                        .font(.system(size: 15, weight: .semibold, design: .default))
                        .foregroundColor(Color.gray)
                }//:HStack
            }//:LazyVStack
            HStack{
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray)
            }//:HStack
            .frame(width: 9)
        }//:HStack
        .padding(15)
    }//:Body
}

//MARK: PREVIEW
struct MovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        MovieRowView(movie: Movie(id: 634649, title: "Encanto", backdropURL: URL(string: "https://image.tmdb.org/t/p/w500/3G1Q5xF40HkUBJXxt2DQgQzKTp5.jpg")!, posterURL: URL(string: "https://image.tmdb.org/t/p/w500/4j0PNHkMr5ax3IA8tjtxcmPU3QT.jpg")!, releaseDate: "24.11.2021", rating: "7.8", overview: "The tale of an extraordinary family, the Madrigals, who live hidden in the mountains of Colombia, in a magical house, in a vibrant town, in a wondrous, charmed place called an Encanto. The magic of the Encanto has blessed every child in the family with a unique gift from super strength to the power to heal—every child except one, Mirabel. But when she discovers that the magic surrounding the Encanto is in danger, Mirabel decides that she, the only ordinary Madrigal, might just be her exceptional family\'s last hope."))
            .previewLayout(.sizeThatFits)
    }
}
