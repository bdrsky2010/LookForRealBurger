//
//  CapsuleButton.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import UIKit

final class CapsuleButton: UIButton {
    init(title: String, backgroudColor: UIColor) {
        super.init(frame: .zero)
        
        configuration = .plain()
        configuration?.cornerStyle = .capsule
        configuration?.baseBackgroundColor = backgroudColor
        configuration?.attributedTitle = AttributedString(
            NSAttributedString(
                string: title,
                attributes: [
                    NSAttributedString.Key.font: R.Font.chab16,
                    NSAttributedString.Key.foregroundColor: R.Color.background
                ]
            )
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
