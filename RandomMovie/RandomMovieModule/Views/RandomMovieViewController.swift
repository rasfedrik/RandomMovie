//
//  RandomMovieViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import UIKit

final class RandomMovieViewController: UIViewController {
    
    var presenter: RandomMoviewPresenterProtocol!
    private let randomButton = RandomButton(type: .randomMovie)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(randomButton)
        self.randomButton.addTarget(self, 
                                    action: #selector(randomMovieTapped),
                                    for: .touchUpInside)
        
        addConstrains()
        
    }
    
    @objc private func randomMovieTapped() {
        self.presenter.getData()
    }
    
    private func addConstrains() {
        NSLayoutConstraint.activate([
            randomButton.widthAnchor.constraint(equalToConstant: 180),
            randomButton.heightAnchor.constraint(equalToConstant: 60),
            randomButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension RandomMovieViewController: RandomMovieViewProtocol {
    
    func success() {
        DispatchQueue.main.async {
            guard let presenterData = self.presenter.data else { return }
            for data in presenterData {
                print(data.id ?? 0)
            }
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    
}

