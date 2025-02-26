//
//  RandomMovieViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 09.01.2025.
//

import UIKit

final class RandomMovieViewController: BaseViewController {
    
    // Спросить у нейронок про AsyncAway
    
    //enum Filter {
    //case year(Int)
    //case onlyNew(Bool)
    //case genre(String)
    //}
    //switch filtr {
    //case .year(let int):
    //
    //case .onlyNew(let bool):
    //
    //case .genre(let string):
    //
    //}
    
    // MARK: - Properties
    var presenter: RandomMoviewPresenterProtocol!
    private let randomButton = BaseButton(type: .randomMovie)
    private let startOverButton = BaseButton(type: .startOver)
    private var filtersButtonItem: UIBarButtonItem!
    private let moviesViewWithCollectionView = RandomMoviesViewWithCollectionView()
    private let queue = OperationQueue()
    
    private let numberOfCells = 2
    private var updateIndexCount = 0
    private var isButtonHidden = false
    
    private var moviesAddedAfterPressingButton: [PreviewForCollectionViewCellModel?] = []
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        randomButton.addTarget(self,
                               action: #selector(randomMoviesTapped),
                               for: .touchUpInside)
        startOverButton.addTarget(self,
                                  action: #selector(startOverTapped),
                                  for: .touchUpInside)
        
        filtersButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            style: .plain, target: self, action: #selector(filtersButtonTapped))
        filtersButtonItem.tintColor = .turquoise
        navigationItem.rightBarButtonItem = filtersButtonItem
        
//        loadRandomMovies()
        loadMovieFromUserDefaults()
        buttonHidden()
        setupCollectionView()
        setupButtons()
    }
    
    
    // MARK: - Methods
    @objc private func randomMoviesTapped() {
        isButtonHidden = true
        buttonHidden()
        
        loadRandomMovies()
        
        saveMovieToUserDefaults()
    }
    
    @objc private func startOverTapped() {
        queue.cancelAllOperations()
        presenter.cancelRequest()
        updateIndexCount = 0
        moviesAddedAfterPressingButton = []
        
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
        UserDefaults.standard.set(isButtonHidden,
                                  forKey: "isButtonHidden")
        let encoder = JSONEncoder()
        if let encodedPreviews = try? encoder.encode(moviesAddedAfterPressingButton) {
            UserDefaults.standard.set(encodedPreviews, forKey: "savedPreviews")
        }
    }
    
    private func loadMovieFromUserDefaults() {
        let decoder = JSONDecoder()
        if let savedPreviewsData = UserDefaults.standard.data(forKey: "savedPreviews"),
           let savedPreviews = try? decoder.decode([PreviewForCollectionViewCellModel].self, from: savedPreviewsData) {
            
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
extension RandomMovieViewController: RandomMovieViewProtocol {
    
    func success(moviePreview: PreviewForCollectionViewCellModel?) {
        DispatchQueue.main.async {
            guard let presenterData = moviePreview else { return }
            
            let previewMovie = PreviewForCollectionViewCellModel(
                id: presenterData.id,
                name: presenterData.name,
                alternativeName: presenterData.alternativeName,
                posterData: presenterData.getPosterImage(),
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
            cell.configure(with: movie.getPosterImage() ?? UIImage(named: "placeholder"),
                           text: movie.name ?? movie.alternativeName)
        }
        
        return cell
    }
    
}

extension RandomMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let posterData = moviesAddedAfterPressingButton[indexPath.row]
        guard let movieId = posterData?.id else { return }
        presenter.openDetails(movieId: movieId)
    }
}
