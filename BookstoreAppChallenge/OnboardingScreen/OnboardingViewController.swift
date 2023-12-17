//
//  OnboardingViewController.swift
//  BookstoreAppChallenge
//
//  Created by Victor on 05.12.2023.
//

import UIKit

final class OnboardingViewController: UIViewController, OnboardingInput {
    
    typealias OnboardingCell = CollectionCell<UILabel>
    
    private enum Layout {
        static let logoSize: CGFloat = 136
        static let buttonInset: CGFloat = 20
        static let buttonHeight: CGFloat = 56
        static let buttonBottomOffset: CGFloat = 84
        static let collectionHeight: CGFloat = 100
    }
    
    var presenter: OnboardingOutput!
    
    private let imageView = UIImageView()
    private let logoImageView = UIImageView()
    private let pageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = Colors.grayPrimary
        pc.currentPageIndicatorTintColor = Colors.blackPrimary
        pc.isUserInteractionEnabled = false
        return pc
    }()
    private lazy var colletionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.register(OnboardingCell.self, forCellWithReuseIdentifier: "onboardingCell")
        cv.backgroundColor = .clear
        return cv
    }()
    private lazy var button = DefaultButton()
    private var items = [ViewModel.Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        presenter.activate()
    }
    
    func updateUI(with model: ViewModel) {
        items = model.items
        
        pageControl.numberOfPages = items.count
        pageControl.currentPage = 0
        
        button.update(model: model.button)
        
        colletionView.reloadData()
    }
    
    private func configure() {
        view.backgroundColor = Colors.Background.lvl1
        
        view.addSubview(imageView)
        view.addSubview(colletionView)
        view.addSubview(logoImageView)
        view.addSubview(pageControl)
        view.addSubview(button)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY)
        }
        imageView.image = Images.onboardingBackground
        imageView.contentMode = .scaleAspectFill
        
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(Layout.logoSize)
            $0.center.equalToSuperview()
        }
        logoImageView.image = Images.logo
        logoImageView.contentMode = .scaleAspectFit
        
        colletionView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Layout.collectionHeight)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(colletionView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Layout.buttonInset)
            $0.height.equalTo(Layout.buttonHeight)
            $0.bottom.equalToSuperview().offset(-Layout.buttonBottomOffset)
        }
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout {
            _, _ in
            
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Layout.collectionHeight))
            let item = NSCollectionLayoutItem(layoutSize: size)
            item.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            
            return section
        }
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCell", for: indexPath) as? OnboardingCell else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.row]
        cell.update(with: .init(text: item.text, textAlignment: .center))
        cell.backgroundColor = Colors.Background.lvl2
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
}

extension OnboardingViewController {
    struct ViewModel {
        struct Item {
            let text: String
        }
        
        let items: [Item]
        let button: DefaultButton.Model
    }
}
