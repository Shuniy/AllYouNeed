//
//  ArticleRowView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 09/02/22.
//

import SwiftUI

struct ArticleRowView: View {
    //MARK: PROPERTIES
    @AppStorage("isDarkMode") private var isDarkTheme = false
    var article: NewsFeedModel.Article
    
    //MARK: BODY
    var body: some View {
        //With Image
        if URL(string: self.article.urlToImage ?? "") != nil {
            ArticleWithImage(article: self.article)
                .padding()
                .border(isDarkTheme ? Color("Dark Purple") : Color("Peach"), width: 20)
                .cornerRadius(20)
                .shadow(color: isDarkTheme ? Color("Dark Purple") : Color("Peach"), radius: 20, x: 0, y: 0)
        } else {
            //No Image
            ArticleNoImage(article: self.article)
                .padding()
                .border(isDarkTheme ? Color("Dark Purple") : Color("Peach"), width: 20)
                .cornerRadius(20)
                .shadow(color: isDarkTheme ? Color("Dark Purple") : Color("Peach"), radius: 20, x: 0, y: 0)
        }
    }
}

struct ArticleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleRowView(article: NewsFeedModel.Article(id: UUID(uuidString: "97EA0C81-E442-4581-BC0A-2D5230EC5864") ?? UUID(), source: AllYouNeed.NewsFeedModel.Article.Source(source_id: nil, name: Optional("seattlepi.com")), author: Optional("By DAVID KEYTON, Associated Press"), title: Optional("Sweden ends COVID-19 testing as pandemic restrictions lifted"), description: Optional("STOCKHOLM (AP) — Sweden has halted wide-scale testing for COVID-19 even among people showing symptoms of an infection, putting an end to the mobile city-square tent sites, drive-in swab centers and home-delivered tests that became ubiquitous during the pandem…"), url: Optional("https://www.seattlepi.com/news/article/Sweden-ends-COVID-19-testing-as-pandemic-16843646.php"), urlToImage: Optional("https://s.hdnux.com/photos/01/23/74/25/22005102/3/rawImage.jpg"), publishedAt: Optional("2022-02-09T09:20:47Z")))
            .previewLayout(.sizeThatFits)
    }
}

//MARK: Helper Views
struct ArticleWithImage: View {
    //MARK: ARTICLE WITH IMAGE
    //MARK: PROPERTIES
    var article: NewsFeedModel.Article
    
    //MARK: BODY
    var body: some View {
        LazyVStack() {
            AsyncImage(url: URL(string: self.article.urlToImage!)!) {
                image in
                image
                    .resizable()
                    .aspectRatio(nil, contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
            } placeholder: {
                ProgressView()
            }//:Async Image Placeholder
            
            ArticleTextContent(article: article)
        }//:LazyVStack
        .frame(width: 360)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .onTapGesture {
            if let articleURL = self.article.url {
                let url: NSURL = URL(string: articleURL)! as NSURL
                UIApplication.shared.open(url as URL)
            }//:if articleURL
        }//:onTapGesture
    }//:Body
}

//MARK: ARTICLE WITH NO IMAGE
struct ArticleNoImage: View {
    var article: NewsFeedModel.Article
    
    var body: some View {
        ArticleTextContent(article: article)
            .frame(width: 360)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .onTapGesture {
                if let articleURL = self.article.url {
                    let url: NSURL = URL(string: articleURL)! as NSURL
                    UIApplication.shared.open(url as URL)
                }
        }//:onTapGesture
    }//:Body
}

//MARK: ARTICLE Text Context
struct ArticleTextContent: View {
    var article: NewsFeedModel.Article
    
    var body: some View {
        VStack {
            LazyVStack(alignment: .leading, spacing: 10) {
                Text("\(article.title ?? "Headline unavailable")")
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 10)
                Text("\(article.publishedAt?.convertToStringDate() ?? "")")
                    .font(.subheadline)
                    .padding(.leading, 10)
                Text("\((article.description != nil) ? article.description!.truncate(maxLength: 200) : "Description Unavailable")")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 10)
                HStack {
                    Text("\(article.author ?? "Author Unavailable")")
                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 10)
                    Spacer()
                    Text("Source: \(article.source.name ?? "Unavailable")")
                        .font(.footnote)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.trailing, 10)
                }//:HStack
                .padding(.top, 15)
            }//:LazyVStack
        .padding(.vertical, 15)
        }
    }//:Body
}

