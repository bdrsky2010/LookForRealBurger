//
//  BorderRoundedSearchBar.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import UIKit

final class BorderRoundedSearchBar: UITextField {
    init(
        borderWidth: CGFloat,
        borderColor: UIColor,
        placeholder: String
    ) {
        super.init(frame: .zero)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        layer.cornerRadius = 10
        backgroundColor = .clear
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        leftViewMode = .always
        rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 0))
        rightViewMode = .always
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: R.Color.brown.withAlphaComponent(0.5)]
        )
        font = R.Font.bold18
        textColor = R.Color.brown
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
