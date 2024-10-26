//
//  ViewController.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 25/10/2024.
//

import UIKit
import RxSwift
import RxCocoa

class FirstVC: UIViewController {
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var moviesTableView: UITableView!
    
    private let bag = DisposeBag()
    private let viewModel = FirstVM()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        configureTableView()
        
        bindTF()
        
    }
    
    private
    func configureTableView() {
        self.moviesTableView.register(MovieCell.nib(), forCellReuseIdentifier: MovieCell.identifier)
        
        moviesTableView.rx.setDelegate(self).disposed(by: bag)
        
        viewModel.movies.bind(to: moviesTableView.rx.items(cellIdentifier: MovieCell.identifier, cellType: MovieCell.self)) { (row,item,cell) in
            cell.configure(with: item)
        }.disposed(by: bag)
        
        moviesTableView.rx.modelSelected(MovieResult.self).subscribe(onNext: { movie in
            print("SelectedItem: \(movie.title)")
            self.navigateToDetail(id: movie.id ?? 0)
        }).disposed(by: bag)
        
    }

    private
    func bindTF() {
        searchTF.rx.controlEvent(.editingDidEnd).subscribe(onNext: { _ in
            print("Ended")
            if let name = self.searchTF.text, !name.isEmpty {
                self.viewModel.searchMovies(name: name)
            }else{
                self.viewModel.fetchMovies()
            }
        }).disposed(by: bag)
        
        searchTF.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: { _ in
            
        }).disposed(by: bag)
    }

    @IBAction func searchBtnTapped(_ sender: Any) {
        if let name = self.searchTF.text, !name.isEmpty {
            self.viewModel.searchMovies(name: name)
        }else{
            self.viewModel.fetchMovies()
        }
    }
    
    private
    func navigateToDetail(id: Int) {
        let vc = UIStoryboard.init(name: "Second", bundle: Bundle.main).instantiateViewController(withIdentifier: "SecondVC") as? SecondVC
        vc?.movieID.onNext(id)
        
        // Push the new view controller
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension FirstVC: UITableViewDelegate {
    
}
