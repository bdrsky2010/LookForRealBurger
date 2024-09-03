//
//  PaymentRouter.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 9/3/24.
//

import Foundation

import Moya
// 66d6c7cedfc6560142283221
enum PaymentRouter {
    case payments(_ dto: PaymentRequestDTO)
}

extension PaymentRouter: LFRBTargetType {
    var path: String {
        return "v1/payments/validation"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .payments(let dto):
                return .requestParameters(parameters: dto.asParameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            LFRBHeader.authorization.rawValue: UserDefaultsAccessStorage.shared.accessToken,
            LFRBHeader.sesacKey.rawValue: APIKEY.lslp.rawValue,
            LFRBHeader.contentType.rawValue: LFRBHeader.json.rawValue
        ]
    }
    
    
}
