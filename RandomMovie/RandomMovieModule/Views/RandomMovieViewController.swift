//
//  RandomMovieViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import UIKit

final class RandomMovieViewController: BaseViewController {
    
    // MARK: - Properties
    var presenter: RandomMoviewPresenterProtocol!
    private let randomButton = RandomButton(type: .randomMovie)
    private let startOverButton = RandomButton(type: .startOver)
    private let moviesViewWithCollectionView = RandomMoviesViewWithCollectionView()
    
    private let numberOfCells = 9
    private var updateIndexCount = 0
    
    private var moviesAddedAfterPressingButton: [PreviewForCollectionViewCellModel?] = []
    private var goToDescriptionMovie: [RandomMovieModel?] = []
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        randomButton.addTarget(self,
                               action: #selector(randomMovieTapped),
                               for: .touchUpInside)
        startOverButton.addTarget(self,
                                  action: #selector(startOverTapped),
                                  for: .touchUpInside)
        loadMovieFromUserDefaults()
        setupCollectionView()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Methods
    @objc private func randomMovieTapped() {
        presenter.getData()
    }
    
    @objc private func startOverTapped() {
        updateIndexCount = 0
        saveMovieToUserDefaults()
        moviesAddedAfterPressingButton = []
        goToDescriptionMovie = []
        moviesViewWithCollectionView.collectionView.reloadData()
        randomButton.isEnabled = true
        saveMovieToUserDefaults()
    }
    
    private func addingToCell(movie: PreviewForCollectionViewCellModel?) {
        updateIndexCount += 1
        moviesAddedAfterPressingButton.append(movie)
        moviesViewWithCollectionView.collectionView.reloadData()
        
        if numberOfCells == updateIndexCount {
            randomButton.isEnabled = false
            randomButton.backgroundColor = .systemGray4
        }
        saveMovieToUserDefaults()
    }
    
    private func saveMovieToUserDefaults() {
        let encoder = JSONEncoder()
        if let encodedMovies = try? encoder.encode(goToDescriptionMovie),
           let encodedPreviews = try? encoder.encode(moviesAddedAfterPressingButton) {
            UserDefaults.standard.set(encodedMovies, forKey: "savedMovies")
            UserDefaults.standard.set(encodedPreviews, forKey: "savedPreviews")
        }
    }
    
    private func loadMovieFromUserDefaults() {
        let decoder = JSONDecoder()
        if let savedMoviesData = UserDefaults.standard.data(forKey: "savedMovies"),
           let savedMovies = try? decoder.decode([RandomMovieModel].self, from: savedMoviesData),
           let savedPreviewsData = UserDefaults.standard.data(forKey: "savedPreviews"),
           let savedPreviews = try? decoder.decode([PreviewForCollectionViewCellModel].self, from: savedPreviewsData) {
            goToDescriptionMovie = savedMovies
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
            
            let previewMovie = PreviewForCollectionViewCellModel(
                name: presenterData.name,
                alternativeName: presenterData.alternativeName,
                poster: posterImage
            )
            
            self.goToDescriptionMovie.append(presenterData)
            self.addingToCell(movie: previewMovie)
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
            cell.configure(with: movie.getPosterImage() ?? nil,
                           text: movie.name ?? movie.alternativeName)
        }
        
        return cell
    }
}

extension RandomMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = goToDescriptionMovie[indexPath.row]
        let detailViewController = ModuleBuilder.createMovieDetailsModule(movie: movie)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

