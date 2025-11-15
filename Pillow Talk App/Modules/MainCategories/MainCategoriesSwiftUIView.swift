//
//  MainCategoriesSwiftUIView.swift
//  Pillow Talk App
//
//  Created by i.kostiukevych on 10/03/2025.
//

import SwiftUI
import Foundation

struct MainCategoriesSwiftUIView: View {
    @ObservedObject var viewModel: MainCategoriesSwiftUIViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerView
                
                if viewModel.isSubscribed {
                    premiumCardsView
                } else {
                    premiumPromptView
                }
                
                categoriesSection
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
        }
        .scrollContentBackground(.hidden)
        .background(alignment: .topTrailing) {
            Image("greenPlant")
                .resizable()
                .scaledToFit()
                .frame(width: 186, height: 184)
                .ignoresSafeArea(edges: .top)
        }
        .background(alignment: .bottomLeading) {
            Image("orangePlant")
                .resizable()
                .scaledToFit()
                .frame(width: 186, height: 184)
                .ignoresSafeArea(edges: .leading)
                .padding(.leading, -10)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        Text(NSLocalizedString("mainCategoriesHeader", comment: ""))
            .font(.custom("Commissioner-SemiBold", size: 24))
            .foregroundColor(Color(hex: "#33363F"))
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Premium Cards
    
    private var premiumCardsView: some View {
        HStack(spacing: 16) {
            dateJarCard
            instagramCard
        }
    }
    
    private var dateJarCard: some View {
        Button(action: {
            viewModel.onDateJarTap?()
        }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(NSLocalizedString("mainCategoriesNewTag", comment: ""))
                    .font(.custom("Commissioner-SemiBold", size: 12))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#DB5A3D"))
                    .cornerRadius(20)
                
                Text(NSLocalizedString("tabDateJar", comment: ""))
                    .font(.custom("Commissioner-SemiBold", size: 18))
                    .foregroundColor(Color(hex: "#33363F"))
                
                Text(NSLocalizedString("mainCategoriesTryNewFeatures", comment: ""))
                    .font(.custom("Commissioner-Regular", size: 14))
                    .foregroundColor(Color(hex: "#33363F"))
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 132)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
    
    private var instagramCard: some View {
        Button(action: {
            viewModel.onInstagramTap?()
        }) {
            VStack(alignment: .leading, spacing: 16) {
                Image("instagram")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Text(NSLocalizedString("mainCategoriesFollowInstagram", comment: ""))
                    .font(.custom("Commissioner-SemiBold", size: 16))
                    .foregroundColor(Color(hex: "#33363F"))
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
            .padding(.bottom, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 132)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
    
    // MARK: - Premium Prompt
    
    private var premiumPromptView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .foregroundStyle(Color(hex: "#FBD8D1"))
                    
                    Image("lock")
                        .frame(width: 24, height: 24)
                }
                .frame(width: 44, height: 44)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(NSLocalizedString("mainCategoriesUseWithoutLimits", comment: ""))
                        .font(.custom("Commissioner-SemiBold", size: 18))
                        .foregroundColor(Color(hex: "#33363F"))
                    
                    Text(String(format: NSLocalizedString("mainCategoriesDailyLimit", comment: ""), viewModel.viewedCardsCount))
                        .font(.custom("Commissioner-Regular", size: 16))
                        .foregroundColor(Color(hex: "#444444"))
                }
            }
            
            Button(action: {
                viewModel.onSubscribeTap?()
            }) {
                Text(NSLocalizedString("mainCategoriesSubscribe", comment: ""))
                    .font(.custom("Commissioner-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color(hex: "#DB5A3D"))
                    .cornerRadius(20)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(20)
    }
    
    // MARK: - Categories Section
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(NSLocalizedString("mainCategoriesAllQuestions", comment: ""))
                    .font(.custom("Commissioner-SemiBold", size: 18))
                    .foregroundColor(Color(hex: "#33363F"))
                
                if !viewModel.isSubscribed {
                    Text(NSLocalizedString("mainCategoriesAvailableCategory", comment: ""))
                        .font(.custom("Commissioner-Regular", size: 14))
                        .foregroundColor(Color(hex: "#B3B8C6"))
                }
            }
            
            if viewModel.categories.isEmpty {
                Text(NSLocalizedString("mainCategoriesLoading", comment: ""))
                    .font(.custom("Commissioner-Regular", size: 14))
                    .foregroundColor(Color(hex: "#B3B8C6"))
                    .padding()
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.categories, id: \.id) { category in
                        categoryRow(category: category)
                    }
                }
            }
        }
    }
    
    private func categoryRow(category: CategoryModel) -> some View {
        let isLocked = !viewModel.isSubscribed && category.id != 0
        
        return Button(action: {
            if isLocked {
                viewModel.onSubscribeTap?()
            } else {
                viewModel.onCategoryTap?(category.id)
            }
        }) {
            HStack(spacing: 12) {
                if isLocked {
                    ZStack {
                        Circle()
                            .foregroundStyle(Color(hex: "#FBD8D1"))
                        
                        Image("lock")
                            .frame(width: 24, height: 24)
                    }
                    .frame(width: 44, height: 44)
                } else {
                    if let iconImage = UIImage(named: iconName(for: category.id)) {
                        ZStack {
                            Circle()
                                .foregroundStyle(Color(hex: "#C0DBDE"))
                            
                            Image(uiImage: iconImage)
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 44, height: 44)
                    }
                }
                
                Text(category.title)
                    .font(.custom("Commissioner-SemiBold", size: 16))
                    .foregroundColor(Color(hex: "#33363F"))
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            .background(Color.white)
            .cornerRadius(30)
        }
    }
    
    private func iconName(for categoryId: Int) -> String {
        switch categoryId {
        case 0: return "shapeOneBlack"
        case 1: return "shapeSecondBlack"
        case 2: return "shapeThirdBlack"
        case 3: return "shapeFourthBlack"
        case 4: return "shapeFivthBlack"
        default: return "shapeDefaulBlack"
        }
    }
}

// MARK: - ViewModel

class MainCategoriesSwiftUIViewModel: ObservableObject {
    @Published var isSubscribed: Bool = false
    @Published var categories: [CategoryModel] = []
    @Published var viewedCardsCount: Int = 0
    
    var onDateJarTap: (() -> Void)?
    var onInstagramTap: (() -> Void)?
    var onCategoryTap: ((Int) -> Void)?
    var onSubscribeTap: (() -> Void)?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(subscriptionStatusChanged),
            name: NSNotification.Name("SubscriptionStatusChanged"),
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func subscriptionStatusChanged() {
        loadData()
    }
    
    func loadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isSubscribed = UserDefaultsService.isSubscribed
            self.categories = StorageService.shared.categories.sorted { $0.id < $1.id }
            UserDefaultsService.resetViewedCardsIfNeeded()
            self.viewedCardsCount = UserDefaultsService.viewedCardsCount
        }
    }
}

// MARK: - Color Extension for SwiftUI

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

