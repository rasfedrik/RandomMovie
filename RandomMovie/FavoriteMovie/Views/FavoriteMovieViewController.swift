//
//  FavoriteMovieViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 15.02.2025.
//

import UIKit

final class FavoriteMovieViewController: BaseViewController {
    
    var presenter: FavoriteMoviePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(presenter.getDataFromUserDefaults().count)
    }
    
}
