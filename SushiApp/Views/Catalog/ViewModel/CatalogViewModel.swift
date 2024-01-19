//
//  CatalogViewModel.swift
//  PizzaApp
//
//  Created by Виталий Коростелев on 17.01.2024.
//

import Foundation

protocol CatalogViewModelDelegate: NSObject {
    func updateCollectionData(isLoading: Bool)
    func setHeaderText(text: String)
}

final class CatalogViewModel {
    
    var categories: [CategoryItem] = [] {
        didSet {
            if let firstCategory = categories.first {
                getFoods(for: firstCategory)
                delegate?.setHeaderText(text: firstCategory.name)
            }
        }
    }
    var items: [MenuListItem] = [] {
        didSet {
            for i in 0..<items.count {
                if (items[i].weight != nil) {
                    items[i].weight = " / \(items[i].weight!)"
                } else {
                    items[i].weight = ""
                }
                items[i].price = String(format: "%.0f", Double(items[i].price)!) + " ₽"
                items[i].name = items[i].name.replacingOccurrences(of: "&quot;", with: "\"")
            }
        }
    }
    
    weak var delegate: CatalogViewModelDelegate?
    
    // MARK: - Public Methods
    
    func getCategories() {
        NetworkManager.getMenuCategories { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let categories):
                self.categories = categories
                self.delegate?.updateCollectionData(isLoading: false)
                
                if let firstCategory = categories.first {
                    self.getFoods(for: firstCategory)
                    self.delegate?.setHeaderText(text: firstCategory.name)
                }
                
            case .failure(let error):
                print("Error getting categories: \(error)")
            }
        }
    }
    
    func getFoods(for category: CategoryItem) {
        NetworkManager.getMenuItems(menuID: category.menuID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let items):
                self.items = items
                self.delegate?.updateCollectionData(isLoading: false)
                
            case .failure(let error):
                print("Error getting menu items: \(error)")
            }
            
        }
    }
    
}
