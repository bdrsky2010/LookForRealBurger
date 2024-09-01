//
//  MoreViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/2/24.
//

import Foundation

import RxCocoa
import RxSwift

protocol MoreInput {
    
}

protocol MoreOutput {
    
}

typealias MoreViewModel = MoreInput & MoreOutput

final class DefaultMoreViewModel: MoreOutput {
    
}

extension DefaultMoreViewModel: MoreInput {
    
}
