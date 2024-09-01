//
//  ReviewCommentTableViewCell.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/1/24.
//

import UIKit

import SnapKit

final class ReviewCommentTableViewCell: BaseTableViewCell {
    private let burgerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "burger\(Int.random(in: 0...9))")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nickLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.bold14
        label.textColor = R.Color.brown
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.regular14
        label.textColor = R.Color.brown
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.regular12
        label.textColor = R.Color.orange
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(burgerImage)
        contentView.addSubview(nickLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(dateLabel)
    }
    
    override func configureLayout() {
        burgerImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.top.equalTo(burgerImage.snp.top)
            make.leading.equalTo(burgerImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nickLabel.snp.bottom)
            make.leading.equalTo(nickLabel.snp.leading)
            make.trailing.equalToSuperview().inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom)
            make.leading.equalTo(contentLabel.snp.leading)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            burgerImage.layer.cornerRadius = burgerImage.bounds.width / 2
            burgerImage.layer.borderColor = R.Color.brown.cgColor
            burgerImage.layer.borderWidth = 2
        }
    }
    
    func configureContent(comment: Comment) {
        nickLabel.text = comment.creator.nick
        contentLabel.text = comment.content
        dateLabel.text = comment.createdAt.convertStringDate
    }
}
