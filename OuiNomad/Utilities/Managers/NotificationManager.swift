//
//  NotificationManager.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 05/07/2023.
//

import Firebase
import NotificationCenter

class NotificationManager {

    static func sendNotificationToUser(deviceToken: String, notificationType: NotificationType, missionTitle: String?) {
        let notification: [String: Any] = [
            "to": deviceToken,
            "notification": [
                "title": "Mission \(notificationType.rawValue)",
                "body": "La mission '\(missionTitle ?? "")' a été \(notificationType.rawValue)."
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: notification, options: [])
        
        let url = URL(string: "https://fcm.googleapis.com/fcm/send")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAA27dbJfM:APA91bEdp3lqq2WxwdniTaV9mhszVbBlCzZd9fqUiTI7OhuPABN3b_2l9BXidyh5quF1RJz3enSuukajy4vAMw_qCFS3Ed48GBT7KD6KJOcnDEUOzbWX0Z9SD038LwNqZkQ1yqZ3wm26", forHTTPHeaderField: "Authorization") // Replace YOUR_SERVER_KEY with your FCM server key
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending notification: \(error.localizedDescription)")
            } else {
                print("Notification sent successfully: \(notificationType.rawValue)")
            }
        }
        task.resume()
    }
}
