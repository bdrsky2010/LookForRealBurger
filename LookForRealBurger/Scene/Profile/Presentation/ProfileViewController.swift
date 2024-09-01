//
//  MyProfileViewController.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/22/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import RxGesture
import SnapKit
import Toast
import Tabman
import Pageboy
import Kingfisher

final class ProfileViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let burgerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "burger\(Int.random(in: 0...9))")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(reviewStackView)
        stackView.addArrangedSubview(followerStackView)
        stackView.addArrangedSubview(followingStackView)
        return stackView
    }()
    
    private lazy var reviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(reviewCountLabel)
        stackView.addArrangedSubview(reviewLabel)
        return stackView
    }()
    
    private let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.black14
        label.textColor = R.Color.brown
        label.textAlignment = .center
        label.text = "0"
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.bold14
        label.textColor = R.Color.brown
        label.textAlignment = .center
        label.text = "리뷰"
        return label
    }()
    
    private lazy var followerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(followerCountLabel)
        stackView.addArrangedSubview(followerLabel)
        return stackView
    }()
    
    private let followerCountLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.black14
        label.textColor = R.Color.brown
        label.textAlignment = .center
        label.text = "230"
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.bold14
        label.textColor = R.Color.brown
        label.textAlignment = .center
        label.text = "팔로워"
        return label
    }()
    
    private lazy var followingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(followingCountLabel)
        stackView.addArrangedSubview(followingLabel)
        return stackView
    }()
    
    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.black14
        label.textColor = R.Color.brown
        label.textAlignment = .center
        label.text = "450"
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.bold14
        label.textColor = R.Color.brown
        label.textAlignment = .center
        label.text = "팔로잉"
        return label
    }()
    
    private let followOrEditButton = PretendardRoundedButton(
        title: "",
        font: R.Font.chab20,
        backgroudColor: R.Color.orange
    )
    
    private lazy var profileReviewTabView = ProfileReviewTabViewController(profileType: profileType)
    
    private var viewModel: ProfileViewModel!
    private var disposeBag: DisposeBag!
    private var profileType: ProfileType!
    
    static func create(
        viewModel: ProfileViewModel,
        disposeBag: DisposeBag = DisposeBag(),
        profileType: ProfileType
    ) -> ProfileViewController {
        let view = ProfileViewController()
        view.viewModel = viewModel
        view.disposeBag = disposeBag
        view.profileType = profileType
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func configureNavigation() {
        if let first = navigationController?.viewControllers.first, first != self {
            setupBackButton()
        }
        
        navigationItem.title = "프로필"
        let moreButton = UIBarButtonItem(
            image: UIImage(named: "burger_menu")?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self, action: nil
        )
        
        navigationItem.rightBarButtonItem = moreButton
        
        switch profileType {
        case .me:
            break
        case .other:
            if #available(iOS 16.0, *) {
                navigationItem.rightBarButtonItem?.isHidden = true
            } else {
                navigationItem.rightBarButtonItem?.setValue(true, forKey: "hidden")
            }
        case .none:
            break
        }
    }
    
    override func configureHierarchy() {
        addChild(profileReviewTabView)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(burgerImage)
        contentView.addSubview(infoStackView)
        contentView.addSubview(followOrEditButton)
        contentView.addSubview(profileReviewTabView.view)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
            make.bottom.equalTo(profileReviewTabView.view.snp.bottom)
        }
        
        burgerImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.size.equalTo(100)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(burgerImage.snp.top).offset(8)
            make.leading.equalTo(burgerImage.snp.trailing).offset(30)
            make.trailing.equalToSuperview().inset(30)
        }
        
        followOrEditButton.snp.makeConstraints { make in
            make.leading.equalTo(burgerImage.snp.trailing).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.bottom.equalTo(burgerImage.snp.bottom).offset(-8)
            make.height.equalTo(infoStackView.snp.height)
        }
        
        profileReviewTabView.view.snp.makeConstraints { make in
            make.top.equalTo(burgerImage.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(550)
        }
    }
    
    override func configureUI() {
        burgerImage.layer.cornerRadius = 20
        burgerImage.layer.borderColor = R.Color.brown.cgColor
        burgerImage.layer.borderWidth = 2
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.tintColor = R.Color.red
        scrollView.refreshControl?.rx.controlEvent(.valueChanged)
            .bind(with: self) { owner, _ in
                owner.viewModel.profileRefresh()
            }
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController {
    private func bind() {
        navigationItem.leftBarButtonItem?.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.backButtonTap()
            }
            .disposed(by: disposeBag)
        
        followerStackView.rx
            .gesture(.tap())
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.followLabelTap(followType: .follow)
            }
            .disposed(by: disposeBag)
        
        followingStackView.rx
            .gesture(.tap())
            .when(.recognized)
            .bind(with: self) { owner, _ in
                owner.viewModel.followLabelTap(followType: .following)
            }
            .disposed(by: disposeBag)
        
        followOrEditButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.viewModel.followOrEditButtonTap()
            }
            .disposed(by: disposeBag)
        
        viewModel.setProfile
            .bind(with: self) { owner, profile in
                owner.navigationItem.title = "\(profile.nick)님의 프로필"
                owner.reviewCountLabel.text = profile.posts.count.formatted()
                owner.followerCountLabel.text = profile.followers.count.formatted()
                owner.followingCountLabel.text = profile.following.count.formatted()
            }
            .disposed(by: disposeBag)
        
        viewModel.setButtonTitle
            .bind(with: self) { owner, title in
                owner.followOrEditButton.configuration?.title = title
            }
            .disposed(by: disposeBag)
        
        viewModel.popPreviousView
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.endRefreshing
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                if let isRefreshing = owner.scrollView.refreshControl?.isRefreshing,
                   isRefreshing {
                    owner.scrollView.refreshControl?.endRefreshing()
                }
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
        
        viewModel.pushFollowView
            .bind(with: self) { owner, tuple in
                let view = ProfileScene.makeView(
                    followType: tuple.followType,
                    myUserId: tuple.myUserId,
                    followers: tuple.followers,
                    followings: tuple.followings
                )
                owner.navigationController?.pushViewController(view, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
