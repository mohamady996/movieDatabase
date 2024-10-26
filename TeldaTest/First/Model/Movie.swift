//
//  MovieDetails.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 26/10/2024.
//

import Foundation

struct MovieDetails: Decodable{
    var image: String
    var title: String
    var overview: String
    var tagLine: String
    var revenue: String
    var releaseDate: String
    var statues: String
    
    init(image: String, title: String, overview: String, tagLine: String, revenue: String, releaseDate: String, statues: String) {
        self.image = image
        self.title = title
        self.overview = overview
        self.tagLine = tagLine
        self.revenue = revenue
        self.releaseDate = releaseDate
        self.statues = statues
    }
    
}

// MARK: - Movie
struct MovieList: Codable {
    let page: Int?
    let movies: [Movie]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Movie: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
