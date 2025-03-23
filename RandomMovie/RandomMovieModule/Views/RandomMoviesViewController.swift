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
    private var favoriteMovieIDs: [FavoriteMovieModel] = []
    private var moviesAddedAfterPressingButton: [MoviePreviewModel?] = []
    
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
        moviesAddedAfterPressingButton = []
        
        isButtonHidden = false
        buttonHidden()
        saveMovieToUserDefaults()
        
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
            navigationItem.rightBarButtonItem?.isHidden = false
        } else {
            randomButton.isHidden = true
            startOverButton.isHidden = false
            navigationItem.rightBarButtonItem?.isHidden = true
        }
    }
    
    private func saveMovieToUserDefaults() {
        let encoder = JSONEncoder()
        do {
            let encodedPreviews = try encoder.encode(moviesAddedAfterPressingButton)
            UserDefaults.standard.set(encodedPreviews, forKey: "savedPreviews")
            UserDefaults.standard.set(isButtonHidden, forKey: "isButtonHidden")
        } catch {
            print("Failed save to UserDefaults")
        }
        
    }
    
    private func loadMovieFromUserDefaults() {
        let decoder = JSONDecoder()
        
        if let favoriteMoviesData = UserDefaults.standard.data(forKey: "favoriteMovieIDs"),
           let favoriteMovies = try? decoder.decode([FavoriteMovieModel].self, from: favoriteMoviesData) {
            self.favoriteMovieIDs = favoriteMovies
        }
        
        if let savedPreviewsData = UserDefaults.standard.data(forKey: "savedPreviews"),
           let savedPreviews = try? decoder.decode([MoviePreviewModel].self, from: savedPreviewsData) {
            
            let savedIsButtonHidden = UserDefaults.standard.bool(
                forKey: "isButtonHidden")
            
            isButtonHidden = savedIsButtonHidden
            moviesAddedAfterPressingButton = savedPreviews
            updateIndexCount = moviesAddedAfterPressingButton.count
            moviesViewWithCollectionView.collectionView.reloadData()
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
            
            let previewMovie = MoviePreviewModel(
                id: presenterData.id,
                name: presenterData.name,
                alternativeName: presenterData.alternativeName,
                posterData: presenterData.getPosterImage(),
                rating: presenterData.rating,
                poster: presenterData.poster)
            
            self.moviesAddedAfterPressingButton.append(previewMovie)
            self.saveMovieToUserDefaults()
            self.moviesViewWithCollectionView.collectionView.reloadData()
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
}

extension RandomMoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesAddedAfterPressingButton.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RandomCollectionViewCell.id,
            for: indexPath) as? RandomCollectionViewCell
        else { return UICollectionViewCell() }
        
        if let movie = moviesAddedAfterPressingButton[indexPath.item] {
            let movieId = movie.id ?? 0
            
            cell.configure(with: movie.getPosterImage() ?? UIImage(named: "placeholder"),
                           text: movie.name ?? movie.alternativeName,
                           movieID: movieId,
                           isFavorite: favoriteMovieIDs.contains(where: { $0.id == movieId })
            )
            
            cell.favoriteMovieTapped = { [weak self] id, favorite in
                guard let self = self else { return }
                self.handleFavoriteTapped(movieID: id, isFavorite: favorite)
            }
            
        }
        return cell
    }
    
    private func handleFavoriteTapped(movieID: Int, isFavorite: Bool) {
        if isFavorite {
            favoriteMovieIDs.append(FavoriteMovieModel(id: movieID, isFavorite: isFavorite))
        } else {
            favoriteMovieIDs.removeAll(where: { $0.id == movieID })
        }
        let encoder = JSONEncoder()
        if let encodedFavoriteMovieId = try? encoder.encode(self.favoriteMovieIDs) {
            UserDefaults.standard.setValue(encodedFavoriteMovieId, forKey: "favoriteMovieIDs")
        }
    }
    
}

extension RandomMoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let posterData = moviesAddedAfterPressingButton[indexPath.row]
        guard let movieId = posterData?.id else { return }
        presenter.openDetails(movieId: movieId)
    }
}
