//
//  PretendardRoundedButton.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/21/24.
//

import UIKit

final class PretendardRoundedButton: UIButton {
    init(title: String, backgroudColor: UIColor) {
        super.init(frame: .zero)
        
        configuration = .borderedProminent()
        configuration?.baseBackgroundColor = backgroudColor
        configuration?.attributedTitle = AttributedString(
            NSAttributedString(
                string: title,
                attributes: [
                    NSAttributedString.Key.font: R.Font.bold20,
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
