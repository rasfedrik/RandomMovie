//
//  FiltersViewController.swift
//  RandomMovie
//
//  Created by Семён Беляков on 20.02.2025.
//

import UIKit

final class FiltersViewController: BaseViewController {
    
    // MARK: - Properties
    var presenter: FiltersPresenterProtocol!
    private var filters = FiltersModel()
    private var isKeyboardVisible = false
    
    // MARK: - UI Elements
    private let applyFiltersButton = BaseButton(type: .applyFilters)
    private var ratingKpCategorie = FilterValueRangeView(type: .ratingKp)
    private var yearsCategorie = FilterValueRangeView(type: .year)
    private let genresButtonUpperStackView = BaseStackView()
    private let genresButtonLowerStackView = BaseStackView()
    
    // MARK: - ViewDidLoad and deinit
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Фильтры"
        applyFiltersButton.addTarget(self, action: #selector(applyFiltersTapped), for: .touchUpInside)
        createRatingKpCategory()
        createYearsCategory()
        
        setupUI()
        addObserver()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    
    // MARK: - Objc methods
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard !isKeyboardVisible else { return }
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height / 2
        let safeAreaBottomInset = view.safeAreaInsets.bottom
        let offset = keyboardHeight - safeAreaBottomInset
        
        isKeyboardVisible = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -offset
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
        isKeyboardVisible = false
    }
    
    @objc private func applyFiltersTapped() {
        presenter.applyFilters(filters)
    }
    
    // MARK: - Methods
    private func createFilterButtons() -> [FilterGenreButton] {
        var filterGenres: [FilterGenreButton] = []
        let filterTypes = FilterGenreButton.ButtonsType.allCases
        
        for filter in filterTypes {
            let filterGenreButton = FilterGenreButton(type: filter)
            filterGenreButton.onTap = { [weak self] type in
                guard let strongSelf = self else { return }
                strongSelf.filters.genresFilter(type)
            }
            filterGenres.append(filterGenreButton)
        }
        return filterGenres
    }
    
    private func createRatingKpCategory() {
        ratingKpCategorie.onTextChange = { [weak self] minValue, maxValue in
            guard let strongSelf = self else { return }
            
            strongSelf.filters.ratingKp?.minValue = Float(minValue)
            strongSelf.filters.ratingKp?.maxValue = Float(maxValue)
            strongSelf.filters.ratingKp?.nameCategory = strongSelf.ratingKpCategorie.typeCategory.rawValue
        }
    }
    
    private func createYearsCategory() {
        yearsCategorie.onTextChange = { [weak self] minValue, maxValue in
            guard let strongSelf = self else { return }
            
            strongSelf.filters.years?.minValue = Float(minValue)
            strongSelf.filters.years?.maxValue = Float(maxValue)
            strongSelf.filters.years?.nameCategory = strongSelf.yearsCategorie.typeCategory.rawValue
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(ratingKpCategorie)
        view.addSubview(yearsCategorie)
        view.addSubview(genresButtonUpperStackView)
        view.addSubview(genresButtonLowerStackView)
        
        for (index, genre) in createFilterButtons().enumerated() {
            if ((index % 2) != 0) {
                genresButtonUpperStackView.addArrangedSubview(genre)
            } else {
                genresButtonLowerStackView.addArrangedSubview(genre)
            }
        }
        
        NSLayoutConstraint.activate([
            ratingKpCategorie.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            ratingKpCategorie.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            ratingKpCategorie.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            yearsCategorie.topAnchor.constraint(equalTo: ratingKpCategorie.bottomAnchor, constant: 10),
            yearsCategorie.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            yearsCategorie.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            genresButtonUpperStackView.topAnchor.constraint(equalTo: yearsCategorie.bottomAnchor, constant: 20),
            genresButtonUpperStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            genresButtonUpperStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            genresButtonUpperStackView.heightAnchor.constraint(equalToConstant: 40),
            
            genresButtonLowerStackView.topAnchor.constraint(equalTo: genresButtonUpperStackView.bottomAnchor, constant: 10),
            genresButtonLowerStackView.leadingAnchor.constraint(equalTo: genresButtonUpperStackView.leadingAnchor),
            genresButtonLowerStackView.trailingAnchor.constraint(equalTo: genresButtonUpperStackView.trailingAnchor),
            genresButtonLowerStackView.heightAnchor.constraint(equalTo: genresButtonUpperStackView.heightAnchor)
        ])
        
        view.addSubview(applyFiltersButton)
        NSLayoutConstraint.activate([
            applyFiltersButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            applyFiltersButton.heightAnchor.constraint(equalToConstant: 60),
            applyFiltersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyFiltersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
}
