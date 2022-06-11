import Foundation
import UserNotifications

class NotificationManager {

    static let shared = NotificationManager()
    private init() {}
    static func getShared() -> NotificationManager { shared }

    /// Requests the authorization to display notifications
    func requestAuthorization() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { _, _  in
        }
    }

    /// Adds a notification with a time interval
    func addTimeNotification(for item: Item, in timeInterval: TimeInterval) {
        requestAuthorization()

        let reminderContent = UNMutableNotificationContent()
        reminderContent.title = item.name ?? ""
        reminderContent.sound = .default

        let reminderTrigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        let request = UNNotificationRequest(
            identifier: item.name ?? "",
            content: reminderContent,
            trigger: reminderTrigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print(error.localizedDescription) }
        }
    }

    /// Adds a notification for a given date
    func addCalendarNotification(for item: Item, at givenDate: Date) {
        requestAuthorization()

        let reminderContent = UNMutableNotificationContent()
        reminderContent.title = item.name ?? ""
        reminderContent.sound = .default

        let reminderTrigger = UNCalendarNotificationTrigger(dateMatching:
                                                                Calendar.current.dateComponents(
                                                                    [.day, .month, .year, .hour, .minute, .second],
                                                                    from: givenDate),
                                                            repeats: false)

        let request = UNNotificationRequest(
            identifier: item.name ?? "",
            content: reminderContent,
            trigger: reminderTrigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print(error.localizedDescription) }
        }
    }

    /// Removes the notification for an item
    func removeNotification(for item: Item) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [(item.id ?? UUID()).uuidString])
    }

}
