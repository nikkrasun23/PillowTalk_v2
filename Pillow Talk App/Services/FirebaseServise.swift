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
    
    func getRandomQuestion(for category: String, completion: @escaping (Result<[QuestionModel], Error>) -> Void) {
        let collectionName = "Question_\(category)_UA"
        firestore.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found for category \(category)."])))
                return
            }
            
            // Собираем все вопросы из документов (все строки из данных документа)
            var questions: [QuestionModel] = []
            
            for document in snapshot.documents {
                for (key, value) in document.data() {
                    if let question = value as? String {
                        questions.append(
                            .init(
                                id: key,
                                text: question
                            )
                        )
                    } else {
                        completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No questions available for category \(category)."])))
                    }
                }
            }
            
            completion(.success(questions))
        }
    }
    
    // Получение случайного действия из конкретной категории
    func getRandomAction(for category: String, completion: @escaping (Result<String, Error>) -> Void) {
        let collectionName = "Action_\(category)_UA"
        firestore.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found for category \(category)."])))
                return
            }
            
            // Собираем все действия из документов (все строки из данных документа)
            var actions: [String] = []
            for document in snapshot.documents {
                for (_, value) in document.data() {
                    if let action = value as? String {
                        actions.append(action)
                    }
                }
            }
            
            // Выбираем случайное действие
            if let randomAction = actions.randomElement() {
                completion(.success(randomAction))
            } else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No actions available for category \(category)."])))
            }
        }
    }
    
    // Получение случайной идеи (свидания) из коллекции Dates_UA
    func getRandomDate(completion: @escaping (Result<String, Error>) -> Void) {
        let collectionName = "Dates_UA"
        firestore.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Данные для Dates_UA не найдены."])))
                return
            }
            
            // Собираем все идеи (свидания) из документов (все строки из данных документа)
            var dates: [String] = []
            for document in snapshot.documents {
                for (_, value) in document.data() {
                    if let dateIdea = value as? String {
                        dates.append(dateIdea)
                    }
                }
            }
            
            // Выбираем случайную идею
            if let randomDate = dates.randomElement() {
                completion(.success(randomDate))
            } else {
                completion(.failure(NSError(domain: "FirebaseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Нет доступных идей для Dates_UA."])))
            }
        }
    }
}


