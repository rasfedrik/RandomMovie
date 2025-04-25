//
//  RandomMoviesViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import UIKit

final class RandomMoviesViewController: BaseViewController {
    
    // MARK: - Properties
    var presenter: RandomMoviewPresenterProtocol!
    private let favoriteService = FavoriteService()
    
    // MARK: - Constants
    private var updateIndexCount = 0
    private var isButtonHidden = false
    private var isFavoriteMovie = false
    
    // MARK: - UI Elements
    private let moviesViewWithCollectionView = RandomMoviesViewWithCollectionView()
    private let randomButton = BaseButton(type: .randomMovie)
    private let startOverButton = BaseButton(type: .startOver)
    private let chooseRandomMovie = BaseButton(type: .chooseRandomMovie)
    private var filtersButtonItem: UIBarButtonItem!
    private let movieIsWinnerView = MovieWinnerView()
    private let overlayView = UIView()
    private let activityIndicator = UIActivityIndicatorView()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain, target: self, action: #selector(filtersButtonTapped))
        filtersButtonItem.tintColor = .mainButtonsColor
        navigationItem.rightBarButtonItem = filtersButtonItem
        loadMovieFromUserDefaults()
        configurationButtons()
        
        buttonHidden()
        setupCollectionView()
        setupButtons()
        setupMovieIsWinerView()
        moviesViewWithCollectionView.delegate = self
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
            guard let strongSelf = self else { return }
            strongSelf.randomMoviesTapped()
        }
        
        startOverButton.onTap = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.startOverTapped()
        }
        
        chooseRandomMovie.onTap = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.moviesViewWithCollectionView.delegate?.startRandomHighlighting()
        }
        
        movieIsWinnerView.onTap = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.overlayView.isHidden = true
        }
    }
    
    private func randomMoviesTapped() {
        isButtonHidden = true
        moviesViewWithCollectionView.randomMovies = []
        setupActivityIndicator()
        buttonHidden()
        
        presenter.loadRandomMovies { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.stopAnimating()
            strongSelf.activityIndicator.removeFromSuperview()
        }
        
        saveMovieToUserDefaults()
        setupMovieIsWinerView()
        moviesViewWithCollectionView.collectionView.reloadData()
    }
    
    private func startOverTapped() {
        isButtonHidden = false
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        presenter.cancelRequest()
        moviesViewWithCollectionView.randomMovies = []
        updateIndexCount = 0
        saveMovieToUserDefaults()
        setupMovieIsWinerView()
        buttonHidden()
    }
    
    @objc private func filtersButtonTapped() {
        presenter.openFilters()
    }
    
    private func setupActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .blue
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
    }
    
    private func buttonHidden() {
        if !isButtonHidden {
            randomButton.isHidden = false
            moviesViewWithCollectionView.collectionView.isHidden = true
            startOverButton.isHidden = true
            chooseRandomMovie.isHidden = true
            navigationItem.rightBarButtonItem?.isHidden = false
        } else {
            randomButton.isHidden = true
            moviesViewWithCollectionView.collectionView.isHidden = false
            startOverButton.isHidden = false
            chooseRandomMovie.isHidden = false
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
        
        view.addSubview(chooseRandomMovie)
        view.addSubview(startOverButton)
        NSLayoutConstraint.activate([
            chooseRandomMovie.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            chooseRandomMovie.heightAnchor.constraint(equalToConstant: 50),
            chooseRandomMovie.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseRandomMovie.bottomAnchor.constraint(equalTo: startOverButton.topAnchor, constant: -10),
            
            startOverButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            startOverButton.heightAnchor.constraint(equalToConstant: 50),
            startOverButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startOverButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupMovieIsWinerView() {
        movieIsWinnerView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = .black.withAlphaComponent(0.3)
        overlayView.isUserInteractionEnabled = true
        overlayView.isHidden = true
        
        view.addSubview(overlayView)
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        overlayView.addSubview(movieIsWinnerView)
        NSLayoutConstraint.activate([
            movieIsWinnerView.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 30),
            movieIsWinnerView.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 40),
            movieIsWinnerView.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -40),
            movieIsWinnerView.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -40)
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
    
    func winnerMovie(moviePreview: MoviePreviewModel?) {
        guard let presenterData = moviePreview else { return }
        self.movieIsWinnerView.configure(with: presenterData)
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
}

extension RandomMoviesViewController: RandomMoviesViewWithCollectionViewDelegate {
    func openDetailsDidTap(movie id: Int?) {
        self.presenter.openDetails(movieId: id)
    }
    
    func isFavoriteMovieDidTap(movie id: Int) {
        self.presenter.toggleFavorite(movieId: id)
    }
    
    func startRandomHighlighting() {
        chooseRandomMovie.isEnabled = false
        moviesViewWithCollectionView.startRandomHighlighting()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (0.3 + 0.15) * Double(presenter.numberOfCells) + 0.5) {
            self.chooseRandomMovie.isEnabled = true
            
            UIView.animate(withDuration: 0.6) {
                self.movieIsWinnerView.isHidden = false
                self.overlayView.isHidden = false
                self.movieIsWinnerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                self.movieIsWinnerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }
    }
    
    func lastMovie(id: Int?) {
        self.presenter.openMovieWinner(movieId: id)
    }
    
}
