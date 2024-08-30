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
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.chab20
        label.textColor = R.Color.green
        return label
    }()
    
    private let roadAddressImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse.circle")
        imageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 16))
        imageView.tintColor = R.Color.red
        return imageView
    }()
    
    private let phoneImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "phone.down.circle")
        imageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 16))
        imageView.tintColor = R.Color.red
        return imageView
    }()
    
    private let roadAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "aslkdjlksajd"
        label.font = R.Font.bold16
        label.textColor = R.Color.orange
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.text = "aslkdjlksajd"
        label.font = R.Font.bold16
        label.textColor = R.Color.orange
        return label
    }()
    
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
            sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = true
        }
        
        burgerMapReviewCollectionView.register(
            BurgerMapReviewCollectionViewCell.self,
            forCellWithReuseIdentifier: BurgerMapReviewCollectionViewCell.identifier
        )
        
        viewModel.viewDidLoad()
        bind()
    }
    
    override func configureNavigation() {
//        navigationItem.title = "BURGER HOUSE"
    }
    
    override func configureHierarchy() {
        view.addSubview(nameLabel)
        view.addSubview(roadAddressImage)
        view.addSubview(phoneImage)
        view.addSubview(roadAddressLabel)
        view.addSubview(phoneLabel)
        view.addSubview(burgerMapReviewCollectionView)
    }
    
    override func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        roadAddressImage.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(20)
        }
        
        phoneImage.snp.makeConstraints { make in
            make.top.equalTo(roadAddressImage.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.size.equalTo(20)
        }
        
        roadAddressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(roadAddressImage.snp.centerY)
            make.leading.equalTo(roadAddressImage.snp.trailing).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.centerY.equalTo(phoneImage.snp.centerY)
            make.leading.equalTo(phoneImage.snp.trailing).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        burgerMapReviewCollectionView.snp.makeConstraints { make in
            make.top.equalTo(phoneImage.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
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
                cell.configureContents(contents: item)
                
                return cell
            }
        )
        
        viewModel.setBurgerHouse
            .bind(with: self) { owner, burgerHouse in
                owner.nameLabel.text = burgerHouse.name
                owner.roadAddressLabel.text = burgerHouse.roadAddress
                owner.phoneLabel.text = burgerHouse.phone
            }
            .disposed(by: disposeBag)
        
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
            heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize, subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
