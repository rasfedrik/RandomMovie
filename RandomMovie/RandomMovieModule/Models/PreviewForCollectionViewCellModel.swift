//
//  PreviewForCollectionViewCellModel.swift
//  RandomMovie
//
//  Created by Семён Беляков on 26.01.2025.
//

import UIKit

struct PreviewForCollectionViewCellModel: Codable, MoviewModelProtocol {
    let name: String?
    let alternativeName: String?
    let posterData: Data?
    
    init(name: String?, alternativeName: String?, poster: UIImage?) {
        self.name = name
        self.alternativeName = alternativeName
        self.posterData = poster?.jpegData(compressionQuality: 0.8)
    }
    
    func getPosterImage() -> UIImage? {
        guard let data = posterData else { return nil }
        return UIImage(data: data)
    }
}
