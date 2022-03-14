//
//  LauncherView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct LauncherView: View {
    //MARK: PROPERTIES
    
    //MARK: BODY
    var body: some View {
        ChatHomeView()
    }
    init() {
        retrieveUser()
    }
    
    //MARK: Functions
    func retrieveUser() {
        //Get the current user from the cache
        if Auth.auth().currentUser != nil {
            //get the current user id
            let uid: String! = Auth.auth().currentUser?.uid
            //get the reference of user from database
            let ref = Database.database().reference()
            //retrieving data from database of current user
            //converting the data to any
            ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                //now decoding user data and storing it into user
                let user = try? JSONDecoder().decode(ChatUserModel.self, from: data)
                //check if user has token, if not then provide the token
                if user != nil {
                    FirebaseViewModel.manager.currentUser = user!
                    
                    if (FirebaseViewModel.manager.token != "") {
                        FirebaseViewModel.manager.currentUser.token = FirebaseViewModel.manager.token
                    }
                    Database.database().reference(withPath: "/users/\(FirebaseViewModel.manager.currentUser.uid)/token").setValue(FirebaseViewModel.manager.token)
                    
                    //set user logged in status
                    Database.database().reference(withPath: "online-users/\(user!.uid)").setValue(true)
                    //notify the application that user is logged in
                    NotificationCenter.default.post(name: NSNotification.Name("isLoggedIn"), object: nil)
                }
            })
        }
    }//:retrieve user
}


