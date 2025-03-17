//
//  FilterValueRangeView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 04.03.2025.
//

import UIKit

final class FilterValueRangeView: UIView {
    
    // MARK: - Categories
    enum Category: String, CaseIterable {
        case ratingKp = "rating.kp"
        case year = "year"
    }
    
    var onTextChange: ((String, String) -> Void)? {
        didSet {
            onTextChange?(minValue, maxValue)
        }
    }
    
    // MARK: - UI Elements
    private let nameCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var minValueTextField = BaseTextField()
    private var maxValueTextField = BaseTextField()
    private let stackView = BaseStackView()
    
    
    // MARK: - Properties
    private(set) var typeCategory: Category
    
    private var minValue = ""
    private var maxValue = ""
    private var currentMinValue: Float = 0.0
    
    // MARK: - Initializer
    init(type: Category) {
        self.typeCategory = type
        super.init(frame: .zero)
        setupTextFields()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameCategoryLabel)
        addSubview(stackView)
        
        stackView.addArrangedSubview(minValueTextField)
        stackView.addArrangedSubview(maxValueTextField)
        
        NSLayoutConstraint.activate([
            nameCategoryLabel.heightAnchor.constraint(equalToConstant: 20),
            nameCategoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            nameCategoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            nameCategoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            stackView.topAnchor.constraint(equalTo: nameCategoryLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupTextFields() {
        minValueTextField.delegate = self
        maxValueTextField.delegate = self
        
        minValueTextField.keyboardType = .decimalPad
        maxValueTextField.keyboardType = .decimalPad
        
        minValueTextField.keyboardAppearance = .dark
        maxValueTextField.keyboardAppearance = .dark
        
        setupInitialValues()
    }
    
    // MARK: - Setup and update values
    private func setupInitialValues() {
        switch typeCategory {
        case .ratingKp:
            minValue = "1"
            maxValue = "10"
            nameCategoryLabel.text = "Рейтинг Кинопоиска"
        case .year:
            let currentYear = String(Calendar.current.component(.year, from: Date()))
            minValue = "1960"
            maxValue = currentYear
            nameCategoryLabel.text = "Год"
        }
        
        minValueTextField.text = minValue
        maxValueTextField.text = maxValue
    }
    
    private func updateTextFieldValues() {
        switch typeCategory {
        case .ratingKp:
            updateValues(min: 1, max: 10)
        case .year:
            let currentYear = Calendar.current.component(.year, from: Date())
            updateValues(min: 1960, max: Float(currentYear))
        }
        onTextChange?(minValue, maxValue)
    }
    
    private func updateValues(min: Float, max: Float) {
        let minVal = minValueTextField.text?.replacingOccurrences(of: ",", with: ".") ?? ""
        let maxVal = maxValueTextField.text?.replacingOccurrences(of: ",", with: ".") ?? ""
        
        if let minValue = Int(minVal), Float(minValue) < min {
            self.minValueTextField.text = "\(Int(min))"
            self.minValue = "\(min)"
            self.currentMinValue = min
        } else if let minValue = Int(minVal), Float(minValue) > max {
            self.minValueTextField.text = "\(Int(max))"
            self.minValue = "\(max)"
            self.currentMinValue = max
        } else {
            self.minValue = minVal
            self.currentMinValue = Float(minValue) ?? 0
        }
        
        if let maxValue = Int(maxVal), Float(maxValue) > max {
            self.maxValueTextField.text = "\(Int(max))"
            self.maxValue = "\(max)"
        } else if let maxValue = Int(maxVal), Float(maxValue) < self.currentMinValue {
            self.maxValueTextField.text = "\(Int(max))"
            self.maxValue = "\(max)"
        } else {
            self.maxValue = maxVal
        }
    }
    
}

    // MARK: - Extension
extension FilterValueRangeView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextFieldValues()
    }
}
