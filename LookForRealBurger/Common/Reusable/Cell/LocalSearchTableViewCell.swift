//
//  LocalSearchTableViewCell.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/25/24.
//

import UIKit

import RxSwift
import SnapKit

final class LocalSearchTableViewCell: BaseTableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let roadAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(roadAddressLabel)
        contentView.addSubview(phoneLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        roadAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(roadAddressLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    override func configureUI() {
        contentView.layer.cornerRadius = 10
    }
    
    func configureContent(with burgerHouse: BurgerHouse, color backgoroundColor: UIColor) {
        titleLabel.text = burgerHouse.name
        addressLabel.text = burgerHouse.address
        roadAddressLabel.text = burgerHouse.roadAddress
        phoneLabel.text = burgerHouse.phone
        contentView.backgroundColor = backgoroundColor
    }
}
