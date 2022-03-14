//
//  ErrorView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct ErrorView: View {
    //MARK: PROPERTIES
    @State var colour = Color("Dark Purple").opacity(0.7)
    @Binding var alert: Bool
    @Binding var error: String
    
    //MARK: BODY
    var body: some View {
        VStack {
            HStack {
                Text(self.error == "RESET" ? "Message" : "Error")
                    .font(.title)
                    .foregroundColor(self.colour)
                    .padding(.top, 15)
            } //:HStack
            .padding(.horizontal, 25)
            
            Text(self.error == "RESET" ? "Password reset email sent" : self.error)
                .foregroundColor(self.colour)
                .padding(.top)
            
            Button(action: {
                self.alert.toggle()
            }) {
                Text("OK")
                    .padding(.vertical)
                    .frame(maxWidth: 260)
                    .foregroundColor(Color.white)
            }//:Button
            .background(Color("Dark Purple"))
            .cornerRadius(15)
            .padding([.bottom, .top], 25)
        } //:VStack
        .frame(maxWidth: 300)
        .background(Color("Peach"))
        .cornerRadius(15)
        .padding(.horizontal, 25)
    }
}

//MARK: PREVIEW
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(alert: Binding.constant(true), error: Binding.constant("Error"))
    }
}
