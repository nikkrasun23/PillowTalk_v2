//
//  NotificationScheduler.swift
//  Pillow Talk App
//
//  Created by Assistant on 20/09/2025.
//

import Foundation
import UserNotifications

final class NotificationScheduler {
    static let shared = NotificationScheduler()
    
    private init() {}
    
    private let requestIdPrefix = "local.daily.message."
    private let testIdPrefix = "local.test.message."
    
    func scheduleDailyNotifications(using messages: [String], title: String, atHour hour: Int = 20, minute: Int = 0, daysAhead: Int = 14) {
        guard !messages.isEmpty, daysAhead > 0 else { return }
        
        removePendingRequestsWithPrefix(requestIdPrefix) { [weak self] in
            self?.createDailyRequests(messages: messages, title: title, hour: hour, minute: minute, daysAhead: daysAhead)
        }
    }
    
    // Быстрый тест: одно уведомление через N секунд
    func scheduleIn(seconds: TimeInterval, message: String, title: String) {
        guard seconds > 0 else { return }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.sound = .default
        
        // Добавляем userInfo для аналитики
        let currentLanguage = Locale.current.language.languageCode?.identifier ?? "unknown"
        content.userInfo = [
            "notification_type": "local",
            "notification_source": "test",
            "language": currentLanguage,
            "title": title,
            "message": message
        ]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let id = "\(testIdPrefix)\(Int(Date().timeIntervalSince1970))"
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule test notification: \(error.localizedDescription)")
            }
        }
    }
}

private extension NotificationScheduler {
    func createDailyRequests(messages: [String], title: String, hour: Int, minute: Int, daysAhead: Int) {
        let center = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let now = Date()
        
        // Дни недели для отправки: Пн (2), Ср (4), Пт (6), Нд (1)
        let allowedWeekdays: Set<Int> = [1, 2, 4, 6] // Sunday, Monday, Wednesday, Friday
        
        var scheduledCount = 0
        var messageIndex = 0
        var dayOffset = 0
        
        // Продолжаем искать дни пока не запланируем достаточное количество или не пройдем daysAhead дней
        while scheduledCount < daysAhead && dayOffset < daysAhead * 2 {
            guard let targetDate = calendar.date(byAdding: .day, value: dayOffset, to: now) else {
                dayOffset += 1
                continue
            }
            
            let weekday = calendar.component(.weekday, from: targetDate)
            
            // Проверяем подходит ли день недели
            guard allowedWeekdays.contains(weekday) else {
                dayOffset += 1
                continue
            }
            
            var components = calendar.dateComponents([.year, .month, .day], from: targetDate)
            components.hour = hour
            components.minute = minute
            
            // Если время уже прошло сегодня - пропускаем
            if let fireDate = calendar.date(from: components), fireDate <= now {
                dayOffset += 1
                continue
            }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let message = messages[messageIndex % messages.count]
            
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = message
            content.sound = .default
            
            // Добавляем userInfo для аналитики
            let currentLanguage = Locale.current.language.languageCode?.identifier ?? "unknown"
            content.userInfo = [
                "notification_type": "local",
                "notification_source": "daily_reminder",
                "language": currentLanguage,
                "title": title,
                "message": message,
                "scheduled_date": formattedDateIdentifier(from: components)
            ]
            
            let identifier = "\(requestIdPrefix)\(formattedDateIdentifier(from: components))"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("Failed to schedule notification: \(error.localizedDescription)")
                }
            }
            
            scheduledCount += 1
            messageIndex += 1
            dayOffset += 1
        }
    }
    
    func removePendingRequestsWithPrefix(_ prefix: String, completion: @escaping () -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let idsToRemove = requests
                .map { $0.identifier }
                .filter { $0.hasPrefix(prefix) }
            
            if !idsToRemove.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: idsToRemove)
            }
            completion()
        }
    }
    
    func formattedDateIdentifier(from components: DateComponents) -> String {
        let y = components.year ?? 0
        let m = components.month ?? 0
        let d = components.day ?? 0
        let h = components.hour ?? 0
        let min = components.minute ?? 0
        return "\(y)-\(m)-\(d)-\(h)-\(min)"
    }
}
