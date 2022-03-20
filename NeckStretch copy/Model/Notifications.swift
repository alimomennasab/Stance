import UIKit
import UserNotifications

struct LocalNotifications {
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]

    func requestLocalNotifications() {
        notificationCenter.requestAuthorization(options: options) { didAllow, error in
            
            if didAllow {
                scheduleNotifications()
            }
        }
    }
    
    func scheduleNotifications() {
                
        let content = UNMutableNotificationContent()
        
        content.title = "Stance"
        content.body = "Time to stretch your neck!"
        content.sound = UNNotificationSound.defaultCritical
        content.badge = 1
        
        var morningTime = DateComponents()
        morningTime.hour = 8
        morningTime.minute = 30
        let morningTrigger = UNCalendarNotificationTrigger(dateMatching: morningTime, repeats: true)
        let morningIdentifier = "StretchMorning"
        let morningRequest = UNNotificationRequest(identifier: morningIdentifier, content: content, trigger: morningTrigger)
        notificationCenter.add(morningRequest) { (error) in
        }
        
        var afternoonTime = DateComponents()
        afternoonTime.hour = 12
        afternoonTime.minute = 30
        let afternoonTrigger = UNCalendarNotificationTrigger(dateMatching: afternoonTime, repeats: true)
        let afternoonIdentifier = "StretchAfternoon"
        let afternoonRequest = UNNotificationRequest(identifier: afternoonIdentifier, content: content, trigger: afternoonTrigger)
        notificationCenter.add(afternoonRequest) { (error) in
        }
        
        var eveningTime = DateComponents()
        eveningTime.hour = 18
        eveningTime.minute = 30
        let eveningTrigger = UNCalendarNotificationTrigger(dateMatching: eveningTime, repeats: true)
        let eveningIdentifier = "StretchEvening"
        let eveningRequest = UNNotificationRequest(identifier: eveningIdentifier, content: content, trigger: eveningTrigger)
        notificationCenter.add(eveningRequest) { (error) in
        }
        
    }
}
