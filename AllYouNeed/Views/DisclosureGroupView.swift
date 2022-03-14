//
//  DisclosureGroupView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 16/02/22.
//

import SwiftUI

struct DisclosureGroupView: View {
    var body: some View {
        //MARK: Disclosure Group
        DisclosureGroup("Read Recommendations!") {
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("Password must be greater than 6 digits")
                Spacer()
            }
            .padding(.vertical, 3)
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("All fields are necessary!")
                Spacer()
            }
            .padding(.vertical, 3)
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("After selecting the image, please wait for a while and then click cancel!")
                Spacer()
            }
            .padding(.vertical, 3)
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("Click register only when you see the image you selected")
                Spacer()
            }
            .padding(.vertical, 3)
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("Please create a strong password!")
                Spacer()
            }
            .padding(.vertical, 3)
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("Password must have one uppercase character!")
                Spacer()
            }
            .padding(.vertical, 3)
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("Password must have one digit!")
                Spacer()
            }
            .padding(.vertical, 3)
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("Password must have one lowercase character!")
                Spacer()
            }
            .padding(.vertical, 3)
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("Password must have one special symbol!")
                Spacer()
            }
            .padding(.vertical, 3)
            HStack(spacing:5) {
                Image(systemName: "info.circle")
                Text("Password must have atleast 6 characters!")
                Spacer()
            }
            .padding(.vertical, 3)
        }//:Disclosure Group
        .shadow(radius: 20)
        .multilineTextAlignment(.leading)
        .padding()
        .background(Color("Dark Purple"))
        .foregroundColor(Color("Peach"))
        .cornerRadius(20)
    }
}

struct DisclosureGroupView_Previews: PreviewProvider {
    static var previews: some View {
        DisclosureGroupView()
    }
}
