//
//  MovieDetailsViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import UIKit

final class MovieDetailsViewController: BaseViewController {
    
    var presenter: MovieDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.openMovieDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
}

extension MovieDetailsViewController: MovieDetailsViewProtocol {
    
    func openMovie(details: RandomMovieModel?) {
        print(details?.name ?? details?.alternativeName ?? "none")
    }
    
}
