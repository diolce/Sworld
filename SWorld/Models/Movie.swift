//
//  Movie.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 12/11/21.
//

import Foundation
import Realm
import RealmSwift

// MARK: - Result
@objcMembers class Movie: Object,Codable {
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    @Persisted var adult: Bool
    @Persisted var backdropPath: String?
    @Persisted var genreIDS: RealmSwift.List<Int>
    @Persisted var id: Int
    @Persisted var originalLanguage: String
    @Persisted var originalTitle: String
    @Persisted var overview: String
    @Persisted var popularity: Double
    @Persisted var posterPath: String?
    @Persisted var releaseDate: String?
    @Persisted var title: String
    @Persisted var video: Bool
    @Persisted var voteAverage: Double
    @Persisted var voteCount: Int
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        let list_genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS)
        if let genreIDS = list_genreIDS { self.genreIDS.append(objectsIn: genreIDS) }
        self.id = try container.decode(Int.self, forKey: .id)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        self.title = try container.decode(String.self, forKey: .title)
        do {
            self.video = try container.decode(Bool.self, forKey: .video)
        } catch DecodingError.typeMismatch {
            self.video = ((try container.decode(Int.self, forKey: .video)) != 0)
        }
        do {
            self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        } catch DecodingError.typeMismatch {
            self.voteAverage = try Double(container.decode(Int.self, forKey: .voteAverage))
        }
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)
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
