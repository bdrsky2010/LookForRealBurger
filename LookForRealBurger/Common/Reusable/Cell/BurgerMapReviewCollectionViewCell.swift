//
//  BurgerMapReviewCollectionViewCell.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/29/24.
//

import UIKit

import RxSwift
import SnapKit
import Kingfisher

final class BurgerMapReviewCollectionViewCell: BaseCollectionViewCell {
    let nickLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .createImageLayout())
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var images: [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(nickLabel)
        contentView.addSubview(imageCollectionView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
    }
    
    override func configureLayout() {
        nickLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(nickLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageCollectionView.snp.width).multipliedBy(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func configureUI() {
        imageCollectionView.register(
            BurgerMapReviewImageCell.self,
            forCellWithReuseIdentifier: BurgerMapReviewImageCell.identifier
        )
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.backgroundColor = .clear
    }
}

extension BurgerMapReviewCollectionViewCell: UICollectionViewDelegate,
                                             UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BurgerMapReviewImageCell.identifier, for: indexPath) as? BurgerMapReviewImageCell else { return UICollectionViewCell() }
        let path = "v1/" + images[indexPath.row]
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
}
