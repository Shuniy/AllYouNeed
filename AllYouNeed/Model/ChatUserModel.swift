//
//  ChatUserModel.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import Foundation

struct ChatUserModel: Codable, Equatable {
    //ALL THE USER CONTACTS
    var contacts: [String]?
    //ALL THE BLOCKLIST CONTACTS
    var blocklist: [String]?
    var token: String?
    let email: String
    let uid, username, profileImageUrl: String

    enum CodingKeys: String, CodingKey {
        case contacts, email, blocklist, profileImageUrl
        case token, uid, username
    }
    
    init() {
        self.contacts = [String]()
        self.blocklist = [String]()
        self.email = ""
        self.profileImageUrl = ""
        self.token = ""
        self.uid = ""
        self.username = ""
    }
    
    init(_ uid: String, _ username: String, _ profileImageUrl: String, _ email: String) {
        self.uid = uid
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.email = email
        self.token = nil
        self.contacts = nil
        self.blocklist = nil
    }
    
    func toAnyObject() -> Any {
        return [
            "uid" : uid,
            "username" : username,
            "email" : email,
            "profileImageUrl" : profileImageUrl,
        ]
    }
}

extension ChatUserModel: Identifiable {
    var id: String { return uid }
}
