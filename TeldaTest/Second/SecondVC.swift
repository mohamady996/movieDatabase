//
//  SecondVC.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 26/10/2024.
//

import UIKit
import RxSwift
import RxCocoa
import Combine
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
    
    //ThirdSection
    @IBOutlet weak var actorsCollectionView: UICollectionView!
    @IBOutlet weak var directorsCollectionView: UICollectionView!
    
    private let bag = DisposeBag()
    private let viewModel = SecondVM()
    var movieID = BehaviorSubject<Int?>(value: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindMovieID()
        bindFirstSection()
        bindSecondSection()
        bindThirdSection()
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
            
            if let url = URL(string: "https://image.tmdb.org/t/p/original\(movieDetails?.image ?? "")"), movieDetails?.image != nil {
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
        bindDirectorsCollectionView()
        bindActorsCollectionView()
    }
    
    private
    func bindActorsCollectionView() {
        self.actorsCollectionView.register(CastCell.nib(), forCellWithReuseIdentifier: CastCell.identifier)
        
        actorsCollectionView.rx.setDelegate(self).disposed(by: bag)
        
        viewModel.casts.map { items in
            // Apply filter, sort, and limit to first 5 items
            self.removeDuplicates(items: items)
                .filter { $0.knownForDepartment == "Acting" } // Filter Cast by Actors
                .sorted { $0.popularity ?? 0.0 > $1.popularity ?? 0.0 } // Sort items by priority in descending order
                .prefix(5) // Limit to first 5 items
        }
        .map { Array($0) } // Convert to Array because prefix returns a SubSequence
        .bind(to: actorsCollectionView.rx.items(cellIdentifier: CastCell.identifier, cellType: CastCell.self)) { (row,item,cell) in
            cell.configure(with: item)
        }.disposed(by: bag)
    }
    
    private
    func bindDirectorsCollectionView() {
        self.directorsCollectionView.register(CastCell.nib(), forCellWithReuseIdentifier: CastCell.identifier)
        
        directorsCollectionView.rx.setDelegate(self).disposed(by: bag)
        
        viewModel.directors.map { items in
            // Apply filter, sort, and limit to first 5 items
            self.removeDuplicates(items: items)
                .filter { $0.knownForDepartment == "Directing" } // Filter Cast by Directors
                .sorted { $0.popularity ?? 0.0 > $1.popularity ?? 0.0 } // Sort items by priority in descending order
                .prefix(5) // Limit to first 5 items
        }
        .map { Array($0) } // Convert to Array because prefix returns a SubSequence
        .bind(to: directorsCollectionView.rx.items(cellIdentifier: CastCell.identifier, cellType: CastCell.self)) { (row,item,cell) in
            cell.configure(with: item)
        }.disposed(by: bag)
    }
    
    private
    func removeDuplicates(items: [Cast]) -> [Cast] {
        let uniqueItems = Dictionary(grouping: items, by: { $0.id }).compactMap { $0.value.first }
        return uniqueItems
    }
    
}
