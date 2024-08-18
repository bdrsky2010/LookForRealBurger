//
//  LFRBTargetType.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/18/24.
//

import Foundation

import Moya

protocol LFRBTargetType: TargetType { }

extension LFRBTargetType {
    var baseURL: URL { try! APIURL.lslp.rawValue.asURL() }
}
