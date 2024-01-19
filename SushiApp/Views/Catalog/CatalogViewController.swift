//
//  CatalogViewController.swift
//  PizzaApp
//
//  Created by Виталий Коростелев on 15.01.2024.
//

import UIKit

class CatalogViewController: UIViewController {
    
    private var selectedIndex = 0
    
    // MARK: - Properties
    
    private var viewModel = CatalogViewModel()
    
    private lazy var collectionView: UICollectionView = {
        let compositionalLayout = createCompositionalLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        cv.backgroundColor = UIColor(named: "Background")
        cv.register(MenuCategoriesSectionCell.self, forCellWithReuseIdentifier: MenuCategoriesSectionCell.identifier)
        cv.register(FoodsListSectionCell.self, forCellWithReuseIdentifier: FoodsListSectionCell.identifier)
        cv.register(CollectionHeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        loadingIndicator.startAnimating()
        viewModel.delegate = self
        viewModel.getCategories()
    }
    
    
    // MARK: - UI Setup
    
    private func setupView() {
        view.backgroundColor = UIColor(named: "Background")
        configureNavBar()
        viewModel.delegate = self
    }
    
    private func configureNavBar() {
        self.navigationController?.navigationBar.tintColor = .white
        
        configureCallButton()
        configureLeftBarItem()
    }
    
    private func configureCallButton() {
        let callButton = UIButton(type: .system)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        callButton.tintColor = .white
        
        let buttonSize = CGSize(width: 40, height: 40)
        callButton.frame = CGRect(origin: .zero, size: buttonSize)
        
        if let originalImage = UIImage(systemName: "phone") {
            let resizedImage = originalImage.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20))
            callButton.setImage(resizedImage, for: .normal)
        }
        
        let callBarButton = UIBarButtonItem(customView: callButton)
        self.navigationItem.rightBarButtonItem = callBarButton
    }
    
    private func configureLeftBarItem() {
        let leftBarItem = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width * 0.3, height: 50))
        
        let imageSize = CGSize(width: 30, height: 30)
        
        let imageLogo = UIImageView(image: UIImage(named: "logo"))
        imageLogo.contentMode = .scaleAspectFit
        imageLogo.frame = CGRect(x: 0, y: 10, width: imageSize.width, height: imageSize.height)
        
        let titleLabel = UILabel()
        titleLabel.text = "VKUSSOVET"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: imageSize.width + 5, y: 10, width: titleLabel.frame.width, height: imageSize.height)
        
        leftBarItem.addSubview(imageLogo)
        leftBarItem.addSubview(titleLabel)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarItem)
    }
    
    // MARK: - Actions
    
    @objc private func callButtonTapped() {
        let phoneNumber = "+79370255244"
        showCallActionSheet(phoneNumber: phoneNumber)
    }
    
    private func showCallActionSheet(phoneNumber: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let callAction = UIAlertAction(title: phoneNumber, style: .default) { [weak self] _ in
            self?.makePhoneCall(number: phoneNumber)
        }
        alert.addAction(callAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func makePhoneCall(number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Device cannot make a phone call")
        }
    }
    
    // MARK: - CollectionView Setup
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionID, _) -> NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }
            
            if sectionID == 0 {
                return self.menuCategoriesLayoutSection()
            } else {
                let section = self.listFoodsLayoutSection()
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
                let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                section.boundarySupplementaryItems = [headerElement]
                
                return section
            }
        }
    }
    
    
    private func menuCategoriesLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        return section
    }
    
    private func listFoodsLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.65))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 44
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [headerElement]
        
        return section
    }
}

extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Sections.categories.rawValue {
            return viewModel.categories.count
        } else if section == Sections.foods.rawValue {
            return viewModel.items.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == Sections.categories.rawValue {
            setHeaderText(text: self.viewModel.categories[indexPath.row].name)
            viewModel.getFoods(for: viewModel.categories[indexPath.row])
            selectedIndex = indexPath.row
            
            updateCollectionData(isLoading: true)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == Sections.categories.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCategoriesSectionCell.identifier, for: indexPath) as! MenuCategoriesSectionCell
            cell.configure(with: viewModel.categories[indexPath.row])
            cell.backgroundColor = selectedIndex == indexPath.row ? UIColor(named: "Purple") : UIColor.darkGray
            
            return cell
        } else if indexPath.section == Sections.foods.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodsListSectionCell.identifier, for: indexPath) as! FoodsListSectionCell
            cell.configure(with: viewModel.items[indexPath.row])
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CollectionHeaderSupplementaryView
            return headerView
        }
        
        return UICollectionReusableView()
    }
}

extension CatalogViewController: CatalogViewModelDelegate {
    func setHeaderText(text: String) {
        DispatchQueue.main.async {
            if let headerView = self.collectionView.visibleSupplementaryViews(ofKind: UICollectionView.elementKindSectionHeader).first as? CollectionHeaderSupplementaryView {
                headerView.configure(with: text)
                self.collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    func updateCollectionData(isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            if isLoading {
                self?.loadingIndicator.startAnimating()
            } else {
                self?.loadingIndicator.stopAnimating()
            }
            self?.collectionView.reloadData()
        }
    }
}


enum Sections: Int {
    case categories = 0
    case foods
    
    static let count = 2
}
