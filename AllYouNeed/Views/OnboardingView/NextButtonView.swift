//
//  SkipButtonView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 01/02/22.
//

import SwiftUI

struct NextButtonView: View {
    // MARK: - properties
    @AppStorage("isOnboarding") var isOnboarding:Bool?
    
    // MARK: - BODY
    var body: some View {
        Button(action: {
            UserDefaults.standard.removeObject(forKey: "isLoggedInUsingGoogle")

            isOnboarding = false
        }) {
            HStack(spacing:8) {
                Text("Start")
                
                Image(systemName: "arrow.right.circle").imageScale(.large)
            }.padding(.horizontal, 16).padding(.vertical, 10).background(Capsule().strokeBorder(Color("Linen"), lineWidth: 1.25))
        }.tint(Color("Linen")) //: Button
    }// :Body
}

struct SkipButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NextButtonView()
            .previewLayout(.sizeThatFits)
    }
}
