//
//  BurgerReviewViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import Kingfisher
import SnapKit

final class BurgerHouseReviewViewController: BaseViewController {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundBurger")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let burgerReviewCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    )
    
    private var viewModel: BurgerHouseReviewViewModel!
    private var disposeBag: DisposeBag!
    
    static func create(
        viewModel: BurgerHouseReviewViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> BurgerHouseReviewViewController {
        let view = BurgerHouseReviewViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateReview),
            name: Notification.Name("UpdateReview"),
            object: nil
        )
        bind()
        viewModel.viewDidLoad()
    }
    
    @objc
    private func updateReview() {
        print(#function)
        viewModel.firstFetchBurgerHouseReview()
    }
    
    override func configureNavigation() {
        navigationItem.title = "버거리뷰"
    }
    
    override func configureHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(burgerReviewCollectionView)
    }
    
    override func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        burgerReviewCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        burgerReviewCollectionView.register(
            BurgerReviewImageCell.self,
            forCellWithReuseIdentifier: BurgerReviewImageCell.identifier
        )
        burgerReviewCollectionView.backgroundColor = .clear
        burgerReviewCollectionView.refreshControl = UIRefreshControl()
        burgerReviewCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(with: self) { owner, _ in
                owner.viewModel.firstFetchBurgerHouseReview()
                owner.burgerReviewCollectionView.refreshControl?.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
}

extension BurgerHouseReviewViewController {
    private func bind() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionBurgerHouseReview> { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BurgerReviewImageCell.identifier, for: indexPath) as? BurgerReviewImageCell else { return UICollectionViewCell() }
            
            if indexPath.row == 0, item.files.count > 1 {
                cell.multipleImageView.isHidden = false
            }
            
            if let file = item.files.first {
                let path = "v1/" + file
                let endPoint = APIURL.lslp.rawValue + path
                
                let url = URL(string: endPoint)
                let modifier = AnyModifier { request in
                    var request = request
                    request.addValue(APIKEY.lslp.rawValue, forHTTPHeaderField: LFRBHeader.sesacKey.rawValue)
                    request.addValue(UserDefaultsAccessStorage.shared.accessToken, forHTTPHeaderField: LFRBHeader.authorization.rawValue)
                    return request
                }
                cell.imageView.kf.indicatorType = .activity
                cell.imageView.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                    switch result {
                    case .success(let data):
                        cell.imageView.image = data.image
                    case .failure(let error):
                        cell.imageView.image = UIImage(named: "burger\(Int.random(in: 0...9))")
                        print(error)
                    }
                }
            } else {
                cell.imageView.image = UIImage(named: "burger\(Int.random(in: 0...9))")
            }
            
            return cell
        }
        
        burgerReviewCollectionView.rx.modelSelected(BurgerHouseReview.self)
            .bind(with: self) { owner, burgerHouseReview in
                owner.viewModel.modelSelected(burgerHouseReview: burgerHouseReview)
            }
            .disposed(by: disposeBag)
        
        viewModel.burgerHouseReviews
            .bind(to: burgerReviewCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.pushReviewDetail
            .bind(with: self) { owner, burgerHouseReview in
                let viewController = BurgerHouseReviewScene.makeView(burgerHouseReview: burgerHouseReview)
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension BurgerHouseReviewViewController {
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.333),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 1, bottom: 2, trailing: 1)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.333))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                         subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}