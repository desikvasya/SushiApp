//
//  CategoriesCell.swift
//  PizzaApp
//
//  Created by Виталий Коростелев on 15.01.2024.
//

//
// CategoriesCell.swift
//

import UIKit

class MenuCategoriesSectionCell: UICollectionViewCell {
    static let identifier = "CategoriesCell"
    
    // MARK: - UI Components
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        
        return image
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 14, weight: .bold)
        title.textAlignment = .center
        return title
    }()
    
    lazy var countItems: UILabel = {
        let count = UILabel()
        count.textColor = UIColor.systemGray
        count.font = .systemFont(ofSize: 12, weight: .medium)
        count.textAlignment = .center
        count.translatesAutoresizingMaskIntoConstraints = false
        return count
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.darkGray
        setupUI()
        layer.masksToBounds = true
        layer.cornerRadius = 12
        setupSelectionColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.image.image = nil
    }
    
    public func configure(with category: CategoryItem) {
        self.title.text = category.name
        self.countItems.text = "\(category.subMenuCount) товаров"

        if let imageUrl = category.image {
            if let cachedImage = FoodsListSectionCell.imageCache.object(forKey: imageUrl as NSString) {
                self.image.image = cachedImage
            } else {
                NetworkManager.getImage(imagePath: imageUrl) { result in
                    switch result {
                    case .success(let image):
                        FoodsListSectionCell.imageCache.setObject(image, forKey: imageUrl as NSString)
                        DispatchQueue.main.async {
                            self.image.image = image
                        }
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - SetupUI
    
    private func setupSelectionColor() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor =  UIColor(named: "Purple")
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    private func setupUI() {
        addSubview(image)
        addSubview(title)
        addSubview(countItems)
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.topAnchor.constraint(equalTo: topAnchor),
            image.leadingAnchor.constraint(equalTo: leadingAnchor),
            image.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 14),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            countItems.centerXAnchor.constraint(equalTo: centerXAnchor),
            countItems.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            countItems.leadingAnchor.constraint(equalTo: leadingAnchor),
            countItems.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
