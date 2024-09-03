//
//  BurgerMapReviewCollectionViewCell.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Kingfisher

final class BurgerMapReviewCollectionViewCell: BaseCollectionViewCell {
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
        label.font = R.Font.bold16
        label.textColor = R.Color.brown
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.regular12
        label.textColor = R.Color.orange
        return label
    }()
    
    private let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .createImageLayout())
    
    private let starImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysOriginal)
        imageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 14, weight: .bold))
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
        label.font = R.Font.bold16
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
    
    private var reviewImages: BehaviorRelay<[SectionImageType]> = BehaviorRelay(value: [])
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(headerView)
        headerView.addSubview(nickLabel)
        headerView.addSubview(dateLabel)
        contentView.addSubview(imageCollectionView)
        contentView.addSubview(titleView)
        titleView.addSubview(titleLabel)
        contentView.addSubview(bottomView)
        bottomView.addSubview(starImage)
        bottomView.addSubview(ratingLabel)
        bottomView.addSubview(contentLabel)
    }
    
    override func configureLayout() {
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        nickLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        nickLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(nickLabel.snp.trailing).offset(12)
            make.bottom.equalTo(nickLabel.snp.bottom)
            make.trailing.greaterThanOrEqualToSuperview().offset(-20)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageCollectionView.snp.width).multipliedBy(0.6)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(16)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        starImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(20)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(starImage.snp.trailing).offset(4)
            make.centerY.equalTo(starImage.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(starImage.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureUI() {
        imageCollectionView.register(
            BurgerMapReviewImageCell.self,
            forCellWithReuseIdentifier: BurgerMapReviewImageCell.identifier
        )
        imageCollectionView.backgroundColor = .clear
    }
    
    func configureContents(contents: BurgerHouseReview) {
        nickLabel.text = contents.creator.nick
        dateLabel.text = contents.createdAt.convertStringDate
        titleLabel.text = contents.title
        ratingLabel.text = contents.rating.formatted()
        contentLabel.text = contents.content
        
        reviewImages.accept([SectionImageType(items: contents.files)])
        
        let dataSources = RxCollectionViewSectionedReloadDataSource<SectionImageType> { dataSources, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BurgerMapReviewImageCell.identifier, for: indexPath) as? BurgerMapReviewImageCell else { return UICollectionViewCell() }
            
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
        
        reviewImages
            .bind(to: imageCollectionView.rx.items(dataSource: dataSources))
            .disposed(by: disposeBag)
    }
}
