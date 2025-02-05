//
//  MovieDetailsViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import UIKit

final class MovieDetailsViewController: UIViewController {
    
    var presenter: MovieDetailsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange
        presenter.openMovieDetails()
    }
    
}

extension MovieDetailsViewController: MovieDetailsViewProtocol {
    
    func openMovie(details: RandomMovieModel?) {
        print(details?.name ?? "")
    }
    
}
