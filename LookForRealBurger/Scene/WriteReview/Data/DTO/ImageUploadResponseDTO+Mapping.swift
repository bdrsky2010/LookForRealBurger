//
//  ImageUploadResponseDTO+Mapping.swift
//  LookForRealBurger
//
//  Created by Minjae Kim on 8/26/24.
//

import Foundation

struct ImageUploadResponseDTO: Decodable {
    let files: [String]
}

extension ImageUploadResponseDTO {
    func toDomain() -> UploadedImage {
        return UploadedImage(paths: self.files)
    }
}
