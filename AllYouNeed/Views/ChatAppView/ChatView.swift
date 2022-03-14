//
//  ChatView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI

import SwiftUI
import Firebase
import UIKit
import FirebaseDatabase

struct ChatView: View {
    //MARK: PROPERTIES
    
    @State var messagesArray = [ChatMessageModel]()
    @State var writing = ""
    var otherUser: ChatUserModel
    @State var cid = ""
    @State var otherUserTyping = false
    @State var dummyArray = [ChatMessageModel()]
    @Binding var onlineUsers: [String]
    @Environment(\.openURL) var openURL
    @State var showAlert = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @AppStorage("isDarkMode") private var isDarkTheme = false
    
    @State private var showPhotoLibrary = false
    @State private var image = UIImage()
    @State private var attachedImageUrl = ""
    
    //MARK: BODY
    var body: some View {
        VStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    LazyVStack{
                        //ScrollView Reader
                        ScrollViewReader { scroll in
                            //MARK: DISPLAYING ALL MESSAGES
                            ForEach(messagesArray) { message in
                                let index = messagesArray.firstIndex(where: { $0 == message })
                                let previousMessage = messagesArray[index! - 1 == -1 ? 0 : index! - 1]
                                let isFirstMessage = index == 0 ? true : false
                                let displayTime = (message.time - previousMessage.time) >= 60 * 5
                                if message.fromId == FirebaseViewModel.manager.currentUser.uid {
                                    //MARK: My Message
                                    if displayTime || isFirstMessage {
                                        Text(message.timestamp)
                                            .font(.system(size: 10))
                                            .padding(.top, isFirstMessage ? 10 : 0)
                                    }
                                    HStack {
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            if message.imageUrl != nil {
                                                AsyncImage(url: URL(string: message.imageUrl!)){ image in
                                                    image.resizable()
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .scaledToFit()
                                                .cornerRadius(15)
                                                .frame(width: UIScreen.screenWidth * 0.5)
                                                .padding(.trailing, message.text == "" ? 8 : 0)
                                                .padding(.vertical, 5)
                                                .shadow(radius: 2)
                                                .onTapGesture {
                                                    openURL(URL(string: message.imageUrl!)!)
                                                }
                                            }//:if
                                            HStack {
                                                if message.text != "" {
                                                    Text(message.text)
                                                        .padding(10)
                                                        .background(Color("Peach"))
                                                        .foregroundColor(Color("Dark Purple"))
                                                        .cornerRadius(15)
                                                }//:Hstack
                                            } //:HStack
                                        } //:VStack
                                    } //:HStack
                                    .id(message)
                                    .onAppear {
                                        withAnimation {
                                            scroll.scrollTo(dummyArray.last)
                                        }
                                    }
                                } else {
                                    //MARK: TimeStamp
                                    if displayTime || isFirstMessage {
                                        Text(message.timestamp)
                                            .font(.system(size: 10))
                                            .padding(.top, isFirstMessage ? 10 : 0)
                                    }
                                    //MARK: OtherUser
                                    HStack {
                                        VStack(alignment: .leading) {
                                            if message.imageUrl != nil {
                                                AsyncImage(url: URL(string: message.imageUrl!)){ image in
                                                    image.resizable()
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .scaledToFit()
                                                .cornerRadius(15)
                                                .frame(width: UIScreen.screenWidth * 0.5)
                                                .padding(.leading, message.text == "" ? 8 : 0)
                                                .padding(.vertical, 5)
                                                .shadow(radius: 2)
                                                .onTapGesture {
                                                    openURL(URL(string: message.imageUrl!)!)
                                                }
                                            }
                                            HStack {
                                                if message.text != "" {
                                                    Text(message.text)
                                                        .padding(15)
                                                        .background(Color(UIColor.systemGray5))
                                                        .cornerRadius(15)
                                                }
                                            } //:HStack
                                        } //:VStack
                                        
                                        Spacer()
                                    } //:HStack
                                    .id(message)
                                    .onAppear {
                                        let lastMessage = messagesArray.last
                                        if lastMessage == message {
                                            let ref = Database.database().reference(withPath: "user-messages/\(otherUser.uid)/\(FirebaseViewModel.manager.currentUser.uid)")
                                            ref.child("latestMessageSeen").setValue(message.id)
                                        }
                                        withAnimation {
                                            scroll.scrollTo(dummyArray.last)
                                        }//:withAnimation
                                    }//:onAppear
                                    .onTapGesture {
                                        //MARK: BLOCK USER Show Alert
                                        showAlert.toggle()
                                    }//:Ontap
                                    .alert(isPresented: $showAlert) {
                                        Alert(
                                            title: Text(otherUser.username),
                                            message: Text("Do you want to block this user?"),
                                            primaryButton: .destructive(Text("Yes"), action: {
                                                // Block
                                                if FirebaseViewModel.manager.currentUser.blocklist == nil {
                                                    FirebaseViewModel.manager.currentUser.blocklist = [String]()
                                                }
                                                
                                                FirebaseViewModel.manager.currentUser.blocklist?.append(otherUser.uid)
                                                
                                                let blockRef = Database.database().reference().child("users/\(Auth.auth().currentUser!.uid)")
                                                blockRef.child("blocklist").setValue(FirebaseViewModel.manager.currentUser.blocklist, withCompletionBlock: { error, snapshot in
                                                    presentationMode.wrappedValue.dismiss()
                                                })
                                            }),
                                            secondaryButton: .cancel(Text("No"), action: {
                                            })
                                        )//:Alert
                                    }//:alert
                                }//:else
                            } //:ForEach
                            .onChange(of: messagesArray.count) { _ in
                                scroll.scrollTo(messagesArray.count - 1)}
                            .padding(.horizontal, 10)
                            .navigationTitle(otherUser.username)
                            //MARK: DUMMY ARRAY TO CReATE SPACE BETWEEN MESSAGES AND ADD MESSAGE BOTTOM
                            ForEach(dummyArray) { i in
                                Text("")
                                    .frame(height: 150)
                                    .foregroundColor(Color.clear)
                                    .id(i)
                            }//:ForEach
                        } //:ScrollViewReader
                    } //:LazyVStack
                }//:ScrollView
                //MARK: ChatMessage Bar
                VStack {
                    Spacer()
                    VStack {
                        //Is Typing
                        HStack {
                            if otherUserTyping {
                                Group {
                                    Text(otherUser.username)
                                        .fontWeight(.bold) +
                                    Text(" is typing...")
                                }
                                .padding(.horizontal, 40)
                                .transition(AnyTransition.opacity.animation(.linear(duration: 0.1)))
                            } else {
                                Text("")
                                    .padding(.bottom, 5)
                                    .padding(.horizontal, 40)
                                    .opacity(0.0)
                            }
                            Spacer()
                        }//:HStack
                        //Imge attached
                        if self.attachedImageUrl != "" {
                            Text("Image is Attached, Click Send!")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 40)
                                .transition(AnyTransition.opacity.animation(.linear(duration: 0.1)))
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                showPhotoLibrary = true
                            }) {
                                Image(systemName: "camera")
                                    .font(.system(size: 22, weight: .light))
                                    .foregroundColor(Color.blue)
                            }//:Button
                            //Enter a message
                            TextField("Enter a message...", text: $writing)
                                .padding(10)
                                .foregroundColor(.accentColor)                                .cornerRadius(15)
                                .onChange(of: writing, perform: { text in
                                    updateTypingIndicator()
                                })
                            //MARK: SEND BUTTON
                            Button(action: {
                                sendMessage()
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 22, weight: .light))
                                    .foregroundColor(Color.blue)
                            }//:Button
                            .disabled(writing == "" && attachedImageUrl == "")
                            Spacer()
                        } //:HStack
                        .cornerRadius(20)
                        .background(isDarkTheme ? Color("Dark Purple") : Color("Peach"))
                        .padding(10)
                    } //:VStack
                    .padding(.top, 10)
                } //:VStack
            } //:ZStack
        } //:VStack
        //MARK: IMAGE PICKER SHEET
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(selectedImage: $image, attachedImageUrl: $attachedImageUrl, sourceType: .photoLibrary)
        }
        .padding(.bottom, 5)
        .onAppear {
            listenForMessages()
            listenForTypingIndicators()
        }
    }
    
    //MARK: Functions
    func sendMessage() {
        let ref = Database.database().reference().child("conversations/\(cid)").childByAutoId()
        let date = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.day], from: date)
        let dayOfMonth = components.day
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        var newHour = ""
        var newMinute = ""
        if hour < 10 {
            newHour = "0\(hour)"
        } else {
            newHour = String(hour)
        }
        if minute < 10 {
            newMinute = "0\(minute)"
        } else {
            newMinute = String(minute)
        }
        var chatMessage = ChatMessageModel(
            FirebaseViewModel.manager.currentUser.uid,
            ref.key!,
            writing,
            Int(NSDate().timeIntervalSince1970),
            "\(dayOfMonth!) \(nameOfMonth), \(newHour):\(newMinute)",
            otherUser.uid
        )
        
        if attachedImageUrl != "" {
            chatMessage.imageUrl = attachedImageUrl
        }
        
        ref.setValue(chatMessage.toAnyObject())
        
        //                                FirebaseManager.manager.sendPushNotification(otherUser.token!, FirebaseManager.manager.currentUser.username, writing)
        
        DispatchQueue.main.async {
            let latestMessageRef = Database.database().reference()
            latestMessageRef.child("latest-messages/\(chatMessage.fromId)/\(chatMessage.toId)").setValue(chatMessage.toAnyObject())
            
            let latestMessageToRef = Database.database().reference()
            latestMessageToRef.child("latest-messages/\(chatMessage.toId)/\(chatMessage.fromId)").setValue(chatMessage.toAnyObject())
        }
                                        attachedImageUrl = ""
        image = UIImage()
        writing = ""
    }
    
    func listenForTypingIndicators() {
    //MARK: listen for Typing
        func checkSnapshot(_ snapshot: DataSnapshot) {
            if snapshot.key == "typing" {
                if snapshot.value as! Bool == true {
                    otherUserTyping = true
                } else if snapshot.value as! Bool == false {
                    otherUserTyping = false
                }
            } else if snapshot.key == "latestMessageSeen" {
                FirebaseViewModel.manager.latestMessageSeen = snapshot.value as! String
            }
        }
        
        let ref = Database.database().reference(withPath: "user-messages/\(FirebaseViewModel.manager.currentUser.uid)/\(otherUser.uid)")
        ref.observe(.childAdded, with: { snapshot in
            checkSnapshot(snapshot)
        })
        ref.observe(.childChanged, with: { snapshot in
            checkSnapshot(snapshot)
        })
    }
    //MARK: Update typing
    func updateTypingIndicator() {
        let ref = Database.database().reference(withPath: "user-messages/\(otherUser.uid)/\(FirebaseViewModel.manager.currentUser.uid)")
        if writing != "" {
            ref.child("typing").setValue(true)
        } else {
            ref.child("typing").setValue(false)
        }
    }
    
    //MARK: REALTIME Listen for messages
    func listenForMessages() {
        let ref = Database.database().reference().child("user-messages/\(FirebaseViewModel.manager.currentUser.uid)/\(otherUser.uid)/cid")
        ref.observe(.value) { snapshot in
            cid = snapshot.value! as! String
            let newRef = Database.database().reference()
            newRef.child("conversations/\(self.cid)").observe(.childAdded, with: { snapshot in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let message = try? JSONDecoder().decode(ChatMessageModel?.self, from: data)
                messagesArray.append(message!)
            })
        }
    }
}
