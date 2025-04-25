//
//  RandomMoviesCollectionView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.01.2025.
//

import UIKit
import AudioToolbox

protocol RandomMoviesViewWithCollectionViewDelegate: AnyObject {
    func openDetailsDidTap(movie id: Int?) -> Void
    func isFavoriteMovieDidTap(movie id: Int) -> Void
    func startRandomHighlighting()
    func lastMovie(id: Int?)
}

final class RandomMoviesViewWithCollectionView: UIView {
    
    // MARK: - Properties
    private(set) var collectionView: UICollectionView!
    var randomMovies: [MoviePreviewModel?] = []
    weak var delegate: RandomMoviesViewWithCollectionViewDelegate?
    private var highlightTimer: Timer?
    
    // MARK: - Constants
    private let lineSpacing: CGFloat = 5
    private let interItemSpacing: CGFloat = 5
    private let horizontalInsets: CGFloat = 5
    private let numberOfPassesForAllCells = 3
    private var remainingIterations = 0
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let widthCell = (frame.size.width - interItemSpacing * 2 - horizontalInsets * 2) / 3
        let heightCell = widthCell * 1.5
        layout.itemSize = CGSize(width: widthCell, height: heightCell)
    }
    
    // MARK: - Configuration Collection View
    private func configureCollectionView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInsets, bottom: 0, right: horizontalInsets)
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interItemSpacing
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        
        collectionView.register(RandomCollectionViewCell.self,
                                forCellWithReuseIdentifier: RandomCollectionViewCell.id)
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func startRandomHighlighting() {
        highlightTimer?.invalidate()
        remainingIterations = randomMovies.count * numberOfPassesForAllCells
        
        highlightTimer = Timer.scheduledTimer(
            timeInterval: 0.15,
            target: self,
            selector: #selector(highlightRandomCell),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func playHighlightSound() {
        AudioServicesPlaySystemSound(1104)
    }
    
    @objc private func highlightRandomCell() {
        guard remainingIterations > 0 else {
            highlightTimer?.invalidate()
            return
        }
        
        remainingIterations -= 1
        
        let randomIndex = Int.random(in: 0..<randomMovies.count)
        guard let cell = collectionView.cellForItem(at: IndexPath(item: randomIndex, section: 0)) as? RandomCollectionViewCell else {
            return
        }

        cell.setHighlight(true)
        playHighlightSound()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            cell.setHighlight(false)
        }
        
        if remainingIterations == 0 {
            let id = randomMovies[randomIndex]?.id ?? 0
            delegate?.lastMovie(id: id)
        }
    }
    
}

extension RandomMoviesViewWithCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RandomCollectionViewCell.id,
            for: indexPath) as? RandomCollectionViewCell
        else { return UICollectionViewCell() }
        
        if let movie = randomMovies[indexPath.item] {
            cell.configure(with: movie)
            cell.favoriteMovieTapped = { [weak self] id in
                guard let strongSelf = self else { return }
                strongSelf.delegate?.isFavoriteMovieDidTap(movie: id)
            }
        }
        return cell
    }
    
}

extension RandomMoviesViewWithCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let posterData = randomMovies[indexPath.row]
        guard let movieId = posterData?.id else { return }
        
        self.delegate?.openDetailsDidTap(movie: movieId)
    }
}

