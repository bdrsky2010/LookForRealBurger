//
//  FollowListTableViewCell.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/2/24.
//

import UIKit

import SnapKit

final class FollowListTableViewCell: BaseTableViewCell {
    private let burgerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "burger\(Int.random(in: 0...9))")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nickLabel: UILabel = {
        let label = UILabel()
        label.font = R.Font.bold18
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(burgerImage)
        contentView.addSubview(nickLabel)
        
        burgerImage.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        
        nickLabel.snp.makeConstraints { make in
            make.centerY.equalTo(burgerImage.snp.centerY)
            make.leading.equalTo(burgerImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
        
        selectionStyle = .none
    }
    
    func setContent(nick: String, textColor: UIColor) {
        nickLabel.text = nick
        nickLabel.textColor = textColor
    }
}
