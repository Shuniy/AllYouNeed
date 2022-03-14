//
//  HomeView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 11/02/22.
//

import SwiftUI

struct HomeView: View {
    //MARK: PROPERTIES
    @AppStorage("isOnboarding") var isOnboarding:Bool = true
    @AppStorage("isLoggedIn") var isLoggedIn:Bool = false
    
    
    //MARK: BODY
    var body: some View {
        if isOnboarding {
            OnboardingView()
        } else {
            if isLoggedIn {
                MainView()
            } else {
                //Chat App already ensures if LoggedIN
                ChatAppView()
                    
            }
        }
    }
}

//MARK: PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
