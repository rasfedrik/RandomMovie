//
//  .swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import UIKit

final class RandomMoviesViewController: BaseViewController {
    
    // MARK: - Properties
    var presenter: RandomMoviewPresenterProtocol!
    private let queue = OperationQueue()
    private let favoriteService = FavoriteService()
    
    // MARK: - Constants
    private let numberOfCells = 2
    private var updateIndexCount = 0
    private var isButtonHidden = false
    private var isFavoriteMovie = false
    
    // MARK: - UI Elements
    private let moviesViewWithCollectionView = RandomMoviesViewWithCollectionView()
    private let randomButton = BaseButton(type: .randomMovie)
    private let startOverButton = BaseButton(type: .startOver)
    private var filtersButtonItem: UIBarButtonItem!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain, target: self, action: #selector(filtersButtonTapped))
        filtersButtonItem.tintColor = .mainButtonsColor
        navigationItem.rightBarButtonItem = filtersButtonItem
        
        configurationButtons()
        
        loadMovieFromUserDefaults()
        buttonHidden()
        setupCollectionView()
        setupButtons()
        
        moviesViewWithCollectionView.onTap = { movieId in
            self.presenter.openDetails(movieId: movieId)
        }
        
        moviesViewWithCollectionView.isFavorite = { movieId in
            self.presenter.toggleFavorite(movieId: movieId)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moviesViewWithCollectionView.collectionView.reloadData()
    }
    
    // MARK: - Methods
    func updateFilters(_ filters: FiltersModel) {
        presenter.updateFilters(filters)
    }
    
    private func configurationButtons() {
        randomButton.onTap = { [weak self] in
            guard let self = self else { return }
            self.randomMoviesTapped()
        }
        
        startOverButton.onTap = { [weak self] in
            guard let self = self else { return }
            self.startOverTapped()
        }
    }
    
    private func randomMoviesTapped() {
        isButtonHidden = true
        buttonHidden()
        
        loadRandomMovies()
        
        saveMovieToUserDefaults()
    }
    
    private func startOverTapped() {
        queue.cancelAllOperations()
        presenter.cancelRequest()
        updateIndexCount = 0
        moviesViewWithCollectionView.randomMovies = []
        
        isButtonHidden = false
        buttonHidden()
        saveMovieToUserDefaults()
        
//        loadRandomMovies()
        
        moviesViewWithCollectionView.collectionView.reloadData()
    }
    
    @objc private func filtersButtonTapped() {
        presenter.openFilters()
    }
    
    private func loadRandomMovies() {
        queue.maxConcurrentOperationCount = 1
        
        for _ in (1...numberOfCells) {
            queue.addOperation {
                let group = DispatchGroup()
                group.enter()
                self.presenter.fetchRandomMovie {
                    group.leave()
                }
                group.wait()
            }
        }
    }
    
    private func buttonHidden() {
        if !isButtonHidden {
            randomButton.isHidden = false
            startOverButton.isHidden = true
            moviesViewWithCollectionView.collectionView.isHidden = true
            navigationItem.rightBarButtonItem?.isHidden = false
        } else {
            randomButton.isHidden = true
            startOverButton.isHidden = false
            moviesViewWithCollectionView.collectionView.isHidden = false
            navigationItem.rightBarButtonItem?.isHidden = true
        }
    }
    
    private func saveMovieToUserDefaults() {
        let encoder = JSONEncoder()
        do {
            let encodedPreviews = try encoder.encode(moviesViewWithCollectionView.randomMovies)
            UserDefaults.standard.set(encodedPreviews, forKey: KeysForUserDefaults.savedPreviewsKey)
            UserDefaults.standard.set(isButtonHidden, forKey: KeysForUserDefaults.isButtonHiddenKey)
        } catch {
            print("Failed save to UserDefaults")
        }
    }
    
    private func loadMovieFromUserDefaults() {
        let decoder = JSONDecoder()
        
        if let savedPreviewsData = UserDefaults.standard.data(forKey: KeysForUserDefaults.savedPreviewsKey),
           let savedPreviews = try? decoder.decode([MoviePreviewModel].self, from: savedPreviewsData) {
            
            let savedIsButtonHidden = UserDefaults.standard.bool(
                forKey: KeysForUserDefaults.isButtonHiddenKey)
            
            isButtonHidden = savedIsButtonHidden
            moviesViewWithCollectionView.randomMovies = savedPreviews
            updateIndexCount = moviesViewWithCollectionView.randomMovies.count
        }
        moviesViewWithCollectionView.collectionView.reloadData()
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
    }
    
    private func setupButtons() {
        view.addSubview(randomButton)
        NSLayoutConstraint.activate([
            randomButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            randomButton.heightAnchor.constraint(equalTo: randomButton.widthAnchor),
            randomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            randomButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
        ])
        view.addSubview(startOverButton)
        NSLayoutConstraint.activate([
            startOverButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            startOverButton.heightAnchor.constraint(equalToConstant: 60),
            startOverButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startOverButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
}

// MARK: - Extensions
extension RandomMoviesViewController: RandomMovieViewProtocol {
    
    func success(moviePreview: MoviePreviewModel?) {
        DispatchQueue.main.async {
            guard let presenterData = moviePreview else { return }
            self.moviesViewWithCollectionView.randomMovies.append(presenterData)
            self.saveMovieToUserDefaults()
            self.moviesViewWithCollectionView.collectionView.reloadData()
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
}
