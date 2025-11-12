//
//  FirebaseServise.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 29.12.2024.
//

import Foundation
import FirebaseFirestore

// MARK: - NotificationDataModel

struct NotificationDataModel {
    let title: String?
    let messages: [String]
    
    func title(with fallback: String) -> String {
        return title ?? fallback
    }
}

extension NotificationDataModel {
    init?(from document: [String: Any]) {
        // Title опционален - если его нет в Firebase, будет использован fallback
        let title = document["title"] as? String
        let messages = document["values"] as? [String] ?? []
        
        guard !messages.isEmpty else {
            print("Failed to parse notification messages: messages array is empty")
            return nil
        }
        
        self.title = title
        self.messages = messages
    }
}

// MARK: - FirebaseService

final public class FirebaseService {
    private let firestore: Firestore
    
    init() {
        self.firestore = Firestore.firestore()
    }

    func getCategories(with language: DataLanguage, completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        let docRef = firestore.collection(language.languageCode).document(language.documentId)
        
        docRef.collection("Categories").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No categories found"])))
                return
            }
            
            let categories = documents.compactMap({ CategoryModel(from: $0.data()) }).sorted { $0.id < $1.id }
            completion(.success(categories))
        }
    }
    
    func getIdeas(with language: DataLanguage, completion: @escaping (Result<[String], Error>) -> Void) {
        let docRef = firestore.collection(language.languageCode).document(language.documentId)
        
        docRef.collection("Ideas").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No ideas found"])))
                return
            }
            
            let ideas: [String] = (documents.first?.data()["values"] as? [String]) ?? []
            
            completion(.success(ideas))
        }
    }
    
    func getLocalNotifications(with language: DataLanguage, completion: @escaping (Result<NotificationDataModel, Error>) -> Void) {
        let docRef = firestore.collection(language.languageCode).document(language.documentId)
        
        docRef.collection("Notifications").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents,
                  let firstDocument = documents.first else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No notifications found"])))
                return
            }
            
            guard let notificationData = NotificationDataModel(from: firstDocument.data()) else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to parse notification data"])))
                return
            }
            
            completion(.success(notificationData))
        }
    }
    
    func saveFCMTokenToFirestore(_ token: String) {
        let userID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        firestore.collection("PushTokens").document(userID).setData(["token": token])
    }
}


enum DataLanguage: String {
    case ua = "uk"
    case en = "en"
    case es = "es"
    case pl = "pl"
    
    var languageCode: String {
        switch self {
        case .ua:
            return "UA"
        case .en:
            return "EN"
        case .es:
            return "ES"
        case .pl:
            return "PL"
        }
    }
    
    var documentId: String {
        switch self {
        case .ua:
            return "YLcUw8LUbyjrBQv2YGfm"
        case .en:
            return "HyWulLJV8YyHfZMGsRaI"
        case .es:
            return "RI5NVceI8WWUdHV9KyCI"
        case .pl:
            return "HuYHZNn76k32rcsJsX20"
        }
    }
    
    var notificationTitle: String {
        switch self {
        case .ua:
            return "Час поспілкуватись 💕"
        case .en:
            return "Time to talk ❤️"
        case .es:
            return "Hora de conversar 💖"
        case .pl:
            return "Czas na rozmowę 💞"
        }
    }
}
