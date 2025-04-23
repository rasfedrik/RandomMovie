//
//  AllActorsTableView.swift
//  RandomMovie
//
//  Created by Семён Беляков on 23.04.2025.
//

import UIKit

final class AllActorsTableView: UITableView {
    
    // MARK: - Properties
    var persons: [MovieDetailsModel.Person] = []
    
    // MARK: - Initializer
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = .clear
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupTableView() {
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
        register(AllActorsTableViewCell.self, forCellReuseIdentifier: AllActorsTableViewCell.identifier)
    }
    
}
    // MARK: - Extension
extension AllActorsTableView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < persons.count else {
            return UITableViewCell()
        }
        
        guard let cell = dequeueReusableCell(withIdentifier: AllActorsTableViewCell.identifier, for: indexPath) as? AllActorsTableViewCell
            else { return UITableViewCell() }
        
        let person = persons[indexPath.row]
        cell.configure(person: person)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
