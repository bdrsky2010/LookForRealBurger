//
//  LFRBHeader.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/17/24.
//

import Foundation

enum LFRBHeader: String {
    case authorization = "Authorization"
    case sesacKey      = "SesacKey"
    case refresh       = "Refresh"
    case contentType   = "Content-Type"
    case json          = "application/json"
    case multipart     = "multipart/form-data"
}
