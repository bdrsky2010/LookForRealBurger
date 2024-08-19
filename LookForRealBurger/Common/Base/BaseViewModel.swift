//
//  BaseViewModel.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/19/24.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
