//
//  SecondVC.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 26/10/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SecondVC: UIViewController, UIScrollViewDelegate {
    
    //First Section
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleValue: UILabel!
    @IBOutlet weak var overViewValue: UILabel!
    @IBOutlet weak var TagLineValue: UILabel!
    @IBOutlet weak var revenueValue: UILabel!
    @IBOutlet weak var releaseDateValue: UILabel!
    @IBOutlet weak var statusValue: UILabel!
    
    //Second Section
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    
    private let bag = DisposeBag()
    private let viewModel = SecondVM()
    var movieID = BehaviorSubject<Int?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindMovieID()
        bindFirstSection()
        bindSecondSection()
    }
    
    private
    func bindMovieID() {
        movieID.subscribe(onNext: { [weak self] movieID in
            guard let self else { return }
            if let id = movieID {
                self.viewModel.setup(movieID: id )
            }
        })
        .disposed(by: bag)
    }
    
    private
    func bindFirstSection() {
        
        self.viewModel.movieDetails.subscribe(onNext: { [weak self] movieDetails in
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w1280\(movieDetails?.image ?? "")"), movieDetails?.image != nil {
                self?.movieImage.kf.setImage(with: url)
            }else{
                self?.movieImage.kf.setImage(with: URL(string: "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg"))
            }
            
            self?.titleValue.text = movieDetails?.title
            self?.overViewValue.text = movieDetails?.overview
            self?.TagLineValue.text = movieDetails?.tagLine
            self?.revenueValue.text = movieDetails?.revenue
            self?.releaseDateValue.text = movieDetails?.releaseDate
            self?.statusValue.text = movieDetails?.status
        }).disposed(by: bag)
        
    }
    
    
    private
    func bindSecondSection() {
        self.similarMoviesCollectionView.register(SimilarMovieCell.nib(), forCellWithReuseIdentifier: SimilarMovieCell.identifier)
        
        similarMoviesCollectionView.rx.setDelegate(self).disposed(by: bag)
        
        viewModel.similarMovies.bind(to: similarMoviesCollectionView.rx.items(cellIdentifier: SimilarMovieCell.identifier, cellType: SimilarMovieCell.self)) { (row,item,cell) in
            cell.configure(with: item)
        }.disposed(by: bag)
        
    }
    
    private
    func bindThirdSection() {
        
    }
    
    
}
