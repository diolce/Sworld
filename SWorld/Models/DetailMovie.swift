//
//  DetailMovie.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 14/11/21.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class DetailMovie: Object, Codable {
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @Persisted var adult: Bool
    @Persisted var backdropPath: String?
    @Persisted var budget: Int
    @Persisted var genres = RealmSwift.List<Genre>()
    @Persisted var homepage: String?
    @Persisted var id: Int
    @Persisted var imdbID: String?
    @Persisted var originalLanguage: String?
    @Persisted var originalTitle: String?
    @Persisted var overview: String?
    @Persisted var popularity: Double?
    @Persisted var posterPath: String?
    @Persisted var productionCompanies =  RealmSwift.List<ProductionCompany>()
    @Persisted var productionCountries =  RealmSwift.List<ProductionCountry>()
    @Persisted var releaseDate: Date?
    @Persisted var revenue: Int //Ingresos
    @Persisted var runtime: Int?
    @Persisted var spokenLanguages = RealmSwift.List<SpokenLanguage>()
    @Persisted var status: String?
    @Persisted var tagline: String?
    @Persisted var title: String?
    @Persisted var video: Bool
    @Persisted var voteAverage: Double?
    @Persisted var voteCount: Int
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
        let list_genres = try container.decodeIfPresent([Genre].self, forKey: .genres)
        if let genres = list_genres {
            self.genres.append(objectsIn: genres)}
        self.id = try container.decode(Int.self, forKey: .id)
        self.imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
        self.originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        let list_companies = try container.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies)
        if let list_companies = list_companies {
            self.productionCompanies.append(objectsIn: list_companies)}
        let list_countries = try container.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries)
        if let list_countries = list_countries {
            self.productionCountries.append(objectsIn: list_countries)}
        let list_languages = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spokenLanguages)
        if let list_languages = list_languages {
            self.spokenLanguages.append(objectsIn: list_languages)}
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        let stringDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        let formatter = DateFormatter.yyyyMMdd
        if let date = formatter.date(from: stringDate!) {
            self.releaseDate = date
        } else {
            self.releaseDate = nil
            throw DecodingError.dataCorruptedError(forKey: .releaseDate,
                                                   in: container,
                                                   debugDescription: "Date string does not match format expected by formatter.")
        }
        
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        do {
            self.video = try container.decode(Bool.self, forKey: .video)
        } catch DecodingError.typeMismatch {
            self.video = ((try container.decode(Int.self, forKey: .video)) != 0)
        }
        do {
            self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        } catch DecodingError.typeMismatch {
            self.voteAverage = try Double(container.decodeIfPresent(Int.self, forKey: .voteAverage)!)
        }
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
        self.budget =  try container.decode(Int.self, forKey: .budget)
        self.revenue = try container.decode(Int.self, forKey: .revenue)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {}
    
    required override init() {
        super.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

@objcMembers class Genre: Object, Codable {
    @Persisted var id: Int
    @Persisted var name: String
}

@objcMembers class ProductionCompany: Object, Codable {
    @Persisted var id: Int
    @Persisted var logoPath: String?
    @Persisted var name: String
    @Persisted var originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

@objcMembers class ProductionCountry: Object, Codable {
    @Persisted var iso3166_1: String
    @Persisted var name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

@objcMembers class SpokenLanguage: Object, Codable {
    @Persisted var englishName: String
    @Persisted var iso639_1: String
    @Persisted var name: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
