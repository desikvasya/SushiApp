//
//  MenuModel.swift
//  PizzaApp
//
//  Created by Виталий Коростелев on 16.01.2024.
//

import Foundation

// MARK: - Menu

struct Menu: Decodable {
    let status: Bool
    let menuList: [MenuListItem]
}

struct MenuListItem: Decodable {
    let id: String
    let image: String?
    var name: String
    let content: String
    var price: String
    var weight: String?
    let spicy: String?
}


// MARK: - Categories

struct Categories: Decodable {
    let status: Bool
    let menuList: [CategoryItem]
}

struct CategoryItem: Decodable {
    let menuID : String
    let image: String?
    let name: String
    let subMenuCount: Int
}
