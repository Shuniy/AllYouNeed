//
//  RegisterView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//
import SwiftUI
import Firebase
import FirebaseDatabase
import UIKit
import GoogleSignIn

struct RegisterView: View {
    //MARK: PROPERTIES
    @State private var colour = Color("Dark Purple").opacity(0.5)
    //Fields
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var visible = false
    @State private var revisible = false
    @State var isLoading = false
    
    @Binding var show: Bool
    
    //UI
    @State var alert = false
    @State var error = ""
    @State private var showPhotoLibrary = false
    @State private var image = UIImage()
    @State private var attachedImageUrl = ""
    
    //MARK: BODY
    var body: some View {
        VStack{
        ZStack {
            ZStack {
                GeometryReader { reader in
                    ScrollView(showsIndicators: false) {
                        VStack {
                            //Title
                            Text("Create a new account")
                                .font(.title)
                                .fontWeight(.bold)
                            //MARK: Image Picker
                            VStack {
                                Button(action: {
                                    showPhotoLibrary = true
                                }) {
                                    if attachedImageUrl != "" {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                            .frame(width: 200, height: 200)
                                            .overlay(Circle().stroke(Color("Dark Purple"), lineWidth: 2))
                                            .shadow(radius: 2)
                                    } else {
                                        VStack {
                                            Image(systemName: "person.circle")
                                            
                                                .font(.system(size: 100, weight: .ultraLight))
                                                .padding(.bottom, 1)
                                            Text("Choose a profile picture")
                                            
                                        }//:VStack
                                    }
                                }//:Button
                            } //:VStack
                            .padding(.top, 10)
                            
                            //MARK: Email
                            TextField("Email", text: self.$email)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).stroke(self.email != "" ? Color("Dark Purple") : self.colour, lineWidth: 2))
                                .padding(.top, 15)
                            //Username
                            TextField("Username", text: self.$username)
                                .autocapitalization(.none)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).stroke(self.email != "" ? Color("Dark Purple") : self.colour, lineWidth: 2))
                                .padding(.top, 15)
                            
                            //MARK: Password
                            HStack(spacing: 15) {
                                VStack {
                                    if self.visible {
                                        TextField("Password", text: self.$password)
                                            .autocapitalization(.none)
                                    } else {
                                        SecureField("Password", text: self.$password)
                                            .autocapitalization(.none)
                                    }
                                }//:VStack
                                
                                //Visibility
                                Button(action: {
                                    self.visible.toggle()
                                }) {
                                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    
                                }//:Button
                            } //:HStack
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(self.passwordConfirm != "" ? Color("Dark Purple") : self.colour, lineWidth: 2))
                            .padding(.top, 15)
                            
                            //Confirm Password
                            HStack(spacing: 15) {
                                VStack {
                                    if self.revisible {
                                        TextField("Confirm Password", text: self.$passwordConfirm)
                                    } else {
                                        SecureField("Confirm Password", text: self.$passwordConfirm)
                                    }
                                }//:VStack
                                
                                //Confirm Password Visibilty
                                Button(action: {
                                    self.revisible.toggle()
                                }) {
                                    Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    
                                }//:Button
                            } //:HStack
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(self.password != "" ? Color("Dark Purple") : self.colour, lineWidth: 2))
                            .padding(.top, 15)
                            
                            
                            //MARK: REGISTER Button
                            Button(action: {
                                self.verify()
                            }) {
                                Text("Register")
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.screenWidth - 50)
                            }//:Button
                            .frame(maxWidth: 400)
                            .background(Color("Dark Purple"))
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                            .padding([.top, .bottom], 10)
                            //MARK: REGISTER with Google
                            Button(action: {
                                print("Starting register using google")
                                self.registerUsingGoogle()
                            }) {
                                Text("Register Using Google")
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                                    .frame(width: UIScreen.screenWidth - 50)
                            }//:Button
                            .frame(maxWidth: 400)
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding([.top, .bottom], 10)
                            
