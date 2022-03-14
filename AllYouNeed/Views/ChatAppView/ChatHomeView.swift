//
//  ChatHomeView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI

import GoogleSignIn

struct ChatHomeView: View {
    //MARK: PROPERTIES
    
    @State private var show = false
    //This is the isLoggedIn Status of application
    @State private var isLoggedIn = false
    
    //MARK: Body
    var body: some View {
        VStack {
            //if user is logged in show all messages
            if isLoggedIn {
                AllMessagesView()
            } else {
                //show is false, that is we want to show login screen first
                if self.show {
                    RegisterView(show: self.$show)
                        .transition(AnyTransition.opacity.animation(.linear(duration: 0.1)))
                } else {
                    LoginView(show: self.$show)
                        .transition(AnyTransition.opacity.animation(.linear(duration: 0.1)))
                }
            }//:ifelse
        } //:VStack
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .background(Color("Dark Purple").edgesIgnoringSafeArea(.all))
        .onAppear {
                        NotificationCenter.default.addObserver(forName: NSNotification.Name("isLoggedIn"), object: nil, queue: .main) { _ in
                
                isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool ?? false
            }//:NotificationCenter
        }//:onAppear
    }//:Body
}

//MARK: PREVIEW
struct ChatHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ChatHomeView()
    }
}
