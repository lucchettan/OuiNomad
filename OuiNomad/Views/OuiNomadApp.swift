//
//  OuiNomadApp.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 01/07/2023.
//

import Firebase
import FirebaseAuth
import FirebaseCore
import SwiftUI

@main
struct OuiNomadApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel())
        }
    }
}

import FirebaseMessaging
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        if let user = Auth.auth().currentUser {
            print("User already authenticated", user.email as Any)
            print(user)
        } else {
            print("User not authenticated")
        }
        
        registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Register for remote notifications
    func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // Method called when a notification is received while the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification
        // You can customize how the notification is displayed when the app is in the foreground
        completionHandler([.alert, .badge, .sound])
    }

    // Method called when a user interacts with a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification response
        // For example, navigate to a specific screen based on the notification
        completionHandler()
    }

    // Method called when a device token is assigned
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Handle the registration token
        // This token is used to send notifications to this specific device
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        Messaging.messaging().apnsToken = deviceToken
        print("Device Token: \(token)")
        Dependencies.shared.userManager.deviceToken = token
    }

    // Method called when registering for remote notifications fails
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Handle the error
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // Handle the received FCM token
        if let token = fcmToken {
            // You can save the token or perform any other necessary actions
            print("Received FCM token: \(token)")
            Dependencies.shared.userManager.deviceToken = token
        }
    }
}
