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
    
    var allSimilarMovies: [SimilarMovieResult] = []
    
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
        
        fetchAllSimilarMovies()
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
                
//                self?.fetchAllCast()
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
    
    private
    func fetchAllSimilarMovies(){
        let urlString = "https://api.themoviedb.org/3/movie/\(self.id!)/similar"
        let dispatchGroup = DispatchGroup()
        let queryItems = (1...500).map { "\($0)" } // Create different query items
        let headers = [
            "accept": "application/json",
              "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGVmMGVhNTc3ZDBjYjc4ZDdhYmU2MWRmMGI0MjE2MiIsIm5iZiI6MTcyOTk0ODA0NS40MDcyOTUsInN1YiI6IjY3MWNlMjNlOWZmNjgxZDllMGE0MzE0YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PuwiYyegT45tifVnUMlKF-dHLgrGs4yJR57WBSzq8rk"
            ]
        
        for queryItem in queryItems {
            let queries = [URLQueryItem(name: "page", value: queryItem)]
            dispatchGroup.enter() // Enter the dispatch group for each request
            NetworkManager.shared.fetchData(from: urlString, method: .get, headers: headers, queryItems: queries).subscribe(onSuccess: { [weak self] (similarMoviesResponse: SimilarMoviesResponse) in
                
                self?.allSimilarMovies.append(contentsOf: similarMoviesResponse.similarMoviesResults ?? [])
                print("similar movies request completed")
                dispatchGroup.leave()
            }, onFailure: { [weak self] apiError in
                dispatchGroup.leave()
            }).disposed(by: bag)
        }
        
        // Notify when all requests are complete
        dispatchGroup.notify(queue: .main) {
            print("All similar movies request completed: \(self.allSimilarMovies.count)")
            self.fetchAllCastForAllSimilarMovies()
        }
    }
    
    private
    func fetchAllCastForAllSimilarMovies(){
        let dispatchGroup = DispatchGroup()
        var urls: [String] = []
        let headers = [
            "accept": "application/json",
              "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGVmMGVhNTc3ZDBjYjc4ZDdhYmU2MWRmMGI0MjE2MiIsIm5iZiI6MTcyOTk0ODA0NS40MDcyOTUsInN1YiI6IjY3MWNlMjNlOWZmNjgxZDllMGE0MzE0YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PuwiYyegT45tifVnUMlKF-dHLgrGs4yJR57WBSzq8rk"
            ]
        for movie in allSimilarMovies {
            let url = "https://api.themoviedb.org/3/movie/\(movie.id ?? 0)/credits"
        
            dispatchGroup.enter() // Enter the dispatch group for each request
            NetworkManager.shared.fetchData(from: url, method: .get, headers: headers).subscribe(onSuccess: { [weak self] (fetchCastResponse: FetchCastResponse) in
                
                self?.castList.append(contentsOf: fetchCastResponse.cast ?? [])
                self?.directorsList.append(contentsOf: fetchCastResponse.crew ?? [])
                print("cast request completed")
                dispatchGroup.leave()
            }, onFailure: { [weak self] apiError in
                dispatchGroup.leave()
            }).disposed(by: bag)
        }
        
        // Notify when all requests are complete
        dispatchGroup.notify(queue: .main) {
            print("All cast request completed: \(self.allSimilarMovies.count)")
            self.casts.onNext(self.castList ?? [])
            self.directors.onNext(self.directorsList ?? [])
        }
    }

}
