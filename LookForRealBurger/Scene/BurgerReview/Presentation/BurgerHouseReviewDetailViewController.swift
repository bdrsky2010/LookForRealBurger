//
//  BurgerReviewDetailViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit
import Toast
import Kingfisher

final class BurgerHouseReviewDetailViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = UIView()
    private let buttonView = UIView()
    private let titleView = UIView()
    private let bottomView = UIView()
    
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
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "hand.thumbsup")?.withTintColor(R.Color.red, renderingMode: .alwaysOriginal)
        button.configuration?.titleAlignment = .trailing
        button.configuration?.titlePadding = 4
        button.configuration?.preferredSymbolConfigurationForImage = .init(font: .systemFont(ofSize: 16, weight: .bold))
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "message")?.withTintColor(R.Color.red, renderingMode: .alwaysOriginal)
        button.configuration?.titleAlignment = .trailing
        button.configuration?.titlePadding = 4
        button.configuration?.preferredSymbolConfigurationForImage = .init(font: .systemFont(ofSize: 16, weight: .bold))
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.configuration = .plain()
        button.configuration?.image = UIImage(systemName: "bookmark")?.withTintColor(R.Color.red, renderingMode: .alwaysOriginal)
        button.configuration?.titleAlignment = .trailing
        button.configuration?.titlePadding = 4
        button.configuration?.preferredSymbolConfigurationForImage = .init(font: .systemFont(ofSize: 16, weight: .bold))
        return button
    }()
    
    private let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal)
        imageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 18, weight: .bold))
        return imageView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.bold14
        label.textColor = R.Color.brown
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = R.Font.bold18
        label.textColor = R.Color.brown
        return label
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
    
    private let burgerHouseButton = PretendardRoundedButton(title: "", subtitle: "으로 이동", font: R.Font.chab20, subFont: R.Font.bold16, backgroudColor: R.Color.red)
    
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
        contentView.addSubview(reviewImageCollectionView)
        contentView.addSubview(buttonView)
        contentView.addSubview(titleView)
        contentView.addSubview(bottomView)
        
        headerView.addSubview(burgerImage)
        headerView.addSubview(nickLabel)
        
        buttonView.addSubview(likeButton)
        buttonView.addSubview(commentButton)
        buttonView.addSubview(bookmarkButton)
        buttonView.addSubview(starImage)
        buttonView.addSubview(ratingLabel)
        
        titleView.addSubview(titleLabel)
        
        bottomView.addSubview(contentLabel)
        bottomView.addSubview(dateLabel)
        bottomView.addSubview(burgerHouseButton)
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
        
        reviewImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(reviewImageCollectionView.snp.width).multipliedBy(1)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(reviewImageCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
        commentButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(likeButton.snp.trailing).offset(20)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(commentButton.snp.trailing).offset(20)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
        starImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(bookmarkButton.snp.trailing).offset(16)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(starImage.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(20)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom)
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
        }
        
        burgerHouseButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
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
        
        burgerImage.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.burgerImageTap()
            }
            .disposed(by: disposeBag)
        
        likeButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.viewModel.likeTap()
            }
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.viewModel.commentTap()
            }
            .disposed(by: disposeBag)
        
        bookmarkButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.viewModel.bookmarkTap()
            }
            .disposed(by: disposeBag)
        
        burgerHouseButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.burgerHouseTap()
            }
            .disposed(by: disposeBag)
        
        viewModel.popViewController
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.configureViewContents
            .bind(with: self) { owner, burgerHouseReview in
                guard let review = burgerHouseReview.first else { return }
                owner.nickLabel.text = review.creator.nick
                owner.titleLabel.text = review.title
                owner.contentLabel.text = review.content
                owner.dateLabel.text = review.createdAt.convertStringDate
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
        
        viewModel.configureBurgerHouseButton
            .bind(with: self) { owner, title in
                owner.burgerHouseButton.configuration?.attributedTitle = AttributedString(
                    NSAttributedString(
                        string: title,
                        attributes: [
                            NSAttributedString.Key.font: R.Font.chab20,
                            NSAttributedString.Key.foregroundColor: R.Color.background
                        ]
                    )
                )
            }
            .disposed(by: disposeBag)
        
        viewModel.isMyReview
            .bind(with: self) { owner, isMyReview in
                if #available(iOS 16.0, *) {
                    owner.navigationItem.rightBarButtonItem?.isHidden = !isMyReview
                } else {
                    owner.navigationItem.rightBarButtonItem?.setValue(!isMyReview, forKey: "hidden")
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isLike
            .bind(with: self) { owner, isLike in
                owner.likeButton.configuration?.image = UIImage(systemName: isLike ? "hand.thumbsup.fill" : "hand.thumbsup")?
                    .withTintColor(R.Color.red, renderingMode: .alwaysOriginal)
            }
            .disposed(by: disposeBag)
        
        viewModel.likeCount
            .bind(with: self) { owner, count in
                owner.likeButton.configuration?.attributedTitle = AttributedString(
                    NSAttributedString(
                        string: count.formatted(),
                        attributes: [
                            .font: R.Font.bold14,
                            .foregroundColor: R.Color.brown
                        ]
                    )
                )
            }
            .disposed(by: disposeBag)
        
        viewModel.commentCount
            .bind(with: self) { owner, count in
                owner.commentButton.configuration?.attributedTitle = AttributedString(
                    NSAttributedString(
                        string: count.formatted(),
                        attributes: [.font: R.Font.bold14, .foregroundColor: R.Color.brown]
                    )
                )
            }
            .disposed(by: disposeBag)
        
        viewModel.isBookmark
            .bind(with: self) { owner, isBookmark in
                owner.bookmarkButton.configuration?.image = UIImage(systemName: isBookmark ? "bookmark.fill" : "bookmark")?
                    .withTintColor(R.Color.red, renderingMode: .alwaysOriginal)
            }
            .disposed(by: disposeBag)
        
        viewModel.bookmarkCount
            .bind(with: self) { owner, count in
                owner.bookmarkButton.configuration?.attributedTitle = AttributedString(
                    NSAttributedString(
                        string: count.formatted(),
                        attributes: [.font: R.Font.bold14, .foregroundColor: R.Color.brown]
                    )
                )
            }
            .disposed(by: disposeBag)
        
        viewModel.ratingCount
            .bind(with: self) { owner, rating in
                owner.ratingLabel.text = rating.formatted()
            }
            .disposed(by: disposeBag)
        
        viewModel.pushCommentView
            .bind(with: self) { owner, tuple in
                let view = BurgerHouseReviewScene.makeView(
                    postId: tuple.postId,
                    comments: tuple.comments
                )
                
                view.onChangeComments = { comments in
                    owner.viewModel.onChangeComments(comments: comments)
                    NotificationCenter.default.post(Notification(name: Notification.Name("UpdateReview")))
                }
                
                owner.present(view, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.changeBurgerMapTap
            .bind(with: self) { owner, burgerHouse in
                NotificationCenter.default.post(name: Notification.Name("MoveMap"), object: burgerHouse)
                owner.tabBarController?.selectedIndex = 0
            }
            .disposed(by: disposeBag)
        
        viewModel.pushProfileView
            .bind(with: self) { owner, type in
                let view = ProfileScene.makeView(profileType: type)
                owner.navigationController?.pushViewController(view, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.toastMessage
            .bind(with: self) { owner, message in
                owner.view.makeToast(message, duration: 1.5)
            }
            .disposed(by: disposeBag)
        
        viewModel.goToLogin
            .bind(with: self) { owner, _ in
                owner.goToLogin()
            }
            .disposed(by: disposeBag)
    }
}
