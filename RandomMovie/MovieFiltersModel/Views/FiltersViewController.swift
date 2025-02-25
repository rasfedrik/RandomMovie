//
//  FiltersViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.02.2025.
//

import UIKit

final class FiltersViewController: BaseViewController {
    
    var presenter: FiltersPresenterProtocol!
    var randomPresenter: RandomMoviewPresenterProtocol!
    
    let applyFiltersButton = BaseButton(type: .applyFilters)
    let filters: [String:String] = ["year":"1920"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyFiltersButton.addTarget(self, action: #selector(applyFiltersTapped), for: .touchUpInside)
        setupUI()
    }
    
    @objc private func applyFiltersTapped() {
        print("FiltersVC")
        presenter.filters(filters)
        randomPresenter.fetchRandomMovie {
            print("Данные обновлены с учетом фильтров")
        }
        dismiss(animated: true)
    }
    
    private func setupUI() {
        view.addSubview(applyFiltersButton)
        NSLayoutConstraint.activate([
            applyFiltersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyFiltersButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            applyFiltersButton.heightAnchor.constraint(equalToConstant: 200),
            applyFiltersButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
