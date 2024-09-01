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
    
    private lazy var profileReviewTabView = ProfileReviewTabViewController(profileType: profileType)
    
    private var viewModel: ProfileViewModel!
    private var disposeBag: DisposeBag!
    private var profileType: ProfileType!
    
    static func create(
        viewModel: ProfileViewModel,
        disposeBag: DisposeBag = DisposeBag(),
        profileType: ProfileType!
    ) -> ProfileViewController {
        let view = ProfileViewController()
        view.viewModel = viewModel
        view.profileType = profileType
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.viewDidLoad()
    }
    
    override func configureNavigation() {
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
        contentView.addSubview(profileReviewTabView.view)
        
//        view.addSubview(burgerImage)
//        view.addSubview(infoStackView)
//        
//        view.addSubview(profileReviewTabView.view)
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
            make.centerY.equalTo(burgerImage.snp.centerY)
            make.leading.equalTo(burgerImage.snp.trailing).offset(30)
            make.trailing.equalToSuperview().inset(30)
        }
        
        profileReviewTabView.view.snp.makeConstraints { make in
            make.top.equalTo(burgerImage.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(600)
        }
        
//        burgerImage.snp.makeConstraints { make in
//            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
//            make.size.equalTo(100)
//        }
//        
//        infoStackView.snp.makeConstraints { make in
//            make.centerY.equalTo(burgerImage.snp.centerY)
//            make.leading.equalTo(burgerImage.snp.trailing).offset(30)
//            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
//        }
//        
//        profileReviewTabView.view.snp.makeConstraints { make in
//            make.top.equalTo(burgerImage.snp.bottom).offset(20)
//            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
    }
    
    override func configureUI() {
        burgerImage.layer.cornerRadius = 20
        burgerImage.layer.borderColor = R.Color.brown.cgColor
        burgerImage.layer.borderWidth = 2
    }
}

extension ProfileViewController {
    private func bind() {
        viewModel.setProfile
            .bind(with: self) { owner, profile in
                owner.navigationItem.title = "\(profile.nick)님의 프로필"
                owner.reviewCountLabel.text = profile.posts.count.formatted()
                owner.followerCountLabel.text = profile.followers.count.formatted()
                owner.followingCountLabel.text = profile.following.count.formatted()
            }
            .disposed(by: disposeBag)
    }
}
