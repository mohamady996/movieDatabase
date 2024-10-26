//
//  MovieDetails.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 26/10/2024.
//


struct MovieDetails: Decodable{
    var image: String
    var title: String
    var overview: String
    var tagLine: String
    var revenue: String
    var releaseDate: String
    var status: String
    
    init() {
        image = ""
        title = ""
        overview = ""
        tagLine = ""
        revenue = ""
        releaseDate = ""
        status = ""
    }
    
    init(image: String, title: String, overview: String, tagLine: String, revenue: String, releaseDate: String, status: String) {
        self.image = image
        self.title = title
        self.overview = overview
        self.tagLine = tagLine
        self.revenue = revenue
        self.releaseDate = releaseDate
        self.status = status
    }
    init(movieDetailsResponse: MovieDetailsResponse) {
        self.image = movieDetailsResponse.backdropPath ?? ""
        self.title = movieDetailsResponse.title ?? ""
        self.overview = movieDetailsResponse.overview ?? ""
        self.tagLine = movieDetailsResponse.tagline ?? ""
        self.revenue = String(movieDetailsResponse.revenue ?? 0)
        self.releaseDate = movieDetailsResponse.releaseDate ?? ""
        self.status = movieDetailsResponse.status ?? ""
    }
    
}
