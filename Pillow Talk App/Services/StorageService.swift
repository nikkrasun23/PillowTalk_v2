//
//  StorageService.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import Foundation

final class StorageService {
    // MARK: - Singleton Instance
    static let shared = StorageService()
    
    var categories: [CategoryModel] = []
    var ideas: [String] = []
    
    // MARK: - Private init to ensure singleton usage
    private init() {}
    
}
