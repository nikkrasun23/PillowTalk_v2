//
//  CacheService.swift
//  Pillow Talk App
//
//  Created by AI Assistant
//

import Foundation

final class CacheService {
    static let shared = CacheService()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        cacheDirectory = documentsPath.appendingPathComponent("OfflineCache")
        
        // Create cache directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    // MARK: - Save Data
    
    func saveCategories(_ categories: [CategoryModel], for language: DataLanguage) {
        let fileURL = cacheDirectory.appendingPathComponent("categories_\(language.rawValue).json")
        
        do {
            let dicts = categories.map { categoryToDict($0) }
            let data = try JSONSerialization.data(withJSONObject: dicts, options: .prettyPrinted)
            try data.write(to: fileURL)
            print("✅ Categories cached for language: \(language.rawValue)")
        } catch {
            print("❌ Failed to cache categories: \(error)")
        }
    }
    
    func saveIdeas(_ ideas: [String], for language: DataLanguage) {
        let fileURL = cacheDirectory.appendingPathComponent("ideas_\(language.rawValue).json")
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(ideas)
            try data.write(to: fileURL)
            print("✅ Ideas cached for language: \(language.rawValue)")
        } catch {
            print("❌ Failed to cache ideas: \(error)")
        }
    }
    
    // MARK: - Load Data
    
    func loadCategories(for language: DataLanguage) -> [CategoryModel]? {
        let fileURL = cacheDirectory.appendingPathComponent("categories_\(language.rawValue).json")
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            guard let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                print("❌ Failed to parse cached categories JSON")
                return nil
            }
            let categories = jsonArray.compactMap { CategoryModel(from: $0) }
            print("✅ Loaded \(categories.count) categories from cache for language: \(language.rawValue)")
            return categories
        } catch {
            print("❌ Failed to load cached categories: \(error)")
            return nil
        }
    }
    
    func loadIdeas(for language: DataLanguage) -> [String]? {
        let fileURL = cacheDirectory.appendingPathComponent("ideas_\(language.rawValue).json")
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let ideas = try decoder.decode([String].self, from: data)
            print("✅ Loaded \(ideas.count) ideas from cache for language: \(language.rawValue)")
            return ideas
        } catch {
            print("❌ Failed to load cached ideas: \(error)")
            return nil
        }
    }
    
    // MARK: - Check Cache Status
    
    func hasCachedData(for language: DataLanguage) -> Bool {
        let categoriesURL = cacheDirectory.appendingPathComponent("categories_\(language.rawValue).json")
        let ideasURL = cacheDirectory.appendingPathComponent("ideas_\(language.rawValue).json")
        
        return fileManager.fileExists(atPath: categoriesURL.path) && 
               fileManager.fileExists(atPath: ideasURL.path)
    }
    
    // MARK: - Clear Cache
    
    func clearCache(for language: DataLanguage) {
        let categoriesURL = cacheDirectory.appendingPathComponent("categories_\(language.rawValue).json")
        let ideasURL = cacheDirectory.appendingPathComponent("ideas_\(language.rawValue).json")
        
        try? fileManager.removeItem(at: categoriesURL)
        try? fileManager.removeItem(at: ideasURL)
        
        print("🗑️ Cache cleared for language: \(language.rawValue)")
    }
    
    // MARK: - Helper Methods
    
    private func categoryToDict(_ category: CategoryModel) -> [String: Any] {
        return [
            "id": category.id,
            "title": category.title,
            "actions": category.actions,
            "questions": category.questions,
            "analytics_param": category.analyticsParam,
            "overlay_title": category.overlayTitle
        ]
    }
}

