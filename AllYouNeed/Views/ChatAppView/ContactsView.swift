//
//  ContactsView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct ContactsView: View {
    //MARK: PROPERTIES
    
    @State var contacts = [ChatUserModel]()
    @Environment(\.presentationMode) var presentationMode
    @State var addingNewContact = false
    
    //MARK: BODY
    var body: some View {
        NavigationView {
            List(contacts) { chatUser in
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
                    
                    Text(chatUser.username)
                        .fontWeight(.semibold)
                        .padding(.leading, 5)
                } //:HStack
            } //:List
            .navigationTitle("Contacts")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Close")
                    }
                })//:toolbaritem
                
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    NavigationLink(destination: NewContactView(contacts: $contacts, addingNewContact: $addingNewContact), isActive: $addingNewContact) {
                        Button(action: {
                            addingNewContact = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 26, weight: .light))
                        }
                    }
                })//:toolbaritem
            })
            
            if contacts.isEmpty {
                VStack {
                    Text("You have no contacts!")
                    Spacer()
                }
            }//:if
        } //:NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            fetchContacts()
        }//:onAppear
    }//:body
    
    //MARK: Functions
    func fetchContacts() {
        //MARK: FETCH CONTACTS
        contacts = []
        FirebaseViewModel.manager.currentUser.contacts?.forEach { uid in
            let newRef = Database.database().reference()
            newRef.child("users/\(uid)").observe(.value) { snapshot in
                guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
                let user = try? JSONDecoder().decode(ChatUserModel?.self, from: data)
                contacts.append(user!)
                contacts = contacts.sorted(by: { $1.username.lowercased() > $0.username.lowercased() })
            }
        }
    }//:fetchContacts
}
