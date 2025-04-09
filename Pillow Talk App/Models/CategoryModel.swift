//
//  CategoryModel.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

struct CategoryModel {
    let id: Int
    let title: String
    let actions: [String]
    let questions: [String]
    let analyticsParam: String
}

extension CategoryModel {
    init?(from document: [String: Any]) {
        guard let id = document["id"] as? Int else {
            print("Failed to parse id")
            return nil
        }
        
        guard let title = document["title"] as? String else {
            print("Failed to parse title")
            return nil
        }
        
        guard let analyticsParam = document["analytics_param"] as? String else {
            print("Failed to parse title")
            return nil
        }
        
        let actionsArray = document["actions"] as? [String] ?? []
        let questionsArray = document["questions"] as? [String] ?? []
        
        self.id = id
        self.title = title
        self.actions = actionsArray
        self.questions = questionsArray
        self.analyticsParam = analyticsParam
    }
}
