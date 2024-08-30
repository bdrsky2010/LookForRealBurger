//
//  String+.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/14/24.
//

import Foundation

// MARK: Language Localization
extension String {
    var localized: Self {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ arguments: any CVarArg...) -> Self {
        return String(format: self.localized, arguments)
    }
}


extension String {
    var convertStringDate: String {
        let formatter = Date.formatter
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: self) ?? Date()
        formatter.locale = .init(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
}
