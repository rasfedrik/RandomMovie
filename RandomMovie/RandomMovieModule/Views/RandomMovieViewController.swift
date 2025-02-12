//
//  RandomMovieViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import UIKit

final class RandomMovieViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: RandomMoviewPresenterProtocol!
    private let randomButton = RandomButton(type: .randomMovie)
    private let startOverButton = RandomButton(type: .startOver)
    private let moviesViewWithCollectionView = RandomMoviesViewWithCollectionView()
    
    private let numberOfCells = 9
    private var updateIndexCount = 0
    private var movieIndexes: [Int] = []
    private var movieIndex: Int?
    
    private var moviesAddedAfterPressingButton: [PreviewForCollectionViewCellModel?] = []
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cornsilk
        fillingAnArray()
        randomButton.addTarget(self,
                               action: #selector(randomMovieTapped),
                               for: .touchUpInside)
        startOverButton.addTarget(self,
                                  action: #selector(startOverTapped),
                                  for: .touchUpInside)
        setupCollectionView()
        setupButtons()
    }
    
    // MARK: - Methods
    @objc private func randomMovieTapped() {
        presenter.getData()
    }
    
    @objc private func startOverTapped() {
        updateIndexCount = 0
        fillingAnArray()
        randomButton.isEnabled = true
    }
    
    private func fillingAnArray() {
        var count = 0
        moviesAddedAfterPressingButton = []
        moviesViewWithCollectionView.collectionView.reloadData()
        
        let movie = PreviewForCollectionViewCellModel(name: nil, alternativeName: nil, poster: nil)
        
        while count != numberOfCells {
            moviesAddedAfterPressingButton.append(movie)
            count += 1
        }
    }
    
    private func addingToCell(movie: PreviewForCollectionViewCellModel) {
        updateIndexCount += 1
        for (index, _) in moviesAddedAfterPressingButton.enumerated() {
            if (index + 1) == updateIndexCount {
                moviesAddedAfterPressingButton.remove(at: index)
                moviesAddedAfterPressingButton.insert(movie, at: index)
            }
        }
        isEnableRandomButton()
    }
    
    private func isEnableRandomButton() {
        if updateIndexCount == numberOfCells {
            updateIndexCount = 1
            randomButton.isEnabled = false
            randomButton.backgroundColor = .systemGray4
        }
    }
    
    // MARK: - Constraints
    private func setupCollectionView() {
        view.addSubview(moviesViewWithCollectionView)
        
        NSLayoutConstraint.activate([
            moviesViewWithCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            moviesViewWithCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            moviesViewWithCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            moviesViewWithCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8)
        ])
        
        moviesViewWithCollectionView.collectionView.delegate = self
        moviesViewWithCollectionView.collectionView.dataSource = self
    }
    
    private func setupButtons() {
        view.addSubview(randomButton)
        NSLayoutConstraint.activate([
            randomButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            randomButton.heightAnchor.constraint(equalToConstant: 60),
            randomButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            randomButton.topAnchor.constraint(equalTo: moviesViewWithCollectionView.bottomAnchor, constant: 10)
        ])
        
        view.addSubview(startOverButton)
        NSLayoutConstraint.activate([
            startOverButton.widthAnchor.constraint(equalTo: randomButton.widthAnchor),
            startOverButton.heightAnchor.constraint(equalToConstant: 60),
            startOverButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            startOverButton.topAnchor.constraint(equalTo: randomButton.topAnchor)
        ])
    }
    
}

extension RandomMovieViewController: RandomMovieViewProtocol {
    
    func success(posterData: Data?) {
        
        DispatchQueue.main.async {
            guard let presenterData = self.presenter.data else { return }
            guard let posterData = posterData else { return }
            guard let posterImage = UIImage(data: posterData) else { return }
            
            let movie = PreviewForCollectionViewCellModel(
                name: presenterData.name,
                alternativeName: presenterData.alternativeName,
                poster: posterImage
            )
            
            self.addingToCell(movie: movie)
            self.moviesViewWithCollectionView.collectionView.reloadData()
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
}

extension RandomMovieViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesAddedAfterPressingButton.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RandomCollectionViewCell.id,
            for: indexPath) as? RandomCollectionViewCell
        else { return UICollectionViewCell() }
        
        if let movie = moviesAddedAfterPressingButton[indexPath.item] {
            cell.configure(with: movie.poster ?? nil,
                           text: movie.name ?? movie.alternativeName)
        }
        
        return cell
    }
    
}

extension RandomMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let movie = moviesAddedAfterPressingButton[indexPath.row]
        
        if (movie?.name == nil || movie?.alternativeName == nil) && movie?.poster == nil {
            if !movieIndexes.contains(indexPath.row) {
                movieIndex = indexPath.row
                movieIndexes.append(indexPath.row)
            }
        } else {
            let detailViewController = ModuleBuilder.createMovieDetailsModule(movie: movie)
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

