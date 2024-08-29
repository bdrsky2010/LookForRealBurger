//
//  BurgerMapHouseViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class BurgerMapHouseViewController: BaseViewController {
    private let burgerMapReviewCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )
    
    private var viewModel: BurgerMapHouseViewModel!
    private var disposeBag: DisposeBag!
    
    static func create(
        viewModel: BurgerMapHouseViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> BurgerMapHouseViewController {
        let view = BurgerMapHouseViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.largestUndimmedDetentIdentifier = .medium
            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        burgerMapReviewCollectionView.register(
            BurgerMapReviewCollectionViewCell.self,
            forCellWithReuseIdentifier: BurgerMapReviewCollectionViewCell.identifier
        )
        
        viewModel.viewDidLoad()
        bind()
    }
    
    override func configureHierarchy() {
        view.addSubview(burgerMapReviewCollectionView)
    }
    
    override func configureLayout() {
        burgerMapReviewCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureUI() {
        burgerMapReviewCollectionView.backgroundColor = .clear
    }
}

extension BurgerMapHouseViewController {
    private func bind() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionBurgerHouseReview>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BurgerMapReviewCollectionViewCell.identifier, for: indexPath) as? BurgerMapReviewCollectionViewCell else { return UICollectionViewCell() }
                cell.nickLabel.text = item.creator.nick
                cell.images = item.files
                cell.imageCollectionView.reloadData()
                cell.titleLabel.text = item.title
                cell.contentLabel.text = item.content
                return cell
            }
        )
        
        viewModel.burgerHouseReviews
            .bind(to: burgerMapReviewCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.goToLogin
            .bind(with: self) { owner, _ in
                owner.goToLogin()
            }
            .disposed(by: disposeBag)
    }
}

extension BurgerMapHouseViewController {
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 30, trailing: 0)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(600)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
