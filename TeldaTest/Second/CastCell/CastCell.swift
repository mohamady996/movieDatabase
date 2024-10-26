//
//  CastCell.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 26/10/2024.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    @IBOutlet weak var castImage: UIImageView!
    @IBOutlet weak var castName: UILabel!

    static let identifier:String = "CastCell"
    
    static func nib()->UINib{
        return UINib(nibName: "CastCell", bundle: nil)
    }
    
    func configure(with cast:Cast){

        if let url = URL(string: "https://image.tmdb.org/t/p/original\(cast.profilePath ?? "")"), cast.profilePath != nil {
            castImage.kf.setImage(with: url)
        }else{
            castImage.kf.setImage(with: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"))
        }
        castName.text = cast.name
    }

}
