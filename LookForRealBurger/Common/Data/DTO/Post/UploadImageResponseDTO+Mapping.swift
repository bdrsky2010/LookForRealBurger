//
//  UploadImageResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

struct UploadImageResponseDTO: Decodable {
    let files: [String]
}

extension UploadImageResponseDTO {
    func toDomain() -> UploadedImage {
        return UploadedImage(paths: self.files)
    }
}
