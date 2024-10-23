//
//  BurgerAnnotationView.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/28/24.
//

import UIKit
import MapKit

import SnapKit

final class BurgerAnnotationView: MKAnnotationView {
    private let backgroundView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.preferredSymbolConfiguration = .init(font: .systemFont(ofSize: 20))
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bounds.size = .init(width: 70, height: 70)
        backgroundView.center = .init(x: 35, y: 50)
    }
    
    override init(annotation: (any MKAnnotation)?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        canShowCallout = true
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubview(backgroundView)
        backgroundView.addSubview(imageView)
        backgroundView.addSubview(titleLabel)
    }
    
    func configureLayout() {
        backgroundView.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        guard let annotation = annotation as? CustomAnnotation else { return }
        guard let image = annotation.image else { return }
        
        imageView.image = UIImage(named: image)
        titleLabel.text = annotation.title
        
        setNeedsLayout()
    }
}
