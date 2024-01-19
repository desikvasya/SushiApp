//
//  NetworkManager.swift
//  PizzaApp
//
//  Created by Виталий Коростелев on 16.01.2024.
//

import UIKit

enum NetworkError: Error {
    case noData
    case jsonParsing
    case invalidURL
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    static func getMenuCategories(completion: @escaping (Result<[CategoryItem], Error>) -> Void) {
        let endpoint = Endpoint.getMenuCategories
        performRequest(with: endpoint) { (data, error) in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(Categories.self, from: data)
                    completion(.success(response.menuList))
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NetworkError.noData))
            }
        }
    }
    
    static func getMenuItems(menuID: String, completion: @escaping (Result<[MenuListItem], Error>) -> Void) {
        let endpoint = Endpoint.getSubMenu.appendingQueryItem(name: "menuID", value: menuID)
        performRequest(with: endpoint) { (data, error) in
            if let data = data {                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = json as? [String: Any], let menuList = dictionary["menuList"] as? [[String: Any]] {
                        let items = try JSONSerialization.data(withJSONObject: menuList, options: [])
                        let decodedItems = try JSONDecoder().decode([MenuListItem].self, from: items)
                        completion(.success(decodedItems))
                    } else {
                        print("Error: Unable to parse JSON")
                        completion(.failure(NetworkError.jsonParsing))
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NetworkError.noData))
            }
        }
    }
    
    
    static func getImage(imagePath: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
            guard let imageUrl = URL(string: "https://vkus-sovet.ru\(imagePath)") else {
                completion(.failure(NetworkError.invalidURL))
                return
            }

            let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(.failure(error))
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    print("No data received or unable to convert data to UIImage")
                    completion(.failure(NetworkError.noData))
                    return
                }

                completion(.success(image))
            }

            task.resume()
        }
    
    
    private static func performRequest(with endpoint: Endpoint, completion: @escaping (Data?, Error?) -> Void) {
        let url = endpoint.url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil, NetworkError.noData)
                return
            }
            
            completion(data, nil)
        }
        
        task.resume()
    }
    
}
