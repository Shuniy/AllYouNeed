//
//  BlockListView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct BlockListView: View {
    //MARK: PROPERTIES
    @State var blocklist = [ChatUserModel]()
    
    //MARK: Body
    var body: some View {
        VStack {
            List(blocklist) { chatUser in
                HStack {
                    //Profile picture
                    AsyncImage(url: URL(string: chatUser.profileImageUrl)){ image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 55, height: 55)
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    .shadow(radius: 2)
                    
                    //:Username
                    Text(chatUser.username)
                        .fontWeight(.semibold)
                        .padding(.leading, 5)
                } //:HStack
                
                //MARK: Remove user from block list
                .onTapGesture {
                    if FirebaseViewModel.manager.currentUser.blocklist!.contains(chatUser.uid) {
                        FirebaseViewModel.manager.currentUser.blocklist!.removeAll(where: {$0 == chatUser.uid})
                        blocklist.removeAll(where: {$0 == chatUser})
                    }
                    
                    let ref = Database.database().reference()
                    ref.child("users/\(Auth.auth().currentUser!.uid)/blocklist").setValue(FirebaseViewModel.manager.currentUser.blocklist)
                }//:onTapGesture
            } //:List
            
            if blocklist.isEmpty {
                VStack {
                    Text("You have no blocked users!")
                    Spacer()
                }
            }
        }//:VStack
        .navigationTitle("Blocked Users")
        .onAppear {
            fetchBlocklist()
        }//:onAppear
    }//:body
    
    //MARK: Functions
    func fetchBlocklist() {
        //MARK: FETCH ALL THE BLOCKED USERS
        blocklist = []
        FirebaseViewModel.manager.currentUser.blocklist?.forEach { uid in
            let newRef = Database.database().reference()
            newRef.child("users/\(uid)").observe(.value) { snapshot in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let user = try? JSONDecoder().decode(ChatUserModel?.self, from: data)
                blocklist.append(user!)
                blocklist = blocklist.sorted(by: { $1.username.lowercased() > $0.username.lowercased() })
            }
        }
    }
}

//MARK: PREVIEW
struct BlockListView_Previews: PreviewProvider {
    static var previews: some View {
        BlockListView()
    }
}
