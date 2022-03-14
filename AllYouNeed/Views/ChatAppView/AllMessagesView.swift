//
//  AllMessagesView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI
import UIKit
import Firebase
import Foundation
import FirebaseDatabase
import GoogleSignIn

struct AllMessagesView: View {
    //MARK: PROPERTIES
    
    @State var latestMessageArray = [ChatMessageModel]()
    @State var dictionary = [String : ChatUserModel]()
    
    @State var onlineUsers = [String]()
    
    @State var showNewConversation = false
    @State var showBlockedList = false
    @State var showContactsView = false
    @State var newConversationUser = ChatUserModel()
    @State var enactNewConversation = false
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            ZStack{
                VStack {
                    //Switch to new conversation when selected
                    if enactNewConversation {
                        NavigationLink(destination: ChatView(otherUser: newConversationUser, onlineUsers: $onlineUsers), isActive: $enactNewConversation) {}
                        .hidden()
                    }
                    //MARK: Messages list
                    List(latestMessageArray) { message in
                        let chatUser = dictionary[message.messageId]!
                        NavigationLink(destination: ChatView(otherUser: chatUser, onlineUsers: $onlineUsers)) {
                            HStack {
                                //MARK: Profile picture
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
                                
                                VStack(alignment: .leading) {
                                    //MARK: Top Text
                                    HStack {
                                        Text(chatUser.username)
                                            .fontWeight(.semibold)
                                            .padding(.bottom, 1)
                                        if onlineUsers.contains(chatUser.uid) {
                                            Image(systemName: "circle.fill")
                                                .font(.system(size: 10, weight: .ultraLight))
                                                .foregroundColor(Color.green)
                                        }
                                        Spacer()
                                    }//:HStack
                                    .padding(.top, 5)
                                    Spacer()
                                    //MARK: Bottom text
                                    Text(message.fromId == FirebaseViewModel.manager.currentUser.uid ? "You: \(message.text != "" ? message.text : "Image")" : "Them: \(message.text != "" ? message.text : "Image")")
                                        .padding(.bottom, 5)
                                        .lineLimit(1)
                                } //:VStack
                                .padding(.leading, 5)
                            } //:HStack
                            .onAppear {
                                //MARK: ONAPPEAR ALL MESSAGE SCREEN
                            }//:onAppear
                            .frame(maxHeight: 120)
                            
                        } //:NavigationLink
                    } //:List
                    .navigationTitle("Messages")
                    //MARK: NAVIGATION BAR ITEMS
                    //MARK: SIGNOUT
                    .toolbar(content: {
                        ToolbarItem(placement:.navigationBarLeading, content:{
                            Button(action: {
                                signOut()
                            }) {
                                HStack(spacing:5){
                                    Image(systemName: "delete.backward.fill")
                                        .font(.system(size: 13, weight: .light))
                                    Text("SignOut")
                                }
                                
                            }
                        })//:toolbarItem
                        
                        ToolbarItem(placement:.navigationBarTrailing, content:{
                            HStack(spacing:10) {
                                //MARK: Contacts
                                NavigationLink(destination: BlockListView(), label: {Image(systemName: "person.fill.xmark").font(.system(size: 16, weight: .light))})
                                Button(action: {
                                    // Contacts View
                                    showContactsView = true
                                }) {
                                    Image(systemName: "book")
                                        .font(.system(size: 16, weight: .light))
                                }//:Button
                                .sheet(isPresented: $showContactsView) {
                                    ContactsView()
                                }//:sheet
                            }//:HStack
                        })//:toolbarItem
                    })//:toolbar
                }//:VStack
                VStack {
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            // New Conversation
                            showNewConversation = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 50, weight: .light))
                                .padding()
                        }//:Button
                        .sheet(isPresented: $showNewConversation) {
                            NewConversationView(showNewConversation: $showNewConversation, newConversationUser: $newConversationUser, enactNewConversation: $enactNewConversation)
                        }//:sheet
                    }//:HStack
                }//:VStack
                .padding()
            }//:ZStack
        } //:NavigationView
        .modify(if: UIDevice.current.userInterfaceIdiom == .pad, then: IPadNavigationViewStyle(), else: IPhoneNavigationViewStyle() )
        .onAppear {
            listenForOnlineUsers()
            listenForLatestMessages()
        }//:onApppear
    }//:Body
    
    //MARK: Functions
    func listenForOnlineUsers() {
        //MARK: LISTEN TO ALL ONLINE USERS
        let ref = Database.database().reference()
        ref.child("online-users").observe(.childAdded, with: { snapshot in
            if snapshot.value as! Bool == true {
                onlineUsers.append(snapshot.key)
                
            }
        })
        ref.child("online-users").observe(.childChanged, with: { snapshot in
            if onlineUsers.contains(snapshot.key) && snapshot.value as! Bool == false {
                onlineUsers.removeAll(where: { $0 == snapshot.key })
                
            } else {
                onlineUsers.append(snapshot.key)
                
            }
        })
    }
    //MARK: LISTEN TO LATEST MESSAGES
    func listenForLatestMessages() {
        self.latestMessageArray = [ChatMessageModel]()
        let ref = Database.database().reference().child("latest-messages")
        ref.child(FirebaseViewModel.manager.currentUser.uid).observe(.childAdded, with: { snapshot in
            refreshLatestMessages(snapshot)
        })
        
        ref.child(FirebaseViewModel.manager.currentUser.uid).observe(.childChanged, with: { snapshot in
            refreshLatestMessages(snapshot)
        })
    }
    //MARK: SIGN OUT
    func signOut(signOutUsingGoogle:Bool = false) {
        do {
            try Auth.auth().signOut()
        }
        catch { print("sign out failed") }
        Database.database().reference(withPath: "online-users/\(FirebaseViewModel.manager.currentUser.uid)").setValue(false)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set(true, forKey: "isOnboarding")
        NotificationCenter.default.post(name: NSNotification.Name("isLoggedIn"), object: nil)
    }
    
    //MARK: REFRESH LATEST MESSAGES
    func refreshLatestMessages(_ snapshot: DataSnapshot) {
        guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
        let message = try? JSONDecoder().decode(ChatMessageModel?.self, from: data)
        //Check if blocked
        if message != nil {
            if FirebaseViewModel.manager.currentUser.blocklist != nil {
                if FirebaseViewModel.manager.currentUser.blocklist!.contains(message!.fromId) || FirebaseViewModel.manager.currentUser.blocklist!.contains(message!.toId) {
                    return
                }
            }
            
            if message!.fromId == Auth.auth().currentUser?.uid {
                let ref = Database.database().reference().child("users/\(message!.toId)")
                ref.observe(.value) { snapshot in
                    guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                    let user = try? JSONDecoder().decode(ChatUserModel?.self, from: data)
                    
                    dictionary[message!.messageId] = user!
                    
                    var changed = false
                    
                    latestMessageArray.forEach { arrayMessage in
                        if arrayMessage.fromId == message!.toId || arrayMessage.toId == message!.toId {
                            let index = latestMessageArray.firstIndex(where: { $0 == arrayMessage })
                            latestMessageArray[index!] = message!
                            changed = true
                        }
                    }
                    
                    if !changed {
                        latestMessageArray.append(message!)
                    }
                    
                    latestMessageArray = latestMessageArray.sorted(by: { $0.time > $1.time })
                }
            } else {
                let ref = Database.database().reference().child("users/\(message!.fromId)")
                ref.observe(.value) { snapshot in
                    guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                    let user = try? JSONDecoder().decode(ChatUserModel?.self, from: data)
                    
                    dictionary[message!.messageId] = user!
                    
                    var changed = false
                    
                    latestMessageArray.forEach { arrayMessage in
                        if arrayMessage.fromId == message!.fromId || arrayMessage.toId == message!.fromId {
                            let index = latestMessageArray.firstIndex(where: { $0 == arrayMessage })
                            latestMessageArray[index!] = message!
                            changed = true
                        }
                    }
                    
                    if !changed {
                        latestMessageArray.append(message!)
                    }
                    
                    latestMessageArray = latestMessageArray.sorted(by: { $0.time > $1.time })
                }
            }
        }
    }
}

//MARK: View Modifiers
struct IPadNavigationViewStyle: ViewModifier {
    func body(content: Content) -> some View { content.navigationViewStyle(DefaultNavigationViewStyle()) }
}

struct IPhoneNavigationViewStyle: ViewModifier {
    func body(content: Content) -> some View { content.navigationViewStyle(StackNavigationViewStyle()) }
}

