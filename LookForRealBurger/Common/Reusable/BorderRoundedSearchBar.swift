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
        placeholder: String?
    ) {
        super.init(frame: .zero)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = 10
        self.backgroundColor = .clear
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        self.font = R.Font.bold16
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
