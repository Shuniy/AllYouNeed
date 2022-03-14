//
//  OnboardingCardView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 01/02/22.
//

import SwiftUI

struct OnboardingCardView: View {
    //MARK: PROPERTIES
    var data: OnBoardingData
    @State private var isAnimating: Bool = false
    var next: Bool
    
    //MARK: BODY
    var body: some View {
        ZStack {
            VStack(spacing: 20){
                // Fruit: Image
                Image(systemName: data.imageName).resizable().scaledToFit().shadow(color: .black, radius: 9, x: 6, y: 8).scaleEffect(isAnimating ? 1.0 : 0.6)
                    .padding(40)
                // Fruit: Title
                Text(data.title).font(.largeTitle).fontWeight(.heavy).shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)
                // FRUIT: Headline
                Text(data.headline).fontWeight(.bold).multilineTextAlignment(.center).padding(.horizontal, 16).frame(maxWidth:480)
                // BUTTON: Start
                if next {
                    NextButtonView()
                }
                
            }//: VStack
        }//:ZStack
        .onAppear(perform: {
            withAnimation(.easeOut(duration:0.5)){
                isAnimating = true
            }
        })
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color("Amethyst")).ignoresSafeArea(.all)
        .foregroundColor(Color("Linen"))
    }
}

//MARK: PREVIEW
struct OnboardingCardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCardView(data: onBoardingData[2], next: true)
    }
}
