//
//  NewContactView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct NewContactView: View {
    //MARK: PROPERTIES
    @State var users = [ChatUserModel]()
    @State var filter = ""
    @State var filteredUsers = [ChatUserModel]()
    @Binding var contacts: [ChatUserModel]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var addingNewContact: Bool
    
    //MARK: BODY
    var body: some View {
        HStack {
            TextField("Filter users...", text: $filter)
                .frame(height: 15)
                .padding(10)
                .background(Color(red: 233.0/255, green: 234.0/255, blue: 243.0/255))
                .cornerRadius(15)
                .autocapitalization(.none)
                .onChange(of: filter) { value in
                    filteredUsers = [ChatUserModel]()
                    users.forEach { user in
                        if user.username.lowercased().contains(filter.lowercased()) {
                            filteredUsers.append(user)
                        }
                    }//:forEach
                }//:onChange
        } //:HStack
        .padding(.horizontal, 15)
        
        //MARK: ALL CONTACTS
        List(filter.isEmpty ? users : filteredUsers) { chatUser in
            HStack {
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
                var contactsUidList = [String]()
                contacts.forEach { contact in
                    contactsUidList.append(contact.uid)
                }
                
                contactsUidList.append(chatUser.uid)
                contacts.append(chatUser)
                
                if FirebaseViewModel.manager.currentUser.contacts == nil {
                    FirebaseViewModel.manager.currentUser.contacts = [String]()
                }
                FirebaseViewModel.manager.currentUser.contacts?.append(chatUser.uid)
                
                let ref = Database.database().reference()
                ref.child("users/\(Auth.auth().currentUser!.uid)/contacts").setValue(contactsUidList) { error, reference in
                    presentationMode.wrappedValue.dismiss()
                }
            }//:onTapGesture
        } //:List
        .navigationTitle("Add Contact")
        .onAppear {
            fetchUsers()
        }//:onAppear
        
        if filter != "" && filteredUsers.isEmpty {
            VStack {
                Text("No users found!")
                Spacer()
            }//:VStack
        }//:if filter
    }//:Body
    //MARK: Functions
    
    func fetchUsers() {
        //MARK: Fetches all user
        users = []
        let ref = Database.database().reference()
        ref.child("users").observe(.childAdded, with: { snapshot in
            guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
            let user = try? JSONDecoder().decode(ChatUserModel?.self, from: data)
            if user!.uid != Auth.auth().currentUser?.uid && !contacts.contains(user!) {
                users.append(user!)
            }
        })//:observe
    }//:fetchUsers
}

//MARK: PREVIEW

