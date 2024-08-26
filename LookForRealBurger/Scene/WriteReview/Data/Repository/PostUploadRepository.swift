//
//  PostUploadRepository.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

protocol PostUploadRepository {
    
}

final class DefaultPostUploadRepository {
    private let network: NetworkManager
    
    init(network: NetworkManager) {
        self.network = network
    }
}

extension DefaultPostUploadRepository: PostUploadRepository {
    
}