                            DisclosureGroupView()
                        } //:VStack
                        .frame(maxWidth: 400, minHeight: reader.size.height)
                        .padding(.horizontal, 25)
                    } //:ScrollView
                    .frame(width: UIScreen.screenWidth)
                } //:GeometryReader
                .frame(width: UIScreen.screenWidth)
                
                //MARK: Chevron, Toggles show to go back to login screen
                VStack {
                    HStack {
                        Button(action: {
                            self.show.toggle()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                            
                        }//Button
                        .padding()
                        Spacer()
                    }//:HStack
                    Spacer()
                }//:VStack
            } //:ZStack
            .disabled(alert)
            
            //MARK: ERROR VIEW
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error)
            }//:alert
        } //:ZStack
        .overlay(
            ZStack {
                if isLoading {
                    Color.black
                        .opacity(0.25)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .font(.title)
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(10)
                }//:if
            }//:ZStack
        )//:overlay
        .background(Color("Peach"))
        .foregroundColor(Color("Dark Purple"))
        //MARK: IMAGE PICKER SHEET
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(selectedImage: $image, attachedImageUrl: $attachedImageUrl, sourceType: .photoLibrary)
        }//:sheet
        Spacer()
    }
    }//:Body
    
    //MARK: Functions
    //MARK: Verify email and password and register
    func verify() {
        if self.email != "" && self.username != "" && self.password.isValidPassword() && self.password != "" && self.passwordConfirm != "" && attachedImageUrl != "" &&
            self.password == self.passwordConfirm {
            Auth.auth().createUser(withEmail: self.email, password: self.password, completion: { result, error in
                if error != nil {
                    // Error
                    self.error = error!.localizedDescription
                    print(self.error)
                    self.alert.toggle()
                } else {
                    // Register
                    self.register()
                    print("new user created")
                }
            })
        } else {
            if self.password != self.passwordConfirm {
                self.error = "Passwords do not match."
            } else if attachedImageUrl == "" {
                self.error = "Please upload a profile image."
            } else if !self.password.isValidPassword() {
                self.error = "Please enter a strong password!"
            } else {
                self.error = "Please enter an email and password."
            }
            self.alert.toggle()
        }
    }//:verify
    
    //MARK: REGISTER FUNCTION
    func register(signInUsingGoogle:Bool = false) {
        if !signInUsingGoogle {
            self.isLoading = true
        }
        let user:ChatUserModel
        //If signing using register, then use the data from GID Instance else use the data from PC
        if signInUsingGoogle {
            let userRef = GIDSignIn.sharedInstance.currentUser!
            user = ChatUserModel(Auth.auth().currentUser!.uid, userRef.profile!.name, (userRef.profile?.imageURL(withDimension: 200)!.absoluteString)!, userRef.profile!.email)
        } else {
            user = ChatUserModel(
                Auth.auth().currentUser!.uid,
                self.username,
                attachedImageUrl,
                self.email
            )
        }
        //Creating new user into database
        Database.database().reference().child("users").child(user.uid).setValue(user.toAnyObject())
        //Getting reference
        let newRef = Database.database().reference()
        //Setting the values
        newRef.child("users/\(user.uid)").observe(.value, with: { snapshot in
            guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
            let user = try? JSONDecoder().decode(ChatUserModel.self, from: data)
            FirebaseViewModel.manager.currentUser = user!
            print("new user retrieved")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            //Automatically login, notifying app
            NotificationCenter.default.post(name: NSNotification.Name("isLoggedIn"), object: nil)
            
        })
        if !signInUsingGoogle {
            self.isLoading = false
        }
    }//:register
    
    //MARK: Register using google
    func registerUsingGoogle() {
        self.isLoading = true
        // If user is signed in, then no need to register
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [self] user, error in
                if error == nil {
                    self.authenticateUser(for: user, with: error)
                } else {
                    registerFreshWithGoogle()
                }
            }
        } else {
            registerFreshWithGoogle()
        }
        self.isLoading = false
    }
    func registerFreshWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let configuration = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) {[self] user, error in
            self.authenticateUser(for: user, with: error)
        }
    }
    
    //MARK: AUTHENTICATE USER
    func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        print("authenticating user function")
        if let error = error {
            self.error = "Failed to Register using Google, User error!"
            print(error.localizedDescription)
            self.alert.toggle()
            return
        }
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                self.error = "Failed to Login Using Google!"
                print(error.localizedDescription)
                self.alert.toggle()
            } else {
                self.register(signInUsingGoogle: true)
            }
        }
    }//:Authentication
}

//MARK: PREVIEW
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(show: Binding.constant(false))
            .background(Color("DefaultGreen").ignoresSafeArea(edges: .all))
    }
}
