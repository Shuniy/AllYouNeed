//
//  LoginView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 12/02/22.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import GoogleSignIn

struct LoginView: View {
    //MARK: PROPERTIES
    @State private var color = Color("Dark Purple").opacity(0.7)
    //Field variables
    @State private var email = ""
    @State private var password = ""
    @State private var visible = false
    @State var isLoading = false
    
    //Show variable binding, used for registration
    @Binding var show: Bool
    
    //For UI
    @State var alert = false
    @State var error = ""
    @State var resettingPassword = false
    
    //MARK: BODY
    var body: some View {
        VStack {
            ZStack {
                ZStack {
                    GeometryReader { reader in
                        ScrollView(showsIndicators: false) {
                            VStack {
                                //Header Image
                                Image(systemName: "hand.point.up.braille.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: UIScreen.screenWidth / 2)
                                //MARK: LOGIN FIELDS
                                //Login Title
                                Text("Log in to your account")
                                    .font(.title)
                                    .fontWeight(.bold)
                                //Email
                                TextField("Email", text: self.$email)
                                    .autocapitalization(.none)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 15).stroke(self.email != "" ? Color("Dark Purple") : self.color, lineWidth: 2))
                                    .padding(.top, 25)
                                //Password
                                HStack(spacing: 15) {
                                    VStack {
                                        if self.visible {
                                            TextField("Password", text: self.$password)
                                        } else {
                                            SecureField("Password", text: self.$password)
                                        }//:ifelse
                                    }//:VStack
                                    
                                    //Visibility Icon
                                    Button(action: {
                                        self.visible.toggle()
                                    }) {
                                        Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                        
                                    }//:Button
                                } //:HStack
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).stroke(self.password != "" ? Color("Dark Purple") : self.color, lineWidth: 2))
                                .padding(.top, 25)
                                
                                //Forgot Password, toggles the reset screen
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        self.resettingPassword = true
                                    }) {
                                        Text("Forgot Password?")
                                            .fontWeight(.bold)
                                    }//:Button
                                } //:HStack
                                .padding(.top, 10)
                                
                                //MARK: Login Button
                                Button(action: {
                                    self.verify()
                                }) {
                                    Text("Sign In")
                                        .fontWeight(.bold)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.screenWidth - 50)
                                }//:Button
                                .frame(maxWidth: 400)
                                .background(Color("Dark Purple"))
                                .foregroundColor(Color.white)
                                .cornerRadius(10)
                                .padding(.top, 25)
                                //MARK: Login with Google
                                Button(action: {
                                    print("Sign in using google")
                                    self.loginUsingGoogle()
                                }) {
                                    Text("Sign In using Google")
                                        .fontWeight(.bold)
                                        .padding(.vertical)                                    .frame(width: UIScreen.screenWidth - 50)
                                }//:Button
                                .frame(maxWidth: 400)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.top, 5)
                            } //:VStack
                            .frame(maxWidth: 400, minHeight: reader.size.height)
                            .padding(.horizontal, 25)
                        } //:ScrollView
                        .frame(maxWidth: UIScreen.screenWidth)
                    } //:GeometryReader
                    .frame(maxWidth: UIScreen.screenWidth)
                } //:ZStack
                .frame(width: UIScreen.screenWidth)
                .disabled(alert || resettingPassword)
                
                //MARK: Error View, when alert
                if self.alert {
                    ErrorView(alert: self.$alert, error: self.$error)
                }//:Alert
                
                //MARK: RESET PASSWORD VIEW
                if self.resettingPassword {
                    ResetPasswordView(resettingPassword: self.$resettingPassword)
                }//:ResetPassword
                
                //MARK: Register Button
                //Toggles the show
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.show.toggle()
                        }) {
                            Text("Register")
                                .fontWeight(.bold)
                        }//:Button
                        .padding()
                    }//: HStack
                    Spacer()
                }//: VStack
            }//: ZStack
            .background(Color("Peach"))
            .foregroundColor(Color("Dark Purple"))
            //MARK: LOADING, Overlay
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
            Spacer()
        }
    }
    
    //MARK: Functions
    //MARK: VERIFY Login function, which verifies email and password
    func verify() {
        if self.email != "" && self.password != "" {
            Auth.auth().signIn(withEmail: self.email, password: self.password) { result, error in
                if error != nil {
                    // Error
                    self.error = error!.localizedDescription
                    self.alert.toggle()
                } else {
                    // User found
                    self.login()
                    print("login success")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                }
            }
        } else {
            self.error = "Please enter an email and password."
            self.alert.toggle()
        }
    }//:verify
    
    //MARK: LOGIN FUNCTION
    func login(loginUsingGoogle:Bool = false) {
        //Getting logged in user from cache
        if !loginUsingGoogle {
            self.isLoading = true
        }
        let uid: String! = Auth.auth().currentUser?.uid
        
        //Getting logged in user data from database
        let ref = Database.database().reference()
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let data = try? JSONSerialization.data(withJSONObject: snapshot.value as Any, options: []) else { return }
            let user = try? JSONDecoder().decode(ChatUserModel.self, from: data)
            if user != nil {
                FirebaseViewModel.manager.currentUser = user!
                
                if (FirebaseViewModel.manager.token != "") {
                    FirebaseViewModel.manager.currentUser.token = FirebaseViewModel.manager.token
                }
                Database.database().reference(withPath: "/users/\(FirebaseViewModel.manager.currentUser.uid)/token").setValue(FirebaseViewModel.manager.token)
                
                Database.database().reference(withPath: "online-users/\(user!.uid)").setValue(true)
                //Notifying the app, that user is logged in
                NotificationCenter.default.post(name: NSNotification.Name("isLoggedIn"), object: nil)
            }
        })
        if !loginUsingGoogle {
            self.isLoading = false
        }
    }//:login
    
    //MARK: Login using Google
    func loginUsingGoogle() {
        //Checking if user has previous sign in and restoring session
        self.isLoading = true
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            print("Got Previous sign in")
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if error == nil {
                    authenticateUser(for: user, with: error)
                } else {
                    loginFreshWithGoogle()
                }
            }
        } else {
            loginFreshWithGoogle()
        }
        self.isLoading = false
    }//:Login using google
    
    //MARK: LOGIN FRESH WITH Google
    func loginFreshWithGoogle() {
        //Getting client id
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        //Getting configuration
        let configuration = GIDConfiguration(clientID: clientID)
        //Creating windows scene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        //Creating root view controller
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        //Starts the Google Sign in in rootview
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { user, error in
            authenticateUser(for: user, with: error)
        }
    }
    
    //MARK: AUTHENTICATE USER
    func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        //If error occurred in sign in
        if let error = error {
            self.error = "Problem signing is with your account!"
            self.alert.toggle()
            print(error.localizedDescription)
            return
        }
        
        //Get authentication token and idToken
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        
        //Get credential
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        // Now sign in
        Auth.auth().signIn(with: credential) { (_, error) in
            if let error = error {
                self.error = "Unable to login Using Google!"
                self.alert.toggle()
                print(error.localizedDescription)
            } else {
                self.login(loginUsingGoogle: true)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            }
        }
    }
}

//MARK: PREVIEW
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(show: Binding.constant(false))
    }
}
