
import Foundation
import UserNotifications

enum NotificationManager {

    // MARK: - Request Notification Permission

    static func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter
                .current()
                .requestAuthorization(
                    options: [.alert, .badge, .sound]
                )

            return granted
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    // MARK: - Schedule Activity Reminder

    static func scheduleReminder(
        for activity: CareActivity,
        puppyName: String
    ) async throws {

        guard activity.date > Date(),
              !activity.isCompleted else {
            return
        }

        let content = UNMutableNotificationContent()

        content.title = "PawPal Reminder"

        let name = puppyName.isEmpty
            ? "your puppy"
            : puppyName

        content.body = "Time for \(name)'s \(activity.title)!"

        content.sound = .default

        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: activity.date
        )

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: activity.id.uuidString,
            content: content,
            trigger: trigger
        )

        try await UNUserNotificationCenter
            .current()
            .add(request)
    }

    // MARK: - Cancel Activity Reminder

    static func cancelReminder(for activityID: UUID) {
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(
                withIdentifiers: [activityID.uuidString]
            )
    }
}
