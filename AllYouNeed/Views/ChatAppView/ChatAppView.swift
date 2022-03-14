//
//  ChatAppView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 02/02/22.
//

import SwiftUI
import UserNotifications

struct ChatAppView: View {
    //MARK: PROPERTIES
    
    //MARK: BODY
    var body: some View {
        LauncherView()
            .onAppear(perform: {
                self.notificationAuthorization()
                self.pushNotificationEvery1Hour()
            })
    }
    
    //MARK: PUSH FUNCTIONS
    func notificationAuthorization() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                
                if let error = error {
                    // Handle the error here.
                    print("Error : ", error.localizedDescription)
                    return
                }
                
                // Enable or disable features based on the authorization.
                print("Access Granted", granted)
        }
    }
    
    func pushNotificationEvery1Hour() {
        let content = UNMutableNotificationContent()
        content.title = "AllYouNeed"
        content.subtitle = "Time to revise and organize your day!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 9800, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

//MARK: PREVIEW
struct ChatAppView_Previews: PreviewProvider {
    static var previews: some View {
        ChatAppView()
    }
}
