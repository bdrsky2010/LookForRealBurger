//
//  JoinUseCase.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import Foundation

final class JoinUseCase {
    private let joinRepository: JoinRepository
    private let emailValidRepository: EmailValidRepository
    
    init(
        joinRepository: JoinRepository,
        emailValidRepository: EmailValidRepository
    ) {
        self.joinRepository = joinRepository
        self.emailValidRepository = emailValidRepository
    }
}
