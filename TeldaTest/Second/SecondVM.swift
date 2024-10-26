//
//  SecondVM.swift
//  TeldaTest
//
//  Created by mohamad ghonem on 26/10/2024.
//

import UIKit
import RxSwift
import RxCocoa

class SecondVM{

    //MARK: - Initialize ViewModel
    let movieDetails = BehaviorSubject<MovieDetails?>(value: nil)
    let similarMovies = BehaviorSubject<[SimilarMovieResult]>(value: [])
    private let bag = DisposeBag()
    private var id :Int?
    let casts = BehaviorSubject<[Cast]>(value: [])
    var castList: [Cast] = []
    let directors = BehaviorSubject<[Cast]>(value: [])
    var directorsList: [Cast] = []

    
    //MARK: - Initializers
    init() {
    }
    
    ///sets the movie ID
    func setup(movieID: Int) {
        self.id = movieID
        fetchMovieDetails()
        fetchSimilarMovies()
    }
    
    ///Fetches the movie Details
    func fetchMovieDetails(){
        let urlString = "https://api.themoviedb.org/3/movie/\(self.id!)"
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGVmMGVhNTc3ZDBjYjc4ZDdhYmU2MWRmMGI0MjE2MiIsIm5iZiI6MTcyOTk0ODA0NS40MDcyOTUsInN1YiI6IjY3MWNlMjNlOWZmNjgxZDllMGE0MzE0YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PuwiYyegT45tifVnUMlKF-dHLgrGs4yJR57WBSzq8rk"
          ]

        NetworkManager.shared.fetchData(from: urlString, method: .get, headers: headers)
            .subscribe(onSuccess: { [weak self] (movieDetailsResponse: MovieDetailsResponse) in
                let details = MovieDetails(movieDetailsResponse: movieDetailsResponse)
                self?.movieDetails.onNext( details )
                
                
            }, onFailure: { [weak self] apiError in
                self?.movieDetails.onNext( MovieDetails() )
            })
            .disposed(by: bag)
    }
    
    ///Fetches similar movies
    func fetchSimilarMovies(){
        let urlString = "https://api.themoviedb.org/3/movie/\(self.id!)/similar"
        let headers = [
            "accept": "application/json",
              "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGVmMGVhNTc3ZDBjYjc4ZDdhYmU2MWRmMGI0MjE2MiIsIm5iZiI6MTcyOTk0ODA0NS40MDcyOTUsInN1YiI6IjY3MWNlMjNlOWZmNjgxZDllMGE0MzE0YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PuwiYyegT45tifVnUMlKF-dHLgrGs4yJR57WBSzq8rk"
            ]
        
        NetworkManager.shared.fetchData(from: urlString, method: .get, headers: headers)
            .subscribe(onSuccess: { [weak self] (similarMoviesResponse: SimilarMoviesResponse) in
                
                self?.similarMovies.onNext( Array( similarMoviesResponse.similarMoviesResults?.prefix(5) ?? [] ))
                
                self?.fetchAllCast()
            }, onFailure: { [weak self] apiError in
                self?.similarMovies.onNext([])
            })
            .disposed(by: bag)
    }
    
    ///Fetches cast of the movie
    func fetchAllCast(){
        do {
            for movie in try similarMovies.value() {
                print("similar movie id: \(movie.id)")
                fetchCast(for: movie.id ?? 0)
            }
        }catch{
            print("Failed to retrieve items:", error)
        }
    }
    
    private
    func fetchCast(for id: Int){
        
        let urlString = "https://api.themoviedb.org/3/movie/\(id)/credits"
        let headers = [
            "accept": "application/json",
              "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGVmMGVhNTc3ZDBjYjc4ZDdhYmU2MWRmMGI0MjE2MiIsIm5iZiI6MTcyOTk0ODA0NS40MDcyOTUsInN1YiI6IjY3MWNlMjNlOWZmNjgxZDllMGE0MzE0YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PuwiYyegT45tifVnUMlKF-dHLgrGs4yJR57WBSzq8rk"
            ]
        NetworkManager.shared.fetchData(from: urlString, method: .get, headers: headers)
            .subscribe(onSuccess: { [weak self] (fetchCastResponse: FetchCastResponse) in
                self?.castList.append(contentsOf: fetchCastResponse.cast ?? [])
                self?.casts.onNext(self?.castList ?? [])

                self?.directorsList.append(contentsOf: fetchCastResponse.crew ?? [])
                self?.directors.onNext(self?.directorsList ?? [])
            }, onFailure: { [weak self] apiError in
                self?.casts.onNext([])
            })
            .disposed(by: bag)
    }

}
