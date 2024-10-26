//
//  SimilarMovieCell.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 26/10/2024.
//

import UIKit

class SimilarMovieCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
   
    static let identifier:String = "SimilarMovieCell"
    
    static func nib()->UINib{
        return UINib(nibName: "SimilarMovieCell", bundle: nil)
    }
    
    func configure(with movie:SimilarMovieResult){

        if let url = URL(string: "https://image.tmdb.org/t/p/original\(movie.backdropPath ?? "")"), movie.backdropPath != nil {
            movieImage.kf.setImage(with: url)
        }else{
            movieImage.kf.setImage(with: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"))
        }
        movieTitle.text = movie.title
    }
}
