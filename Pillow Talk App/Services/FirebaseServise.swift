//
//  FirebaseServise.swift
//  Pillow Talk App
//
//  Created by Nik Krasun on 29.12.2024.
//

import Foundation
import FirebaseFirestore

final public class FirebaseService {
    private let firestore: Firestore
    
    init() {
        self.firestore = Firestore.firestore()
    }

    func getCategories(with language: String, completion: @escaping (Result<[CategoryModel], Error>) -> Void) {
        let docRef = firestore.collection(language).document("YLcUw8LUbyjrBQv2YGfm")
        
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
    
    func getIdeas(with language: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let docRef = firestore.collection(language).document("YLcUw8LUbyjrBQv2YGfm")
        
        docRef.collection("Ideas").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No categories found"])))
                return
            }
            
            let ideas: [String] = (documents.first?.data()["values"] as? [String]) ?? []
            
            completion(.success(ideas))
        }
    }
    
    func saveFCMTokenToFirestore(_ token: String) {
        let userID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        firestore.collection("PushTokens").document(userID).setData(["token": token])
    }
}
