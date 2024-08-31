//
//  BurgerReviewDetailViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Toast
import Kingfisher

final class BurgerHouseReviewDetailViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let titleView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let nickLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.bold18
        label.textColor = R.Color.brown
        return label
    }()
    
    private let reviewImageCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: .createReviewImageLayout()
    )
    
    private let burgerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "burger\(Int.random(in: 0...9))")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = R.Font.bold18
        label.textColor = R.Color.brown
        return label
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "bookmark")?.withTintColor(R.Color.brown, renderingMode: .alwaysOriginal)
        button.configuration?.preferredSymbolConfigurationForImage = .init(font: .systemFont(ofSize: 16, weight: .bold))
        return button
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = R.Font.regular16
        label.textColor = R.Color.green
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.regular12
        label.textColor = R.Color.orange
        return label
    }()
    
    private var viewModel: BurgerHouseReviewDetailViewModel!
    private var disposeBag: DisposeBag!
    
    static func create(
        viewModel: BurgerHouseReviewDetailViewModel,
        disposeBag: DisposeBag = DisposeBag()
    ) -> BurgerHouseReviewDetailViewController {
        let view = BurgerHouseReviewDetailViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        return view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func configureNavigation() {
        setupBackButton()
        navigationItem.title = "IT'S REAL BURGER?"
        let updateButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: nil)
        updateButton.setTitleTextAttributes([.font: R.Font.chab20, .foregroundColor: R.Color.brown], for: .normal)
        updateButton.setTitleTextAttributes([.font: R.Font.chab20, .foregroundColor: R.Color.brown.withAlphaComponent(0.5)], for: .highlighted)
        navigationItem.rightBarButtonItem = updateButton
    }
    
    override func configureHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        headerView.addSubview(burgerImage)
        headerView.addSubview(nickLabel)
        headerView.addSubview(bookmarkButton)
        
        contentView.addSubview(reviewImageCollectionView)
        contentView.addSubview(titleView)
        
        titleView.addSubview(titleLabel)
        
        contentView.addSubview(bottomView)
        bottomView.addSubview(contentLabel)
        bottomView.addSubview(dateLabel)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(bottomView.snp.bottom)
        }
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        burgerImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.leading.equalTo(burgerImage.snp.trailing).offset(16)
            make.center.equalToSuperview()
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(20)
        }
        
        reviewImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(reviewImageCollectionView.snp.width).multipliedBy(1)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(reviewImageCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.verticalEdges.equalToSuperview().inset(16)
        }
        
        
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(contentLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureUI() {
        reviewImageCollectionView.register(
            BurgerReviewImageCell.self,
            forCellWithReuseIdentifier: BurgerReviewImageCell.identifier
        )
        reviewImageCollectionView.backgroundColor = R.Color.brown
        reviewImageCollectionView.isScrollEnabled = false
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            burgerImage.layer.cornerRadius = burgerImage.bounds.width / 2
            burgerImage.layer.borderColor = R.Color.brown.cgColor
            burgerImage.layer.borderWidth = 2
        }
    }
}

extension BurgerHouseReviewDetailViewController {
    private func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.tapBackButton()
            }
            .disposed(by: disposeBag)
        
        viewModel.popViewController
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.configureViewContents
            .bind(with: self) { owner, burgerHouseReview in
                owner.nickLabel.text = burgerHouseReview.creator.nick
                owner.titleLabel.text = burgerHouseReview.title
                owner.contentLabel.text = burgerHouseReview.content
                owner.dateLabel.text = burgerHouseReview.createdAt.convertStringDate
            }
            .disposed(by: disposeBag)
        
        let dataSources = RxCollectionViewSectionedReloadDataSource<SectionImageType> { dataSources, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BurgerReviewImageCell.identifier, for: indexPath) as? BurgerReviewImageCell else { return UICollectionViewCell() }
            
            let path = "v1/" + item
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
            
            return cell
        }
        
        viewModel.configureReviewImages
            .bind(to: reviewImageCollectionView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
    }
}
