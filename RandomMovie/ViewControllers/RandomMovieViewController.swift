//
//  RandomMovieViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import UIKit

final class RandomMovieViewController: UIViewController {
   private let networkDataFetch = NetworkDataFetch.share

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        networkDataFetch.fetchData(endPoint: .random,
                                   expecting: RandomMovieModel.self) { result in
            
            switch result {
            case .success(let data):
                print(data.name)
                
            case .failure(let error):
                print(error)
            }
        }
    }


}

