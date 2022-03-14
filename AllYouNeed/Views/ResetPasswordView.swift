//
//  ResetPasswordView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct ResetPasswordView: View {
    //MARK: PROPERTIES
    @State private var email = ""
    @Binding var resettingPassword: Bool
    @State var alert = false
    @State var error = ""
    
    //MARK: BODY
    var body: some View {
        VStack {
            //Email Field
            TextField("Enter your email address", text: self.$email)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).stroke(self.email != "" ? Color("Peach"): Color("Peach").opacity(0.5), lineWidth: 2))
                .padding(.top, 25)
                
            
            Button(action: {
                if self.email != "" {
                    //Fetch the sign in methods
                    Auth.auth().fetchSignInMethods(forEmail: self.email) { result, error in
                        if result != nil {
                            //MARK: Reset process
                            Auth.auth().sendPasswordReset(withEmail: self.email) { error in
                                if error != nil {
                                    self.alert = true
                                    self.error = "Email address is invalid."
                                } else {
                                    self.resettingPassword.toggle()
                                    self.alert = true
                                    self.error = "RESET"
                                }
                            }
                            //Provided email does not exists
                        } else {
                            self.alert = true
                            self.error = "Email address does not exist."
                        }
                    }
                } else {
                    self.alert.toggle()
                    self.error = "Please enter an email address."
                }
                
            }) {
                Text("Reset Password")
                    .foregroundColor(Color.white)
                    .padding(.vertical)
            }//:Button
            .frame(maxWidth: 260)
            .background(Color("Dark Purple"))
            .cornerRadius(15)
            .padding(.top, 25)
            
            //MARK: RESET PASSWORD BUTTON
            Button(action: {
                self.resettingPassword = false
            }) {
                Text("Cancel")
                    
                    .padding(.vertical)
            }//:Button
        } //:VStack
        .frame(maxWidth: 300)
        .background(Color("Peach"))
        .cornerRadius(15)
        .padding(.horizontal, 25)
        .shadow(color: Color("Dark Purple"), radius: 20, x: 0, y: 0)
        
        //MARK: ERROR VIEW
        if self.alert {
            ErrorView(alert: self.$alert, error: self.$error)
        }//:alert
    }//:body
}

//MARK: PREVIEW
struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(resettingPassword: Binding.constant(true))
    }
}
