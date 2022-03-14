//
//  NewConversationView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct NewConversationView: View {
    //MARK: PROPERTIES
    @Binding var showNewConversation: Bool
    @Binding var newConversationUser: ChatUserModel
    @Binding var enactNewConversation: Bool
    @State var contacts = [ChatUserModel]()
    
    //MARK: PROPERTIES
    var body: some View {
        HStack {
            Text("New Conversation")
                .bold()
                .font(.system(size: 32))
                .padding()
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Spacer()
            Button(action: {
                showNewConversation = false
            }) {
                Text("Cancel")
                    .padding()
            }//:Button
        }//:HStack
        List(contacts) { chatUser in
            HStack {
                // Profile picture
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
                
                Text(chatUser.username)
                    .fontWeight(.semibold)
                    .padding(.leading, 5)
            } //:HStack
            .onTapGesture {
                checkForConversation(chatUser)
            }
        } //:List
        .onAppear {
            fetchContacts()
        }//:onAppear
    }//:body
    
    //MARK: Functions
    func fetchContacts() {
        //MARK: FETCH CONTACTS AND START CONVERSATION
        contacts = []
        let ref = Database.database().reference()
        ref.child("users/\(FirebaseViewModel.manager.currentUser.uid)/contacts").observe(.childAdded, with: { snapshot in
            let newRef = Database.database().reference()
            newRef.child("users/\(snapshot.value!)").observe(.value, with: { snapshot in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let user = try? JSONDecoder().decode(ChatUserModel?.self, from: data)
                
                contacts.append(user!)
            })
        })
    }//:fetchContacts
    
    func checkForConversation(_ otherUser: ChatUserModel) {
        //MARK: CHECK IF ALREADY HAVE CONVERSATION
        //change enactconversion to true
        let ref = Database.database().reference()
        ref.child("user-messages/\(Auth.auth().currentUser!.uid)").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.hasChild(otherUser.uid) {
                newConversationUser = otherUser
                enactNewConversation = true
                showNewConversation = false
            } else {
                let cid = UUID.init().uuidString
                ref.child("user-messages/\(Auth.auth().currentUser!.uid)/\(otherUser.uid)/cid").setValue(cid, withCompletionBlock: { error, snapshot in
                    let otherRef = Database.database().reference()
                    otherRef.child("user-messages/\(otherUser.uid)/\(Auth.auth().currentUser!.uid)/cid").setValue(cid, withCompletionBlock: { error, snapshot in
                        newConversationUser = otherUser
                        enactNewConversation = true
                        showNewConversation = false
                    })
                })
            }
        })
    }//:checkforConversation
}
