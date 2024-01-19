//
//  FoodCell.swift
//  PizzaApp
//
//  Created by Виталий Коростелев on 15.01.2024.
//

import UIKit

class FoodsListSectionCell: UICollectionViewCell {
    
    static let identifier = "MenuCell"
    
    static let imageCache = NSCache<NSString, UIImage>()

    // MARK: - Properties
    
    private var spicyStatus: String? {
        didSet {
            if spicyStatus != nil {
                setupSpicyIcon()
            }
        }
    }
    
    private var noContent: Bool = false {
        didSet {
            if noContent {
                reSetupPriceAndWeight()
            }
        }
    }
    
    // MARK: - UI Components
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.masksToBounds = true
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.systemGray
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pepperImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "spicy")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Purple")
        button.setTitleColor(.white, for: .normal)
        button.setTitle("В корзину", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupUI()
        layer.cornerRadius = 12
        self.noContent = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        resetCell()
        setupUI()
        self.noContent = false
    }
    
    public func configure(with food: MenuListItem) {
        
        if let imagePath = food.image {
            if let cachedImage = FoodsListSectionCell.imageCache.object(forKey: imagePath as NSString) {
                self.image.image = cachedImage
            } else {
                NetworkManager.getImage(imagePath: imagePath) { result in
                    switch result {
                    case .success(let image):
                        FoodsListSectionCell.imageCache.setObject(image, forKey: imagePath as NSString)
                        DispatchQueue.main.async {
                            self.image.image = image
                        }
                    case .failure(let error):
                        print("Error loading image: \(error)")
                    }
                }
            }
        }
        
        self.nameLabel.text = food.name
        self.contentLabel.text = food.content
        if food.content.isEmpty {
            noContent = true
        }
        self.priceLabel.text = food.price
        if let foodWeight = food.weight {
            self.weightLabel.text = foodWeight
        } else {
            self.weightLabel.removeFromSuperview()
        }
        self.spicyStatus = food.spicy
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupContainer()
        setupButton()
    }
    
    private func resetCell() {
        self.spicyStatus = nil
        self.image.image = nil
        self.pepperImage.removeFromSuperview()
        reSetupPriceAndWeight()
        setupUI()
        self.noContent = false
    }
    
    private func reSetupPriceAndWeight() {
        if priceLabel.superview != containerView {
            priceLabel.removeFromSuperview()
            containerView.addSubview(priceLabel)
        }
        
        if weightLabel.superview != containerView {
            weightLabel.removeFromSuperview()
            containerView.addSubview(weightLabel)
        }
        
        if containerView.superview != self {
            addSubview(containerView)
        }
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 4),
            priceLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            weightLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            weightLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
    
    
    private func setupSpicyIcon() {
        addSubview(pepperImage)
        
        NSLayoutConstraint.activate([
            pepperImage.bottomAnchor.constraint(equalTo: image.topAnchor, constant: -8),
            pepperImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            pepperImage.heightAnchor.constraint(equalToConstant: 24),
            pepperImage.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    private func setupButton() {
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.centerYAnchor.constraint(equalTo: image.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupContainer() {
        addSubview(containerView)
        containerView.addSubview(image)
        containerView.addSubview(nameLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(priceLabel)
        containerView.addSubview(weightLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            image.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5),
            image.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            priceLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 4),
            priceLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            weightLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            weightLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
    
}
