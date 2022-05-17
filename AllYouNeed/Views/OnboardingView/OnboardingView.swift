//
//  OnboardingView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 01/02/22.
//

import SwiftUI

struct OnboardingView: View {
    //MARK: PROPERTIES
    
    //MARK: BODY
    var body: some View {
        TabView {
            ForEach(0..<onBoardingData.count, id:\.self) {
                index in
                if index == onBoardingData.count - 1{
                    OnboardingCardView(data: onBoardingData[index], next: true)
                } else {
                    OnboardingCardView(data: onBoardingData[index], next: false)
                }
            }//: LOOP
        } //: TAB
        .tabViewStyle(PageTabViewStyle())
        .edgesIgnoringSafeArea(.all)
    }//:Body
}

//MARK: PREVIEW
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
