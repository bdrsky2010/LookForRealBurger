//
//  BurgerReviewImageCell.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/30/24.
//

import UIKit

import RxSwift
import SnapKit

final class BurgerReviewImageCell: BaseCollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let multipleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.fill.on.square.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 14))
        imageView.isHidden = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        multipleImageView.isHidden = true
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(multipleImageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        multipleImageView.snp.makeConstraints { make in
            make.top.trailing.equalTo(imageView).inset(8)
        }
    }
}
