//
//  FirstVM.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 25/10/2024.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class FirstVM{
    
    //MARK: - Initialize ViewModel
    let movies = BehaviorSubject<[Movie]>(value: [])
    private let bag = DisposeBag()
    
    
    //MARK: - Initializers
    init() {
        fetchMovies()
    }
    
    ///Fetches the most popular movies
    func fetchMovies(){
        let urlString = "https://api.themoviedb.org/3/movie/popular"
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGVmMGVhNTc3ZDBjYjc4ZDdhYmU2MWRmMGI0MjE2MiIsIm5iZiI6MTcyOTk0ODA0NS40MDcyOTUsInN1YiI6IjY3MWNlMjNlOWZmNjgxZDllMGE0MzE0YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PuwiYyegT45tifVnUMlKF-dHLgrGs4yJR57WBSzq8rk"
          ]

        NetworkManager.shared.fetchData(from: urlString, method: .get, headers: headers)
            .subscribe(onSuccess: { [weak self] (movieList: MovieList) in
                self?.movies.onNext(movieList.movies ?? [])
            }, onFailure: { [weak self] apiError in
                self?.movies.onNext([])
            })
            .disposed(by: bag)
    }
    
    ///Fetches the movies with the searched name
    func searchMovies(name: String){
        let urlString = "https://api.themoviedb.org/3/search/movie"
        let headers = [
            "accept": "application/json",
              "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGVmMGVhNTc3ZDBjYjc4ZDdhYmU2MWRmMGI0MjE2MiIsIm5iZiI6MTcyOTk0ODA0NS40MDcyOTUsInN1YiI6IjY3MWNlMjNlOWZmNjgxZDllMGE0MzE0YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PuwiYyegT45tifVnUMlKF-dHLgrGs4yJR57WBSzq8rk"
            ]
        let queryItems = [
                    URLQueryItem(name: "query", value: name),
                    URLQueryItem(name: "include_adult", value: "false"),
                    URLQueryItem(name: "language", value: "en-US"),
                    URLQueryItem(name: "page", value: "1"),
                ]
        print(queryItems)
        print(urlString)
        NetworkManager.shared.fetchData(from: urlString, method: .get, headers: headers, queryItems: queryItems)
            .subscribe(onSuccess: { [weak self] (movieList: MovieList) in
                self?.movies.onNext(movieList.movies ?? [])
            }, onFailure: { [weak self] apiError in
                self?.movies.onNext([])
            })
            .disposed(by: bag)
    }
    
}



