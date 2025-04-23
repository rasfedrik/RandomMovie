//
//  ActorsViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 22.04.2025.
//

import UIKit

final class ActorsViewController: BaseViewController {
    
    // MARK: - Properties
    var presenter: ActorsPresenterProtocol!
    
    // MARK: - UI Elements
    private let tableView = AllActorsTableView()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Актёры"
        presenter.fetchAllActors()
        setupUI()
    }
    
    // MARK: - Constraints
    private func setupUI() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
    // MARK: - Extensions
extension ActorsViewController: ActorsViewControllerProtocol {
    func showAllActors(model: MovieDetailsModel?) {
        if let persons = model?.persons {
            DispatchQueue.main.async {
                self.tableView.persons = persons
                self.tableView.reloadData()
            }
        }
    }
}
