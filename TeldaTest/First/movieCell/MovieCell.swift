//
//  movieCell.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 26/10/2024.
//

import UIKit
import Kingfisher

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImage:UIImageView!
    @IBOutlet weak var movieTitle:UILabel!
    @IBOutlet weak var movieOverView:UILabel!
    @IBOutlet weak var movieReleaseDate:UILabel!
    
    static let identifier:String = "MovieCell"
    
    static func nib()->UINib{
        return UINib(nibName: "MovieCell", bundle: nil)
    }
    
    func configure(with movie:MovieResult){
        self.selectionStyle = .none

        if let url = URL(string: "https://image.tmdb.org/t/p/w1280\(movie.backdropPath ?? "")"), movie.backdropPath != nil {
            movieImage.kf.setImage(with: url)
        }else{
            movieImage.kf.setImage(with: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"))
        }
        movieTitle.text = movie.title
        movieOverView.text = movie.overview
        movieReleaseDate.text = movie.releaseDate
    }
    
}
