//
//  PlotViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.04.2025.
//

import UIKit

final class PlotViewController: BaseViewController {
    
    // MARK: - Properties
    var presenter: PlotPresenterProtocol!
    
    // MARK: - UI Elements
    private let descriptionLabel: BaseLabel = {
        let label = BaseLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.fetchPlot()
    }
    
    // MARK: - Constraints
    private func setupUI() {
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
}
    // MARK: - Extensions
extension PlotViewController: PlotViewControllerProtocol {
    
    func showWholePlot(model: MovieDetailsModel?) {
        guard let model = model else { return }
        descriptionLabel.text = model.description
    }
    
}
