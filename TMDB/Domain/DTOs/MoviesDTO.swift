//
//  MoviesDTO.swift
//  TMDB
//
//  Created by Radwa Ahmed on 29/08/2023.
//

import Foundation

struct MoviesDTO: Decodable {
    let page : Int
    let noOfPages: Int
    let noOfMovies: Int
    let movies: [MovieDTO]
    
    enum CodingKeys: String, CodingKey {
        case page
        case noOfPages = "total_pages"
        case noOfMovies = "total_results"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.page = try container.decode(Int.self, forKey: .page)
        self.noOfPages = try container.decode(Int.self, forKey: .noOfPages)
        self.noOfMovies = try container.decode(Int.self, forKey: .noOfMovies)
        self.movies = try container.decode([MovieDTO].self, forKey: .movies)
    }
}

struct MovieDTO: Decodable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let averageVote: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case averageVote = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.averageVote = try container.decodeIfPresent(Double.self, forKey: .averageVote)
    }
}
