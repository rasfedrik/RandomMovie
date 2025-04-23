//
//  MovieDetailsSection.swift
//  RandomMovie
//
//  Created by Семён Беляков on 17.04.2025.
//

import Foundation

enum MovieDetailSection: Int, CaseIterable {
    case poster
    case title
    case ratings
    case description
    case persons
//    case facts
//    case frames
    
    var title: String {
        switch self {
        case .poster:
            return ""
        case .title:
            return "Название"
        case .ratings:
            return "Рейтинг"
        case .description:
            return "Сюжет"
        case .persons:
            return "Актёры"
        }
    }
}

enum PosterItem: Hashable {
    case poster(movie: MovieDetailsModel)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .poster(let movie):
            hasher.combine("poster_\(movie)")
        }
    }
}

enum TitleItem: Hashable {
    case title(movie: MovieDetailsModel)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .title(let movie):
            hasher.combine("title_\(movie)")
        }
    }
}

enum RatingsItem: Hashable {
    case ratings(movie: MovieDetailsModel)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .ratings(let movie):
            hasher.combine("ratings_\(movie)")
        }
    }
}

enum DescriptionItem: Hashable {
    case description(movie: MovieDetailsModel)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .description(let movie):
            hasher.combine("description_\(movie)")
        }
    }
}


enum PersonItem: Hashable {
    case person(MovieDetailsModel.Person)
    
    var person: MovieDetailsModel.Person {
        switch self {
        case .person(let person): return person
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .person(let person):
            hasher.combine(person.id)
            hasher.combine(person.name)
            hasher.combine(person.photo)
            hasher.combine(person.description)
            hasher.combine(person.profession)
            hasher.combine(person.personPhotoData)
        }
    }
    
    static func == (lhs: PersonItem, rhs: PersonItem) -> Bool {
        switch (lhs, rhs) {
        case (.person(let lhsPerson), .person(let rhsPerson)):
            return lhsPerson.id == rhsPerson.id &&
            lhsPerson.name == rhsPerson.name &&
            lhsPerson.photo == rhsPerson.photo &&
            lhsPerson.description == rhsPerson.description &&
            lhsPerson.profession == rhsPerson.profession &&
            lhsPerson.personPhotoData == rhsPerson.personPhotoData
        }
    }
}
